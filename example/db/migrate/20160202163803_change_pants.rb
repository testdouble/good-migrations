class ChangePants < ActiveRecord::Migration
  def change
    Pant.all.each do |pant|
      # do a migration depending on the Pant model
    end
  end
end
