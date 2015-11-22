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
