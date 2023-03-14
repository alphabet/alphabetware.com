class CreateMedias < ActiveRecord::Migration[6.1]
  def change
    create_table :medias do |t|
			t.string :message_id
			t.string :sid
			t.string :account_sid
			t.string :parent_sid
			t.string :content_type
			t.string :base_url
			t.string :uri
			t.datetime :downloaded_at
			t.datetime :destroyed_at
      t.timestamps null: false
    end
  end
end
