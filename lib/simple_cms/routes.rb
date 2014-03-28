module Cms
  def self.public_routes(mapper, root_url)
    mapper.instance_eval do
      resources root_url,
      :as => 'public_cms_pages',
      :controller => 'cms_pages',
      :only => [:index] do
        collection do
          get '/:url', to: 'cms_pages#show', as: 'show'
        end
      end
    end
  end
end
