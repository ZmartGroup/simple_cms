require 'rubygems'
require 'authority'
require 'sanitize'
require "simple_cms/decorating_object"
require "simple_cms/cache"
require "simple_cms/engine"
require "simple_cms/helper"

module Cms
  mattr_accessor :route
  mattr_accessor :parent_controller
  mattr_accessor :layout
  mattr_accessor :authorizer_name
  mattr_accessor :controllers
  mattr_accessor :mailers
  mattr_accessor :email_preview_layout

  self.route = 'cms'
  self.parent_controller = ActionController::Base
  self.layout = './cms'
  self.authorizer_name = 'CmsAuthorizer'
  self.controllers = []
  self.mailers = []
  self.email_preview_layout = nil

  def self.setup
    yield self
  end
end
