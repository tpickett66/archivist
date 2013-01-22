# Require sub-module's files
mods = File.join(File.dirname(__FILE__),"base","**","*.rb")
Dir.glob(mods).each do |mod|
  require mod
end

module Archivist
  module Base

    ARCHIVIST_DEFAULTS = {:associate_with_original=>false,:allow_multiple_archives=>false}

    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def has_archive(options={})
        options = ARCHIVIST_DEFAULTS.merge(options)
        options[:allow_multiple_archives] = true if options[:associate_with_original]

        class_eval(%Q{
          alias_method :delete!, :delete

          class << self
            alias_method :delete_all!, :delete_all

            def archive_indexes
              #{Array(options[:indexes]).collect{|i| i.to_s}.inspect}
            end

            def archive_options
              #{options.inspect}
            end

            def has_archive?
              true
            end

            def acts_as_archive?
              warn("DEPRECATION WARNING: #acts_as_archive is provided for compatibility with AAA and will be removed soon, please use has_archive?",caller )
              has_archive?
            end
          end

          class Archive < ActiveRecord::Base
            self.record_timestamps = false
            self.table_name = "archived_#{self.table_name}"
            self.primary_key = "#{self.primary_key}"
            include Archivist::ArchiveMethods
          end
          
          #{build_copy_self_to_archive(options[:allow_multiple_archives])}
        },File.expand_path(__FILE__),21)

        if ActiveRecord::VERSION::STRING >= "3.1.0"
          enable_archive_mass_assignment!(self)
        end

        attach_serializations!(self)
        include_modules!(self,options[:included_modules]) if options[:included_modules]

        build_associations!(self) if options[:associate_with_original]

        include InstanceMethods
        extend ClassExtensions
        include DB
      end

      def acts_as_archive(options={})
        has_archive(options)
      end

      def archive_for(klass)
        "#{klass.to_s}::Archive".constantize
      end

      def enable_archive_mass_assignment!(klass)
        archive_class = archive_for(klass)
        attrs = archive_class.attribute_names
        archive_class.send(:attr_accessible,*attrs.map(&:to_sym))
      end

      def attach_serializations!(klass)
        archive_class = archive_for(klass)
        klass.serialized_attributes.each do |column,type|
          archive_class.send(:serialize,column,type)
        end
      end

      def include_modules!(klass,modules)
        archive_class = archive_for(klass)
        [*modules].each do |mod|
          archive_class.send(:include,mod)
        end
      end

      def build_associations!(klass)
        archive_class = archive_for(klass)
        klass.send(:has_many,"archived_#{klass.table_name}".to_sym,:class_name => archive_class.to_s)
        archive_class.send(:belongs_to, klass.table_name.to_sym, :class_name => klass.to_s)
      end

      def build_copy_self_to_archive(allow_multiple=false)
        if allow_multiple #we put the original pk in the fk instead
          "def copy_self_to_archive
            self.class.transaction do
              attrs = self.attributes.merge(:deleted_at=>DateTime.now)
              archived = #{self.to_s}::Archive.new(attrs.reject{|k,v| k=='id'})
              archived.#{table_name.singularize}_id = attrs['id']
              #{yield_and_save}
            end
          end"
        else
          "def copy_self_to_archive
            self.class.transaction do #it would be really shitty for us to loose data in the middle of this
              attrs = self.attributes.merge(:deleted_at=>DateTime.now)
              archived = #{self.to_s}::Archive.new
              if archived.class.where(:id=>self.id).empty? #create a new one if necessary, else update
                archived.id = attrs[\"id\"]
                archived.attributes = attrs.reject{|k,v| k=='id'}
              else
                archived = archived.class.where(:id=>attrs[\"id\"]).first
                archived.update_attributes(attrs)
              end
              #{yield_and_save}
            end
          end"
        end
      end

      def yield_and_save
        "yield(archived) if block_given?
        archived.save"
      end
      
      private :include_modules!,:attach_serializations!, :build_associations!,
              :archive_for,:build_copy_self_to_archive,:yield_and_save
    end
    
    module InstanceMethods #these defs can't happen untill after we've aliased their respective originals

      def delete
        result = self.copy_self_to_archive unless new_record?
        self.delete! if result
        @destroyed = true
        freeze
      end
      
      def destroy
        _run_destroy_callbacks do
          self.delete
        end
      end
      
      def destroy!
        transaction do
          _run_destroy_callbacks do
            self.delete!
          end
        end
      end
    end

    module ClassExtensions #these can't get included in the class def until after all aliases are done
      def copy_to_archive(conditions,delete=true,&block)
        where = sanitize_sql(conditions)
        found = self.where(where)
        
        found.each do |m|
          result = m.copy_self_to_archive(&block)
          m.destroy! if delete && result
        end
      end
      
      def copy_from_archive(conditions,delete=true)
        where = sanitize_sql(conditions)
        where = where.gsub("#{table_name}","archived_#{table_name}") unless where.nil? || where =~ /archived/
        unless where == ""
          found = self::Archive.where(where)
        else
          found = self::Archive.all
        end

        found.each do |m|
          self.transaction do
            my_attribute_names = self.new.attribute_names
            #this should be Hash.select but 1.8.7 returns an array from select but a hash from reject... dumb
            attrs = m.attributes.reject{|k,v| !my_attribute_names.include?(k.to_s)} 

            if self.where(:id=>m.id).empty?
              new_m = self.create(attrs)
              connection.execute(%Q{UPDATE #{table_name} 
                                    SET #{self.primary_key} = #{m.id} 
                                    WHERE #{self.primary_key} = #{new_m.id}
                                   })
            else
              self.where(:id=>m.id).first.update_attributes(attrs)
            end
            m.destroy if delete  
          end
        end
      end

      def delete_all(conditions=nil)
        copy_to_archive(conditions)
      end

      def restore_all(conditions=nil)
        copy_from_archive(conditions)
      end
    end
  end
end
