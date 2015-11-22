# ==============================
# rb_LCP_APIs
# Mladen R
# Nov 2015
#
# Basic helpers for generating body of LCP API calls
# 
# ==============================

# Reqs

require "json"

  
# =====================
# MV Request
#
# Creates an the MV URL and request body 
# Requires a user object and lp URI
# ======================

def mv_request(user, lp)

	url = lp + "/mvs/"


	if user["firstName"].to_s != ''
		identifyingFactors = {"firstName" => user["firstName"]}
	end	

	if user["lastName"].to_s != ''
		identifyingFactors = {"lastName" => user["lastName"]}
	end	

	if user["email"].to_s != ''
		identifyingFactors = {"email" => user["email"]}
	end

	if user["memberId"].to_s != ''
		identifyingFactors = {"memberId" => user["memberId"]}	
	end

	body = {"identifyingFactors" => identifyingFactors}.to_json

	request = {"url" => url, "body" => body}

	return request
end

def call_lcp(method,url,body)

    # Logging
    puts "LOG | Calling to LCP | Prep"
    puts "LOG | Calling to LCP | url: " + url
    puts "LOG | Calling to LCP | method: " + method 
    puts "LOG | Calling to LCP | body: " + body.to_s

    # Prep vars
    
    mac_key_identifier = ENV["PLP_MAC_ID"]
    mac_key = ENV["PLP_MAC_KEY"]
    
    method = method.upcase

    # Ignore content type if the GET 
    if method != "GET"
      content_type = "application/json"
    else
      content_type = ""
    end

    # Generate Headers
    headers = generate_authorization_header_value(method,url,mac_key_identifier,mac_key,content_type,body)

    # Logging   
    puts "LOG | Calling to LCP | headers: " + headers

    # Make Request
    if method == "POST"
      return RestClient.post(url, 
                   body, 
                   :content_type => :json, 
                   :accept => :json,
                   :"Authorization" => headers)
    elsif method == "PATCH"    
      return RestClient.patch(url, 
                  body, 
                  :content_type => :json, 
                  :accept => :json,
                  :"Authorization" => headers)
    elsif method == "GET"    
      return RestClient.get(url, 
                  :accept => :json,
                  :"Authorization" => headers)
    else
      return RestClient.get(url, 
                  body,
                  :content_type => :json, 
                  :accept => :json,
                  :"Authorization" => headers)
    end
end 
