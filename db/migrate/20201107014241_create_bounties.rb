class CreateBounties < ActiveRecord::Migration[6.0]
  def change
    create_table :bounties do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :company_name, null: false
      t.string :status, default: 'pending', null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
