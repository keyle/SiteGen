default: build

clean:
	xcodebuild -quiet clean

build: clean
	export TARGET_BUILD_DIR=".build/"
	xcodebuild -scheme SiteGen -derivedDataPath ".build/" -configuration Release build
	mv .build/Build/Products/Release/SiteGen .build/sitegen
	rm -rf .build/Build .build/Logs .build/*.noindex .build/Source* .build/*.plist 
	echo See .build/
