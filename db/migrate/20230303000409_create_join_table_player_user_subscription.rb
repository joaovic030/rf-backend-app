class CreateJoinTablePlayerUserSubscription < ActiveRecord::Migration[7.0]
  def change
    create_join_table :players, :users, table_name: :player_user_subscriptions do |t|
      t.index [:player_id, :user_id]
      t.index [:user_id, :player_id]
    end
  end
end
