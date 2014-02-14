module Cms
  class Cache
    def self.around(controller)
      controller_name = controller.class.to_s.sub('Controller', '').downcase
      action_name = controller.action_name.downcase
      cache_key = "#{controller_name}##{action_name}"
      body = Rails.cache.fetch(cache_key) do
        yield
        controller.response_body
      end
      controller.response_body = body
      controller.content_type = Mime[:html]
    end
  end
end
