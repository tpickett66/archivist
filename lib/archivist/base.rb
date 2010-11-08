module Archivist
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_archive(options={})
        class_eval(%Q{
          class Archive < ActiveRecord::Base
            self.record_timestamps = false
            self.table_name = "archived_#{self.table_name}"
          end})
      end

      def acts_as_archive(options={})
        has_archive(options)
      end
      
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
            connection.execute("DELETE FROM #{table_name} WHERE #{where}") if delete
          end
        end
      end
    end
  end
end
