class ChangePantsDangerously < ActiveRecord::Migration
  def up
    Pant.find_each do |pant|
      # uh oh!
    end
  end

  def down
  end
end
