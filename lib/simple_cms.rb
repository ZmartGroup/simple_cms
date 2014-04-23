require 'rubygems'
require 'authority'
require 'sanitize'
require "simple_cms/decorating_object"
require "simple_cms/cache"
require "simple_cms/engine"
require "simple_cms/helper"
require "simple_cms/routes"

module Cms
  mattr_accessor :route
  mattr_accessor :parent_controller
  mattr_accessor :layout
  mattr_accessor :authorizer_name
  mattr_accessor :controllers
  mattr_accessor :mailers
  mattr_accessor :pdf_letters
  mattr_accessor :email_preview_layout
  mattr_accessor :sub_page_layout
  mattr_accessor :sub_pages

  self.route = 'cms'
  self.parent_controller = ActionController::Base
  self.layout = './cms'
  self.sub_page_layout = './cms'
  self.authorizer_name = 'CmsAuthorizer'
  self.controllers = []
  self.mailers = []
  self.pdf_letters = []
  self.email_preview_layout = nil
  self.sub_pages = false

  def self.setup
    yield self
  end
end
