build:
	bash ehome-build.sh
clean:
	ls .git &>/dev/null && git clean -xfd && git reset HEAD --hard
