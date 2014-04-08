module Propellor.Property.OpenId where

import Propellor
import qualified Propellor.Property.File as File
import qualified Propellor.Property.Apt as Apt

import Data.List

providerFor :: [UserName] -> String -> Property
providerFor users baseurl = propertyList desc $
	[ serviceRunning "apache2"
		`requires` Apt.installed ["apache2"]
	, Apt.installed ["simpleid"]
		`onChange` serviceRestarted "apache2"
	, File.fileProperty desc
		(map setbaseurl) "/etc/simpleid/config.inc"
	] ++ map identfile users
  where
	identfile u = File.hasPrivContent $ concat
		[ "/var/lib/simpleid/identities/", u, ".identity" ]
	url = "http://"++baseurl++"/simpleid"
	desc = "openid provider " ++ url
	setbaseurl l
		| "SIMPLEID_BASE_URL" `isInfixOf` l = 
			"define('SIMPLEID_BASE_URL', '"++url++"');"
		| otherwise = l
