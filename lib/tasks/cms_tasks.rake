namespace :cms do
  desc "Install the plugin, including the migration."
  task :install do
    Rake::Task['cms:install_initializer'].invoke
    Rake::Task['cms_engine:install:migrations'].invoke
  end

  task :install_initializer do
    require 'digest'
    username = 'contentmanager'
    password = (Digest::SHA2.new << rand.to_s).to_s[0..13]
    filepath = Rails.root.join *%w(config initializers cms.rb)
    File.open(filepath, 'w') do |f|
      f << <<-CONFIG
Cms.setup do |config|
  config.route = 'cms'
  config.username = '#{username}'
  config.password = '#{password}'
  config.controllers = []
  config.allowed_ips = []

  config.controllers.each do |controller_name|
    controller = Kernel.const_get(controller_name)
    controller.around_action(Cms::Cache)
  end
end
CONFIG
    end
    puts <<-INFO
Cms initializer created with
  route: cms
  username: #{username}
  password: #{password}
  controllers: []
  allowed_ips: []
Now run 'rake db:migrate'.
    INFO
  end
end
