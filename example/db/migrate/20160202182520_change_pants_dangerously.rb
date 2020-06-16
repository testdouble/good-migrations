class ChangePantsDangerously < ActiveRecord::Migration[4.2]
  def up
    Pant.find_each do |pant|
      # uh oh!
    end
  end

  def down
  end
end
