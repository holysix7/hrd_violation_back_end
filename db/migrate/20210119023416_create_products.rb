class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :product_code
      t.string :product_name
      t.integer :product_weight
      t.timestamps
    end
  end
end
