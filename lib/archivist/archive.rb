module Archivist
  module ArchiveMethods
    def self.included(base)
      base.class_eval do
        extend ArchiveClassMethods
        protected :get_klass,:get_klass_name,:get_klass_instance_methods,:build_proxy_method
      end
    end

    def method_missing(method,*args,&block)
      if get_klass_instance_methods.include?(method)
        build_proxy_method(method.to_s)
        self.method(method).call(*args,&block)
      else
        super(method,*args,&block)
      end
    end

    def respond_to?(method,include_private=false)
      if get_klass_instance_methods.include?(method)
        return true
      else
        super(method,include_private)
      end
    end

    def get_klass
      @klass ||= get_klass_name.constantize
    end
    
    def get_klass_name
      @klass_name ||= ([ '' ] + self.class.name.split('::')[0..-2]) * '::'
    end

    if RUBY_VERSION >= "1.9"
      def get_klass_instance_methods
        @klass_instance_methods ||= get_klass.instance_methods(false)
      end
    else
      def get_klass_instance_methods
        @klass_instance_methods ||= get_klass.instance_methods(false).map(&:to_sym)
      end
    end
    
    def build_proxy_method(method_name)
      class_eval <<-EOF
        def #{method_name}(*args,&block)
          instance = #{get_klass_name}.new(self.attributes.reject{|k,v| !#{get_klass.new.attribute_names.inspect}.include?(k.to_s)})
          instance.#{method_name}(*args,&block)
        end
      EOF
    end

    module ArchiveClassMethods;end
  end
end

