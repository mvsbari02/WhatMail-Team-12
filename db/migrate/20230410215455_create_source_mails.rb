class CreateSourceMails < ActiveRecord::Migration[6.1]
  def change
    create_table :source_mails do |t|
      t.references :user, null: false, type: :integer, foreign_key: { on_delete: :cascade }
      t.string   "email", limit: 128, null: false
      t.timestamps
    end
  end
end
