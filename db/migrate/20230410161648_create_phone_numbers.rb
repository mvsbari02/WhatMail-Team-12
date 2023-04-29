class CreatePhoneNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :phone_numbers do |t|
      t.references :user, null: false, type: :integer, foreign_key: { on_delete: :cascade }
      t.string :phone_number, limit: 13, nil: false
      t.timestamps
    end
  end
end
