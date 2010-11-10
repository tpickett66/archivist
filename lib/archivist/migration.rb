module Archivist
  module Migration
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.class_eval do
        class << self
          unless method_defined?(:method_missing_without_archive)
            alias_method(:method_missing_without_archive,:method_missing)
            alias_method(:method_missing, :method_missing_with_archive)
          end
        end
      end
    end

    module ClassMethods
      def method_missing_with_archive(method, *arguments, &block)
        method_missing_without_archive(method, *arguments, &block)
        allowed = [:add_column,:add_timestamps,:change_column,
                   :change_column_default,:change_table,:drop_table,
                   :remove_column, :remove_columns, :remove_timestamps,
                   :rename_column,:rename_table]
        return if arguments.include?(:deleted_at) || arguments.include?('deleted_at')
        
        if !arguments.empty? && allowed.include?(method)
          args = Marshal.load(Marshal.dump(arguments))
          args[0] = "archived_#{ActiveRecord::Migrator.proper_table_name(args[0])}"
          args[1] = "archived_#{args[1].to_s}" if method == :rename_table
          
          if ActiveRecord::Base.connection.table_exists?(args[0])
            ActiveRecord::Base.connection.send(method, *args, &block)
          end
        end
      end
    end
  end
end
