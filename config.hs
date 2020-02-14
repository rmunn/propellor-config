-- This is the main configuration file for Propellor, and is used to build
-- the propellor program.

import Propellor

main :: IO ()
main = defaultMain hosts

-- The hosts propellor knows about.
hosts :: [Host]
hosts =
	[ buster
	, focal
	]

-- Debian 10 ("buster")
buster :: Host
buster = host "buster.localnet" $ props
	& osDebian (Stable "buster") X86_64

-- Ubuntu 20.04 ("focal")
focal :: Host
focal = host "focal.localnet" $ props
	& osBuntish "focal" X86_64
