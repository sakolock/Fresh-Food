require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'tilt/erubis'
require 'date'
require 'json'
# # required for Google Signin
# require 'google/apis/drive_v2'
# require 'google/api_client/client_secrets'
# use Rack::Session::Pool, :expire_after => 86400 # 1 day

# require "bundler/setup"

enable :sessions
set :session_secret, 'setme'

before do
  APP_NAME = "Fresh Food"
  session[:groceries] ||= []
  session[:categories] ||= ['Fruits & Vegetables', 'Meats', 'Dairy', 'Grains', 'Leftovers', 'Uncategorized']
  session[:days_until_expired] ||= 2
  @fridge_contents = session[:groceries]
end

helpers do
  def logged_in?
    session[:username]
  end

  def categories
    session[:categories]
  end

  def expired
    @fridge_contents = session[:groceries]
    session[:expired_food] = @fridge_contents.select { |item| Date.today >= Date.parse(item[:expires_on]) }
    session[:expired_food]
  end  

  def expiring_soon(days_until_expired)
    @fridge_contents = session[:groceries]
    session[:expiring_food] = @fridge_contents.select { |item| Date.today + days_until_expired.to_i >= Date.parse(item[:expires_on]) }
    session[:expiring_food]
  end
end

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

get '/' do
  @expiring_food = expiring_soon(session[:days_until_expired])
  erb :home, layout: :layout
end

# user settings
get '/settings' do
  if logged_in?
    erb :settings, layout: :layout
  else
    session[:error] = "Must be logged in to do that!"
    redirect '/'
  end
end


# get '/users/reset' do
#   token = params[:sptoken]
#   account = application.verify_password_reset_token token
#   #proceed to update session, display account, etc
# end

# adds item
post '/add-item' do
  # if logged_in?
    @fridge_contents = session[:groceries]
    new_food_item = params[:food].strip
    food_category = params[:category].strip
    days = params[:days].to_i
    d = Date.today
    expiration_date = (d + days).to_s

    @fridge_contents << { name: new_food_item, date_entered: d, category: food_category, expires_on: expiration_date }

    redirect '/'
  # else
  #   session[:error] = "Must be logged in to do that!"
  #   redirect '/'
  # end
end

# register
post '/users/register' do
  if logged_in?
    session[:message] = "You're already logged in!"
    redirect '/'
  elsif params[:password] != params[:confirm]
    session[:message] = "Passwords must match!"
    erb :signin
  else
    params[:password] == params[:confirm]
    File. session[:username] = params[:username]
    session[:password] = params[:password]
    session[:message] = "Hey! Welcome to the team!"
    redirect '/'
  end  
end

# sign in
post '/users/signin' do
  credentials = load_user_credentials  
  username = params[:username]
  password = params[:password]

  if valid_credentials?(username, password)
    session[:success] = "Welcome!"
    session[:username] = username

    redirect '/'
  else
    session[:error] = "No match! Please register or try again."
    erb :signin, layout: :layout
  end
end

# sign out
post '/signout' do
  session[:success] = "You have been signed out"
  session.clear

  redirect '/'
end
