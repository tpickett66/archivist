module Archivist
  module ArchiveMethods
    def self.included(base)
      base.class_eval do
        extend ArchiveClassMethods
        protected :get_klass,:get_klass_name,:get_klass_instance_methods,:build_proxy_method
      end
    end

    def method_missing(method,*args,&block)
      if get_klass_instance_methods.include?(method.to_s)
        build_proxy_method(method.to_s)
        self.method(method).call(*args,&block)
      else
        super(method,*args,&block)
      end
    end

    def respond_to?(method,include_private=false)
      if get_klass_instance_methods.include?(method.to_s)
        return true
      else
        super(method,include_private)
      end
    end

    def get_klass
      @klass ||= Kernel.const_get(get_klass_name)
    end
    
    def get_klass_name
      @klass_name ||= self.class.to_s.split("::").first
    end

    def get_klass_instance_methods
      @klass_instance_methods ||= get_klass.instance_methods(false)
    end
    
    def build_proxy_method(method_name)
      class_eval <<-EOF
        def #{method_name}(*args,&block)
          instance = #{get_klass_name}.new
          instance.id = self.id
          attrs = self.attributes.select{|k,v| #{get_klass.new.attribute_names.inspect}.include?(k.to_s)}
          instance.attributes= attrs,false
          instance.#{method_name}(*args,&block)
        end
      EOF
    end

    module ArchiveClassMethods;end
  end
end

