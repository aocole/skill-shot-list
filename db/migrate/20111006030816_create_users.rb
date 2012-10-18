class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :null => false
      t.string :password_hash, :null => false
      t.string :password_salt, :null => false
      t.boolean :admin, :null => false, :default => false
      t.string :persistence_token, :null => false
      t.integer :login_count, :null => false, :default => 0
      t.datetime :last_login_at
      t.string :initials

      t.timestamps
    end

    add_index(:users, :email, :unique => true)

  end

  def self.down
    remove_index :users, :email
    drop_table :users
  end
end
