class CreateShirts < ActiveRecord::Migration[4.2]
  def change
    create_table :shirts do |t|
      t.integer :size
      t.integer :color
    end
  end
end
