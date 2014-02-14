class IpConstraint
  def initialize
    @ips = Cms.allowed_ips
    if Rails.env.development?
      @ips += ['localhost', '127.0.0.1']
    end
  end

  def matches?(request)
    @ips.include?(request.remote_ip)
  end
end

Rails.application.routes.draw do
  constraints IpConstraint.new do
    resources :cms_texts, :only => [:index], path: Cms.route do
      collection do
        put 'update', to: 'cms_texts#update', as: 'update'
        get 'edit/:page_name', to: 'cms_texts#edit', as: 'edit'
      end
    end
  end
end
