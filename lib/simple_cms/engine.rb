module Cms

  class Engine < ::Rails::Engine

    if Rails.version >= '3.1'
      initializer :assets, :group => :all do
        cms_asset_root = Cms::Engine.root.join('app', 'assets').to_s
        Rails.application.config.assets.paths += ['/images', '/stylesheets', '/javascripts'].map {|a| cms_asset_root + a}
        Rails.application.config.assets.precompile += %w(cms/bootstrap.css cms/cms_landing.css cms/cms.css jhtml/jHtmlArea.png)
      end
    end
  end

end
