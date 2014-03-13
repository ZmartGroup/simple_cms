Rails.application.routes.draw do
  resources :cms_texts, :only => [:index], path: Cms.route do
    collection do
      put 'update', to: 'cms_texts#update', as: 'update'
      get 'edit/:page_name', to: 'cms_texts#edit', as: 'edit'
      get 'edit-email/:email_name', to: 'cms_texts#edit_email', as: 'edit_email', email_name: /\d+/
      get 'preview-email/:email_name', to: 'cms_texts#preview_email', as: 'preview_email', email_name: /\d+/
    end
  end
end
