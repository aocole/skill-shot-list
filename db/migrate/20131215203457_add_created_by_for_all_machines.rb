class AddCreatedByForAllMachines < ActiveRecord::Migration
  def up
    r = ActiveRecord::Base.connection.execute "select id from users order by id asc limit 1"
    user_id = r.first['id'].to_i
    ActiveRecord::Base.connection.execute "update machines set created_by_id = #{user_id} where created_by_id is null;"
  end
end
