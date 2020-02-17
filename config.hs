-- This is the main configuration file for Propellor, and is used to build
-- the propellor program.

import Propellor
import Propellor.Property.Bootstrap
import Propellor.Property.Scheduled
import qualified Propellor.Property.Apt as Apt
import qualified Propellor.Property.Chroot as Chroot
import qualified Propellor.Property.Sbuild as Sbuild
import qualified Propellor.Property.Schroot as Schroot

-- Edit this to set your preferred mirror
mirror :: String
mirror = "http://ftp.debianclub.org/debian"

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
	& Apt.mirror mirror
	& Apt.useLocalCacher
	& sidSchrootBuilt32
	& bullseyeSchrootBuilt32
	& busterSchrootBuilt32
	& sidSchrootBuilt64
	& bullseyeSchrootBuilt64
	& busterSchrootBuilt64
	& Sbuild.usableBy (User "vagrant")
	& Schroot.overlaysInTmpfs
  where
	schrootBuilt release architecture = Sbuild.built Sbuild.UseCcache $ props
		& osDebian release architecture
		& Apt.mirror mirror
		& Sbuild.osDebianStandard
		& Sbuild.update `period` Weekly (Just 1)
		& Chroot.useHostProxy buster
	sidSchrootBuilt32 = schrootBuilt Unstable X86_32
	bullseyeSchrootBuilt32 = schrootBuilt Testing X86_32
	busterSchrootBuilt32 = schrootBuilt (Stable "buster") X86_32
	sidSchrootBuilt64 = schrootBuilt Unstable X86_64
	bullseyeSchrootBuilt64 = schrootBuilt Testing X86_64
	busterSchrootBuilt64 = schrootBuilt (Stable "buster") X86_64

-- Ubuntu 20.04 ("focal")
focal :: Host
focal = host "focal.localnet" $ props
	& osBuntish "focal" X86_64

-- Archlinux
arch :: Host
arch = host "arch.localnet" $ props
	& osArchLinux X86_64
	& bootstrapWith (Robustly Stack)
