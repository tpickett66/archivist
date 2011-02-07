module Archivist
  module ArchiveMethods
    def self.included(base)
      base.class_eval do
        extend ArchiveClassMethods
        protected :get_klass,:get_klass_name,:get_klass_instance_methods
      end
    end

    def method_missing(method,*args,&block)
      begin
        super(method,*args,&block) #try to let rails resolve the missing method first
      rescue NoMethodError => e
        if get_klass_instance_methods.include?(method.to_s) #check to see if there is a method available elsewhere
          instance = get_klass.new
          instance.id = self.id
          instance_attribute_names = instance.attribute_names
          attrs = self.attributes.select{|k,v| instance_attribute_names.include?(k.to_s)}
          instance.attributes= attrs,false
          instance.send(method,*args,&block)
        else
          raise e #finally bomb out if it's not going to work
        end
      end
    end
=begin
    def respond_to?(method,include_private=false)
      if get_klass_instance_methods.include?(method.to_s)
        return true
      else
        super(method,include_private)
      end
    end
=end
    def get_klass
      @klass ||= Kernel.const_get(get_klass_name)
    end
    
    def get_klass_name
      @klass_name ||= self.class.to_s.split("::").first
    end

    def get_klass_instance_methods
      @klass_instance_methods ||= get_klass.instance_methods(false)
    end

    module ArchiveClassMethods;end
  end
end

