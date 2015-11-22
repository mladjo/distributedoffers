# ==============================
# PLP
# Frank Caron
# Feb 2015
#
# A simple Storefront and Fulfillment app for connecting to the Points LCP
# 
# ==============================

# |||| Depedencies ||||

require "sinatra"
require "rack-ssl-enforcer"
require "rest_client"
require "json"

# ------------------------------------------------------------------------------------------
# |||| Default Settings ||||
# ------------------------------------------------------------------------------------------

configure do
    # File locations
    set :views, Proc.new { File.join(settings.root, "/views") }
    set :public_folder, Proc.new { File.join(root, "static") }
    set :show_exceptions, true
    set :static_cache_control, [:public, max_age: 0]

    # Enable :sessions
    use Rack::Session::Pool
end

configure :production do
  use Rack::SslEnforcer
end

# ------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------
# Main Routes
# ------------------------------------------------------------------------------------------

# Permissions

before '/offer' do
    validate_session(session[:session],session[:sessionMember])
end


# Log In

get '/login' do
    kill_session()
    erb :login
end


get '/account/logout' do
    kill_session()
    erb :logout
end

# Offer

post '/offer' do
    #put member details in session
    session[:session] = true;
    session[:sessionMember] = params[:form];

    # Route to form
    @form = session[:sessionMember]
    erb :offer
end

# Catch All

get '/error' do
    erb :error
end

get '/*' do
    erb :index
end


# ------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------------------
# Helper functions

helpers do

  # =====================
  # Session Validator
  #
  # Used to validate that a session is legitimate for security.
  # ======================

  def validate_session(session,token)
    unless session  && token != ""
        redirect '/'
    end
  end

  # =====================
  # Session Killer
  #
  # Used to kill a session for logout, etc.
  # ======================

  def kill_session
    session[:session] = false
    session[:sessionToken] = ""
    session[:sessionMember] = ""
    session[:sessionMV] = ""
  end  

end