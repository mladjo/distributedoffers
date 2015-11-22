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

require "./lcp_apis"
require "./lcp_auth"




#offerTypes = ["BUY", "GIFT"]
#session = {"channel" => "storefront", "referralCode" =>"referrer", "clientIpAddress" => "1.1.1.1", "clientUserAgent" => "Chrome"}
#lp = "https://staging.lcp.points.com/v1/lps/2d39854c-101b-43dd-a0c8-39188e700518"
#mvuser = nil

#puts offer_set(offerTypes, session,mvuser,lp)