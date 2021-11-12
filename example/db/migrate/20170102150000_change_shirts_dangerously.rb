class ChangeShirtsDangerously < ActiveRecord::Migration[4.2]
  def up
    Shirt.find_each do |shirt|
      # uh oh!
    end
  end

  def down
  end
end
