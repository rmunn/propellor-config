-- This is the main configuration file for Propellor, and is used to build
-- the propellor program.

import Propellor
import Propellor.Property.Bootstrap
import Propellor.Property.Scheduled
import qualified Propellor.Property.Apt as Apt
import qualified Propellor.Property.Chroot as Chroot
import qualified Propellor.Property.Sbuild as Sbuild
import qualified Propellor.Property.Schroot as Schroot

main :: IO ()
main = defaultMain hosts

-- The hosts propellor knows about.
hosts :: [Host]
hosts =
	[ buster
	, focal
	, arch
	]

-- Debian 10 ("buster")
buster :: Host
buster = host "buster.localnet" $ props
	& osDebian (Stable "buster") X86_64
	& Apt.useLocalCacher
	& sidSchrootBuilt
	& Sbuild.usableBy (User "vagrant")
	& Schroot.overlaysInTmpfs
  where
	sidSchrootBuilt = Sbuild.built Sbuild.UseCcache $ props
		& osDebian Unstable X86_32
		& Sbuild.osDebianStandard
		& Sbuild.update `period` Weekly (Just 1)
		& Chroot.useHostProxy buster

-- Ubuntu 20.04 ("focal")
focal :: Host
focal = host "focal.localnet" $ props
	& osBuntish "focal" X86_64

-- Archlinux
arch :: Host
arch = host "arch.localnet" $ props
	& osArchLinux X86_64
	& bootstrapWith (Robustly Stack)
