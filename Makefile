build: deps dist/setup-config
	git pull
	cabal build
	$(MAKE) tags

deps:
	if [ $$(whoami) = root ]; then apt-get install ghc cabal-install libghc-missingh-dev libghc-ansi-terminal-dev libghc-ifelse-dev libghc-unix-compat-dev libghc-hslogger-dev; fi

dist/setup-config: propellor.cabal
	cabal configure

clean:
	rm -rf dist Setup tags
	find -name \*.o -exec rm {} \;
	find -name \*.hi -exec rm {} \;

# hothasktags chokes on some template haskell etc, so ignore errors
tags:
	find . | grep -v /.git/ | grep -v /tmp/ | grep -v /dist/ | grep -v /doc/ | egrep '\.hs$$' | xargs hothasktags > tags 2>/dev/null
