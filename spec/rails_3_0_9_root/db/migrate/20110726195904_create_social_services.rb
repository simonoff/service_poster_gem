class CreateSocialServices < ActiveRecord::Migration
  def self.up
    create_table :social_services do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :fb_page_id
      t.timestamps
    end
  end

  def self.down
    drop_table :social_services
  end
end
