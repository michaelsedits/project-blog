require 'pry'
require 'active_record'
require 'logger'
require 'sinatra'
require 'sinatra/reloader'

require_relative './functions'

class Blog < Sinatra::Base
  
  helpers do
    def title
      if @title
        "#{@title} | Unfound Sounds" 
      else
        "Unfound Sounds"
      end
    end
    
    def format_date(time)
     time.strftime("%B %d, %Y")
    end
    
    def h(text)
      Rack::Utils.escape_html(text)
    end
    
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['booty', 'city']
    end
  end
  
  get "/" do
    @unfound = Post.where("found = ?", 'f')
    if @unfound != []
      @albums = Post.where("found = ?", 'f').order("created_at DESC").limit(9)
      @found = Post.where("found = ?", 't')
      erb :home
    else
      @title = "Found Sounds"
    
      @albums = Post.where("found = ?", 't').order("created_at DESC").limit(9)
      erb :found
    end
  end
  
  get "/found" do
    @title = "Found Sounds"
    
    @albums = Post.where("found = ?", 't').order("created_at DESC").limit(9)
    erb :found
  end
  
  get "/city/:city" do
    @city = (params[:city]).capitalize
    @title = "Sounds in #{@city}"
    
    @albums = Post.where("found = ?", 'f').where("city = ?", params[:city]).order("created_at DESC").limit(9)
    erb :home
  end
  
  get "/discover" do
    @title = "Discover"
    
    erb :discover
  end

  get "/donate" do
    @title = "Donate"
    
    erb :donate
  end
  
  get "/album/:url" do
    @album = Post.find_by_url(params[:url])
    @title = "#{@album.album_title}"
    @album_city = Post.where("found = ?", 'f').where("city = ?", @album.city).where("id != ?", @album.id)
    
    erb :album
  end
  
  get "/album/:url/edit" do
    protected!
    @album = Post.find_by_url(params[:url])
    @title = "Edit #{@album.album_title}"
    
    erb :edit
  end
  
  get "/add" do
    protected!
    @title = "Add a new album"
    erb :add
  end
  
  post "/album" do
    album_title = params[:album_title]
    album_cover = params[:album_cover]
    album_review = params[:album_review]
    place_title = params[:place_title]
    place_description = params[:place_description]
    pinpoint_description = params[:pinpoint_description]
    rdio = params[:rdio]
    city = params[:city]
    hidden_place = params[:hidden_place]
    map = params[:map]
    pinpoint_map = params[:pinpoint_map]
    
    @album = Post.new({:album_title => album_title, :album_cover => album_cover, :album_review => album_review, :place_title => place_title, :place_description => place_description, :pinpoint_description => pinpoint_description, :rdio => rdio, :city => city, :hidden_place => hidden_place, :map => map, :pinpoint_map => pinpoint_map, :found => 0, :url => "#{album_title.gsub(' ', '-').gsub(/[^\w-]/, '').downcase}"})
    @album.save
    
    redirect "/album/#{@album.url}"
  end
  
  post "/album/:url/edit" do
    album_title = params[:album_title]
    album_cover = params[:album_cover]
    album_review = params[:album_review]
    place_title = params[:place_title]
    place_description = params[:place_description]
    pinpoint_description = params[:pinpoint_description]
    rdio = params[:rdio]
    city = params[:city]
    hidden_place = params[:hidden_place]
    map = params[:map]
    pinpoint_map = params[:pinpoint_map]
    
    album = Post.find_by_url(params[:url])
  
    album.update_attributes({:album_title => album_title, :album_cover => album_cover, :album_review => album_review, :place_title => place_title, :place_description => place_description, :pinpoint_description => pinpoint_description, :rdio => rdio, :city => city.gsub(' ', '-').gsub(/[^\w-]/, '').downcase, :hidden_place => hidden_place, :map => map, :pinpoint_map => pinpoint_map})
    
    redirect to("/album/#{params[:url]}")
  end
  
  post "/album/:url/found" do
    album = Post.find_by_url(params[:url])
    
    if params[:found] == "FOUND"
      album.update_attributes({:found => 't'})
      redirect to("/")
    else
      redirect to("/album/#{params[:url]}")
    end
    
  end
  
  post "/album/:url/delete" do
    album = Post.find_by_url(params[:url])
    
    if params[:delete] == "DELETE"
      album.destroy
      redirect to("/")
    else
      redirect to("/album/#{params[:url]}")
    end
    
  end

end