marketing_version = 0.2.7
build = 1

Release: version archive createDMG

version:
	xcrun agvtool new-marketing-version ${marketing_version}
	xcrun agvtool new-version ${build}
	@echo "---------------------"
	@echo "Current build version is ${marketing_version}-build.${build}"
	@echo "3.."
	@sleep 1
	@echo "2."
	@sleep 1
	@echo "1."
	@sleep 1

archive:
	xcodebuild -workspace N\ Clip\ Board.xcworkspace -config Release -scheme N\ Clip\ Board -archivePath ./build/archives archive

createDMG:
	rm -f build/N\ Clip\ Board-${marketing_version}-build.${build}.dmg
	npm run pack -- build/N\ Clip\ Board-${marketing_version}-build.${build}.dmg

clean:
	rm -rf build