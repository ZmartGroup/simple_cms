class CmsPage < ActiveRecord::Base

  validates :url, presence: true, format: { with: /[\w\d+-_]*/ }
  validates :title, presence: true
  validates :body, presence: true

end
