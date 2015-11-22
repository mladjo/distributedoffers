# ==============================
# rb_LCP_calls
# Mladen R
# Nov 2015
#
# Basic helpers for generating body of LCP API calls
# 
# ==============================

# Reqs
require "rest_client"
require "json"

require "./utils/lcp_apis"
require "./utils/lcp_auth"


def call_lcp(method,url,body)

	# Set the mac key and secret for the call
    mac_key_identifier = ENV["DO_MAC_ID"]
    mac_key = ENV["DO_MAC_KEY"]
    
    method = method.upcase

    # Ignore content type if the GET 
    if method != "GET"
      content_type = "application/json"
    else
      content_type = ""
    end

    # Generate Headers
    headers = generate_authorization_header_value(method,url,mac_key_identifier,mac_key,content_type,body)

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
    elsif method == "PUT"
      return RestClient.put(url, 
                  body,
                  :content_type => :json, 
                  :accept => :json,
                  :"Authorization" => headers)
    else
    	return "Method not supported"
    end
end 


def post_mv(user, lp)

	# Generate URL and Body
	mv = mv_request(user,lp)

	return call_lcp("POST", mv["url"], mv["body"])
end

def get_mv(mv)



def post_offerset(offerTypes,session,mvuser,lp)

	# Generate URL and Body
	os = offer_set(offerTypes, session,mvuser,lp)

	return call_lcp("POST", os["url"], os["body"])
end

