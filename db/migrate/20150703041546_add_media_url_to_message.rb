class AddMediaUrlToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :media_url, :string
  end
end
