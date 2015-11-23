# ==============================
# Distributed Offers
# Frank Caron, Mladen Rangelove
# Nov 2015
#
# A simple Storefront and Fulfillment app for connecting to the Points LCP
# 
# ==============================

# |||| Depedencies ||||

require "sinatra"
require "rack-ssl-enforcer"
require "rest_client"
require "json"

require "./utils/lcp_calls"

# ------------------------------------------------------------------------------------------
# |||| Default Settings ||||
# ------------------------------------------------------------------------------------------

configure do
    # File locations
    set :views, Proc.new { File.join(settings.root, "/views") }
    set :public_folder, Proc.new { File.join(root, "static") }
    set :show_exceptions, true
    set :static_cache_control, [:public, max_age: 0]

    #URL
    set :lp, "https://staging.lcp.points.com/v1/lps/2d39854c-101b-43dd-a0c8-39188e700518"
    set :offerTypes, ["BUY"]
    set :referralCode, "dotargetoffer"

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
    # validate_session(session[:session],session[:sessionMember])
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
    session[:session] = true
    session[:sessionMember] = params[:mv]

    puts "LOG | Params: " + params[:mv].to_s

    #Check if there are member details to create an MV with
    if params[:mv]["memberId"] == "" || params[:mv]["lastName"] == "" || params[:mv]["firstName"] == "" || params[:mv]["email"] == ""
      puts "LOG | Member is null. Not creating an MV."
      session[:sessionMV] = nil
    else 
      #Create MV
      begin
        session[:sessionMV] = post_mv(session[:sessionMember],settings.lp)
        # puts session[:sessionMV]
      rescue => bang
        puts "LOG | Error fetching MV: " + bang.to_s
        puts "LOG | Error backtrack: " +  bang.backtrace.inspect 
      end
    end

    #Determine offer type
    offerSession = {"channel" => "external-site", 
                    "clientIpAddress" => request.ip, 
                    "clientUserAgent" => request.user_agent, 
                    "referralCode" => settings.referralCode}

    #Fetch Offer Set
    begin
      session[:sessionOffer] = post_offerset(settings.offerTypes,
                                             offerSession,
                                             session[:sessionMV],
                                             settings.lp)
      session[:sessionOffer].each do |key, value|
        puts "#{key}:#{value}"
      end
    rescue => banger
      puts "LOG | Error fetching Offer Set: " + banger.to_s
      puts "LOG | Error backtrack: " +  banger.backtrace.inspect 
    end
    

    # Route to form
    @mv = session[:sessionMV]
    @offer = session[:sessionOffer]
    @referralCode = settings.referralCode
    erb :offer
end

# Catch All

get '/error' do
    erb :error
end

get '/*' do
    kill_session()
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
    session[:sessionOffer] = ""
  end  

end