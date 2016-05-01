class CreateContactCustomFieldValues < ActiveRecord::Migration
  def change
    create_table :contact_custom_field_values do |t|
      t.integer :contact_id
      t.integer :custom_field_id
      t.string :string_value
      t.text :text_value
      t.timestamps null: false
    end
  end
end
