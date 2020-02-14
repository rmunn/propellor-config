-- This is the main configuration file for Propellor, and is used to build
-- the propellor program.

import Propellor

main :: IO ()
main = defaultMain hosts

-- The hosts propellor knows about.
hosts :: [Host]
hosts =
	[ buster
	]

-- An example host.
buster :: Host
buster = host "buster.localnet" $ props
	& osDebian (Stable "buster") X86_64
