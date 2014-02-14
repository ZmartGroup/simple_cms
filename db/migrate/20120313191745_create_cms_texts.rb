class CreateCmsTexts < ActiveRecord::Migration
  def up
    create_table :cms_texts do |t|
      t.string :key
      t.text :value
      t.timestamps
    end
    change_table :cms_texts do |t|
      t.index :key, :unique => true
    end
  end

  def down
    drop_table :cms_texts
  end
end
