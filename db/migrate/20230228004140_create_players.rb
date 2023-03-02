class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :number
      t.string :nationality
      t.integer :age
      t.string :position

      t.references :team, null: true, foreign_key: true

      t.timestamps
    end
  end
end
