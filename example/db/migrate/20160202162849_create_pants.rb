class CreatePants < ActiveRecord::Migration[4.2]
  def change
    create_table :pants do |t|
      t.integer :length
      t.integer :inseam
    end
  end
end
