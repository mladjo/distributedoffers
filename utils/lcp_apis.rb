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
# Creates an MV request URL and body 
# Requires a user object and lp uri
# ======================

def mv_request(user, lp)

	url = lp + "/mvs/"

	identifyingFactors = {}
	authenticatingFactors = {}

	if user["firstName"].to_s != ''
		identifyingFactors["firstName"] = user["firstName"]
	end	

	if user["lastName"].to_s != ''
		identifyingFactors["lastName"] = user["lastName"]
	end	

	if user["email"].to_s != ''
		identifyingFactors["email"] =  user["email"]
	end

	if user["memberId"].to_s != ''
		identifyingFactors["memberId"] =  user["memberId"]
	end

	if user["password"].to_s != ''
		authenticatingFactors["password"] =  user["password"]
	end

	body = {"identifyingFactors" => identifyingFactors}.to_json

	request = {"url" => url, "body" => body}

	return request
end


# =====================
# Offers Request
#
# Creates an offer-set request URL and  body 
# Requires a user object and lp uri
# ======================
def offer_set(offerTypes, session, mvuser, lp)
	url = "https://staging.lcp.points.com/v1/offer-sets/"

	user = {}

	if mvuser.nil?
		user = {"loyaltyProgram" => lp}
	else
		parsed_mv = JSON.parse(mvuser)
		user["memberValidation"] = parsed_mv["links"]["self"]["href"]
		user["firstName"] = parsed_mv["identifyingFactors"]["firstName"]
		user["lastName"] = parsed_mv["identifyingFactors"]["lastName"]
		user["email"] = parsed_mv["identifyingFactors"]["email"]
		user["memberId"] = parsed_mv["identifyingFactors"]["memberId"]		
	end

	body = {"offerTypes" => offerTypes, "session" => session, "user" => user}.to_json

	request = {"url" => url, "body" => body}	
end

