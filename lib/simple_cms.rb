require "simple_cms/cache"
require "simple_cms/engine"
require "simple_cms/helper"

module Cms
  mattr_accessor :route
  mattr_accessor :username
  mattr_accessor :password
  mattr_accessor :controllers
  mattr_accessor :allowed_ips

  def self.setup
    yield self
  end
end
