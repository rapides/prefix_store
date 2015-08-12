require "prefix_store/version"
require 'prefix_store/railtie' if defined?(Rails)

module PrefixStore
  extend ActiveSupport::Concern

  module ClassMethods
    def prefix_store_accessor(store_attribute, *keys)
      keys = keys.flatten

      _store_accessors_module.module_eval do
        keys.each do |key|
          define_method("#{store_attribute}_#{key}=") do |value|
            write_store_attribute(store_attribute, key, value)
          end

          define_method("#{store_attribute}_#{key}") do
            read_store_attribute(store_attribute, key)
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
