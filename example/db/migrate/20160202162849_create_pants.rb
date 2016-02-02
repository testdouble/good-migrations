class CreatePants < ActiveRecord::Migration
  def change
    create_table :pants do |t|
      t.integer :length
      t.integer :inseam
    end
  end
end
