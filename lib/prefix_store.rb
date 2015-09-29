require "prefix_store/version"
require 'prefix_store/railtie' if defined?(Rails)

module PrefixStore
  extend ActiveSupport::Concern

  module ClassMethods
    def prefix_store_accessor(store_attribute, *keys)
      keys = keys.flatten

      _store_accessors_module.module_eval do
        keys.each do |key|
          if key.class.eql?(Hash)
            nested_keys = key
            nested_keys.each do |k,vs|
              define_method("#{store_attribute}_#{k}=") do |value|
                write_store_attribute(store_attribute, k, value)
              end
              define_method("#{store_attribute}_#{k}") do
                read_store_attribute(store_attribute, k)
              end
              vs.each do |v|
                define_method("#{store_attribute}_#{k}_#{v}=") do |value|
                  accessor = store_accessor_for(store_attribute)
                  parent_value = accessor.read(self, store_attribute, k)
                  if parent_value.class.eql?(Hash) && value != parent_value[v.to_s]
                    self.public_send :"#{store_attribute}_will_change!"
                    self.public_send(store_attribute)[k.to_s][v.to_s] = value
                  end
                end
                define_method("#{store_attribute}_#{k}_#{v}") do
                  accessor = store_accessor_for(store_attribute)
                  accessor.read(self, store_attribute, k)[v.to_s]
                end
              end
            end
          else
            define_method("#{store_attribute}_#{key}=") do |value|
              write_store_attribute(store_attribute, key, value)
            end

            define_method("#{store_attribute}_#{key}") do
              read_store_attribute(store_attribute, key)
            end
          end
        end
      end

      # assign new store attribute and create new hash to ensure that each class in the hierarchy
      # has its own hash of stored attributes.
      self.local_stored_attributes ||= {}
      self.local_stored_attributes[store_attribute] ||= []
      self.local_stored_attributes[store_attribute] |= keys
    end
  end
end
