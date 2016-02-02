class ChangePants < ActiveRecord::Migration
  class Pant < ActiveRecord::Base
  end
  def change
    Pant.all.each do |pant|
      # do a migration depending on the redefined Pant model
    end
  end
end
