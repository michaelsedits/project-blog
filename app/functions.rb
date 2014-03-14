ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => (ENV['RACK_ENV'] == 'test') ? "blog.test" : "blog"
)

ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'posts'
    create_table :posts do |table|
      table.column :album_title, :string
      table.column :album_cover, :string
      table.column :album_review, :text
      table.column :place_title, :string
      table.column :place_description, :text
      table.column :pinpoint_description, :text
      table.column :rdio, :string
      table.column :city, :string
      table.column :hidden_place, :string
      table.column :map, :string
      table.column :pinpoint_map, :string
      table.column :created_at, :datetime
      table.column :found, :boolean
    end
  end
  
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  belongs_to :post
end