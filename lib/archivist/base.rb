module Archivist
  module Base
    def self.included(base)
      base.extend ArchiveMethods
    end

    module ArchiveMethods
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
    end
  end
end
