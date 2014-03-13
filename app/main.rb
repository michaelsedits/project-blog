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
  end
  
  get "/" do
    @albums = Post.all
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
    
    erb :album
  end
  
  get "/album/:id/edit" do
    @album = Post.find(params[:id])
    
    erb :edit
  end
  
  get "/album/:id/found" do
    erb :found
  end
  
  get "/admin" do
    erb :admin
  end
  
  post "/album" do
    album_title = params[:album_title]
    album_cover = params[:album_cover]
    album_review = params[:album_review]
    place_title = params[:place_title]
    place_description = params[:place_description]
    rdio = params[:rdio]
    map = params[:map]
    
    @album = Post.new({:album_title => album_title, :album_cover => album_cover, :album_review => album_review, :place_title => place_title, :place_description => place_description, :rdio => rdio, :map => map})
    @album.save
    
    redirect "/album/#{@album.id}"
  end
  
  post "/album/:id/edit" do
    album_title = params[:album_title]
    album_cover = params[:album_cover]
    album_review = params[:album_review]
    place_title = params[:place_title]
    place_description = params[:place_description]
    rdio = params[:rdio]
    map = params[:map]
    
    album = Post.find(params[:id])
  
    album.update_attributes({:album_title => album_title, :album_cover => album_cover, :album_review => album_review, :place_title => place_title, :place_description => place_description, :rdio => rdio, :map => map})
    
    redirect to("/album/#{params[:id]}")
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