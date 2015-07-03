class AddMediaUrlToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :media_url, :string
  end
end
