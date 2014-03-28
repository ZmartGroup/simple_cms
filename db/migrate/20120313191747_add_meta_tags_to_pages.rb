class AddMetaTagsToPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :meta_description, :string
    add_column :cms_pages, :meta_keywords, :string
  end
end
