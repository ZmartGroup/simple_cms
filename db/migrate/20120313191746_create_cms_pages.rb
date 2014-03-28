class CreateCmsPages < ActiveRecord::Migration
  def up
    create_table :cms_pages do |t|
      t.string :url
      t.string :title
      t.text   :body
      t.timestamps
    end
    change_table :cms_pages do |t|
      t.index :url, :unique => true
    end
  end

  def down
    drop_table :cms_texts
  end
end
