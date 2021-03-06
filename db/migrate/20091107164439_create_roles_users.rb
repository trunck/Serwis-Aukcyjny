class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :user, :null => false
      t.timestamps
    end
    execute "ALTER TABLE roles_users ADD CONSTRAINT fk_roles_user_1 FOREIGN KEY (user_id) REFERENCES users"
     execute "ALTER TABLE roles_users ADD CONSTRAINT fk_roles_user_2 FOREIGN KEY (role_id) REFERENCES roles"
  end

  def self.down
    execute "ALTER TABLE roles_users DROP CONSTRAINT fk_roles_user_1"
    execute "ALTER TABLE roles_users DROP CONSTRAINT fk_roles_user_2"
    drop_table :roles_users
  end
end
