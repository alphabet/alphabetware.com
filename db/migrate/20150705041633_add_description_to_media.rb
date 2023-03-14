class AddDescriptionToMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :medias, :description, :string
		add_column :medias, :described_at, :datetime
  end
end
