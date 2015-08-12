module PrefixStore
  class Railtie < Rails::Railtie
    initializer 'prefix_store.activerecord' do
      ActiveRecord::Base.send :include, PrefixStore
    end
  end
end