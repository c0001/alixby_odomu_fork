clean:
	ls .git &>/dev/null && git clean -xfd && git reset HEAD --hard
build: clean
	bash ehome-build.sh
