require 'pry'
require 'active_record'
require 'logger'
require 'sinatra'
require 'sinatra/reloader'

require_relative './functions'

class Blog < Sinatra::Base
  
  helpers do
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
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
    end
  end
  
  get "/" do
    @albums = Post.where("found = ?", 'f').order("created_at DESC").limit(9)
    erb :home
  end
  
  get "/found" do
    @albums = Post.where("found = ?", 't').order("created_at DESC").limit(9)
    erb :found
  end
  
  get "/city/:city" do
    @albums = Post.where("found = ?", 'f').where("city = ?", (params[:city]).capitalize).order("created_at DESC").limit(9)
    erb :home
  end
  
  get "/discover" do
    erb :discover
  end

  get "/donate" do
    erb :donate
  end
  
  get "/album/:id" do
    @album = Post.find(params[:id])
    @album_city = Post.where("found = ?", 'f').where("city = ?", @album.city)
    
    erb :album
  end
  
  get "/album/:id/edit" do
    protected!
    @album = Post.find(params[:id])
    
    erb :edit
  end
  
  get "/album/:id/found" do
    erb :found
  end
  
  get "/admin" do
    protected!
    erb :admin
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
    
    @album = Post.new({:album_title => album_title, :album_cover => album_cover, :album_review => album_review, :place_title => place_title, :place_description => place_description, :pinpoint_description => pinpoint_description, :rdio => rdio, :city => city, :hidden_place => hidden_place, :map => map, :pinpoint_map => pinpoint_map, :found => 0})
    @album.save
    
    redirect "/album/#{@album.id}"
  end
  
  post "/album/:id/edit" do
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
    
    album = Post.find(params[:id])
  
    album.update_attributes({:album_title => album_title, :album_cover => album_cover, :album_review => album_review, :place_title => place_title, :place_description => place_description, :pinpoint_description => pinpoint_description, :rdio => rdio, :city => city, :hidden_place => hidden_place, :map => map, :pinpoint_map => pinpoint_map})
    
    redirect to("/album/#{params[:id]}")
  end
  
  post "/album/:id/found" do
    album = Post.find(params[:id])
    
    if params[:found] == "FOUND"
      album.update_attributes({:found => 't'})
      redirect to("/")
    else
      redirect to("/album/#{params[:id]}")
    end
    
  end
  
  post "/album/:id/delete" do
    album = Post.find(params[:id])
    
    if params[:delete] == "DELETE"
      album.destroy
      redirect to("/")
    else
      redirect to("/album/#{params[:id]}")
    end
    
  end

end