class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :name
      t.string :slug
      t.integer :content_type
      t.integer :user_id
      t.text :combobox_options

      t.timestamps null: false
    end
    add_index :custom_fields, :slug
    add_index :custom_fields, :user_id
  end
end
