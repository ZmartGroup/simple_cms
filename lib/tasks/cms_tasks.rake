namespace :cms do
  desc "Install migrations."
  task :install_migrations do
    Rake::Task['cms_engine:install:migrations'].invoke
  end

  desc "Install the plugin, including the migrations."
  task :install do
    Rake::Task['cms:install_initializer'].invoke
    Rake::Task['cms_engine:install:migrations'].invoke
  end

  task :install_initializer do
    require 'digest'
    filepath = Rails.root.join *%w(config initializers cms.rb)
    File.open(filepath, 'w') do |f|
      f << <<-CONFIG
Cms.setup do |config|
  self.route = 'cms'
  self.parent_controller = ActionController::Base
  self.layout = './cms'
  self.authorizer_name = 'CmsAuthorizer'
  self.controllers = []
  self.mailers = []
  self.email_preview_layout = nil

  config.controllers.each do |controller_name|
    controller = Kernel.const_get(controller_name)
    controller.around_action(Cms::Cache)
  end
end
CONFIG
    end
    puts <<-INFO
Cms initializer created with
  route: 'cms'
  parent_controller: ActionController::Base
  layout: './cms'
  authorizer_name: 'CmsAuthorizer'
  controllers: []
  mailers: []
  email_preview_layout: nil
Now run 'rake db:migrate'.
    INFO
  end
end
