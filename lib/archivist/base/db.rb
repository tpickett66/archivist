module Archivist
  module Base
    module DB
      
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
        connection_class = base.connection.class.to_s.downcase

        if connection_class.include?("mysql")
          base.send(:extend, MySQL)
        elsif connection_class.include?("postgresql")
          base.send(:extend, PostgreSQL)
        else
          raise "DB type not supported by Archivist!"
        end
      end
      
      module ClassMethods
        def archive_table_exists?
          connection.table_exists?("archived_#{table_name}")
        end

        def create_archive_table
          if table_exists? && !archive_table_exists?
            cols = self.content_columns
            connection.create_table("archived_#{table_name}")
            cols.each do |c|
              connection.add_column("archived_#{table_name}",c.name,c.type)
            end
            connection.add_column("archived_#{table_name}",:deleted_at,:datetime)
          end
        end
      end

      module InstanceMethods
      end

      module MySQL
        private
        def archive_table_indexed_columns
          @indexes ||= connection.select_all("SHOW INDEX FROM archived_#{table_name}").collect{|r| r["Column_name"]}
        end
      end

      module PostgreSQL
        private
        def archived_table_indexed_columns
          @indexes ||= connection.indexes("archived_#{table_name}").map{|i| i.column_names}
        end
      end
    end
  end
end
