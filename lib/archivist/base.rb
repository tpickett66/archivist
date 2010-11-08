module Archivist
  module Base
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def has_archive(options={})
        class_eval <<-EOF
          alias_method :delete!, :delete
          
          class << self
            alias_method :delete_all!, :delete_all
          end
          
          class Archive < ActiveRecord::Base
            self.record_timestamps = false
            self.table_name = "archived_#{self.table_name}"
          end
        EOF
        include InstanceMethods
        extend ClassExtensions
      end

      def acts_as_archive(options={})
        has_archive(options)
      end
    end
    
    module InstanceMethods #these defs can't happen untill after we've aliased their respective originals
      def delete
        self.class.copy_to_archive({:id=>self.id}) unless new_record?
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

    module ClassExtensions #these can't get included in the class def untill after all aliases are done
      def copy_to_archive(conditions,delete=true)
        where = sanitize_sql(conditions)
        found = self.where(where)
        
        found.each do |m|
          self.transaction do # I would hate for something to happen in the middle of all of this
            attrs = m.attributes.merge(:deleted_at=>DateTime.now)
            
            if self::Archive.where(:id=>m.id).empty? #create a new one if necessary, else update
              self::Archive.create!(attrs)
            else
              self::Archive.where(:id=>m.id).first.update_attributes(attrs)
            end
            if where = "" && delete
              connection.execute("DELETE FROM #{table_name}")
            elsif delete
              connection.execute("DELETE FROM #{table_name} WHERE #{where}")
            end
          end
        end
      end
      
      def delete_all(conditions=nil)
        copy_to_archive(conditions)
      end
    end
  end
end
