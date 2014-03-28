Rails.application.routes.draw do
  resources :cms_texts, :only => [:index], path: Cms.route do
    collection do
      put 'update', to: 'cms_texts#update', as: 'update'
      get 'edit/:page_name', to: 'cms_texts#edit', as: 'edit'
      get 'edit-email/:email_name', to: 'cms_texts#edit_email', as: 'edit_email', email_name: /\d+/
      get 'preview-email/:email_name', to: 'cms_texts#preview_email', as: 'preview_email', email_name: /\d+/
      get 'edit-pdf-letter/:pdf_letter_index', to: 'cms_texts#edit_pdf_letter', as: 'edit_pdf_letter', pdf_letter_index: /\d+/
      get 'preview-pdf-letter/:pdf_letter_index', to: 'cms_texts#preview_pdf_letter', as: 'preview_pdf_letter', pdf_letter_index: /\d+/
    end
  end

  resources :manage_cms_pages,
  path: "#{Cms.route}/pages/", :only => [:create, :new, :edit, :update, :destroy],
  :as => 'cms_pages',
  :controller => 'cms_pages'
end
