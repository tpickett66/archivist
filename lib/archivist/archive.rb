module Archivist
  module ArchiveMethods
    def self.included(base)
      base.class_eval do
        extend ArchiveClassMethods
        protected :get_klass
      end
    end

    def method_missing(method,*args,&block)
      klass = get_klass
      if /find/.match(method.to_s)
        return super
      elsif klass.instance_methods.include?(method.to_s)
        instance_id = self.id
        attrs = self.attributes.reject{|k,v| k.to_s == "deleted_at" || k.to_s == "id"}
        instance = klass.new(attrs)
        instance.id = instance_id
        return instance.send(method,*args,&block)
      else
        return super
      end
    end

    def respond_to?(method)
      klass = get_klass
      if klass.instance_methods.include?(method.to_s)
        return true
      else
        super
      end
    end

    def get_klass
      @klass ||= Kernel.const_get(self.class.to_s.split("::").first)
    end

    module ArchiveClassMethods
    end
  end
end

