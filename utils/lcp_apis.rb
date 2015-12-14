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

	identifying_factors = {}
	authenticating_factors = {}

    authenticating_factors = Hash.new.tap do |h|
        h['password'] = user['password'] if user['password']
    end

    identifying_factors = Hash.new.tap do |h|
        h["firstName"] = user["firstName"] if user["firstName"]
        h["lastName"] = user["lastName"] if user["lastName"]
        h["email"] =  user["email"] if user["email"]
        h["memberId"] =  user["memberId"] if user["memberId"]
    end

	body = {"identifyingFactors" => identifying_factors}.to_json

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
		user["memberValidation"] = mvuser["links"]["self"]["href"]
		user["firstName"] = mvuser["identifyingFactors"]["firstName"]
		user["lastName"] = mvuser["identifyingFactors"]["lastName"]
		user["email"] = mvuser["identifyingFactors"]["email"]
		user["memberId"] = mvuser["identifyingFactors"]["memberId"]		
	end

	body = {"offerTypes" => offerTypes, "session" => session, "user" => user}.to_json

	request = {"url" => url, "body" => body}	
end

