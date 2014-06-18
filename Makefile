NAME=AtoZ.framework
COMPANY_ID=com.mrgray
GITHUB_DOC_URL=http://mralexgray.github.com/AtoZ.framework
VERSION=$(shell cat XcodeConfig/Shared.xcconfig | grep "GHUNIT_VERSION =" | cut -d '=' -f 2 | tr -d " ")

docs:
	rm -rf Documentation/output
	appledoc -o Documentation/output -p $(NAME) -v $(VERSION) -c "$(NAME)" --company-id "$(COMPANY_ID)" --warn-undocumented-object --warn-undocumented-member --warn-empty-description --warn-unknown-directive --warn-invalid-crossref --warn-missing-arg --no-repeat-first-par --keep-intermediate-files --docset-feed-url $(GITHUB_DOC_URL)/publish/%DOCSETATOMFILENAME --docset-package-url $(GITHUB_DOC_URL)/publish/%DOCSETPACKAGEFILENAME --publish-docset --index-desc Documentation/index_desc.txt --include Documentation/appledoc_include/ --include Documentation/index-template.markdown --verbose=3 --create-html --create-docset --publish-docset --exit-threshold 2 Classes/ Classes-iOS/ Classes-MacOSX/

gh-pages: docs
	rm -rf ../doctmp
	mkdir -p ../doctmp
	cp -R Documentation/output/html/* ../doctmp
	cp -R Documentation/output/publish ../doctmp/publish
	rm -rf Documentation/output/*
	git checkout gh-pages
	git symbolic-ref HEAD refs/heads/gh-pages
	rm .git/index
	git clean -fdx
	cp -R ../doctmp/* .
	git add .
	git commit -a -m 'Updating docs' && git push origin gh-pages
	git checkout master

CC=clang # or gcc

FRAMEWORKS:= -framework Foundation
LIBRARIES:= -lobjc

SOURCE=main.m

CFLAGS=-Wall -Werror -g -v $(SOURCE)
LDFLAGS=$(LIBRARIES) $(FRAMEWORKS)
OUT=-o main

all:
    $(CC) $(CFLAGS) $(LDFLAGS) $(OUT)


#####NONSENSE 

# WAS LinkBuild To System Frameworks Directory and Create Umbrella Framework Symlink

#BUILT="${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}"
##LIBRARY=/Library/Frameworks
#logger "symlinking $BUILT to $LIBRARY/"
# sudo ln -sF "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}" "$LIBRARY/"

#ln -sF "$BUILT" /Volumes/4x4/DerivedData/PrecompiledFrameworks/

#SDKFWS="$(/usr/bin/xcrun --show-sdk-path)/System/Library/Frameworks"
#logger "symlinking $LIBRARY/${WRAPPER_NAME} to $SDKFWS/"



#buildPlist="${PRODUCT_NAME}-Info.plist"
# Get the existing buildVersion and buildNumber values from the buildPlist
#buildVersion=$(/usr/libexec/PlistBuddy -c "Print CFBuildVersion" $buildPlist)
#buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBuildNumber" $buildPlist)
#buildDate=$(date "+%Y%m%d.%H%M%S")
 
# Increment the buildNumber#
#buildNumber=$(($buildNumber + 1))
 
# Set the version numbers in the buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBuildNumber $buildNumber" $buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBuildDate $buildDate" $buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildVersion.$buildNumber" $buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $buildVersion.$buildNumber" $buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBundleLongVersionString $buildVersion.$buildNumber.$buildDate" $buildPlist
#You can retrieve this information from within your program just like anything else in your Info.plist. This example extracts the short version string:
#NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
#NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
#buildNumber=$(date +%Y%m%d%H%M)
#/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/${INFOPLIST_FILE}"

# sudo ln -sF "$LIBRARY/${WRAPPER_NAME}" "$SDKFWS/"

#if [ -L "$BUILT/Frameworks/Frameworks" ]; then rm "$BUILT/Frameworks/Frameworks"; fi

# . ~/.zshrc
# PYTHONSHOULDBEEAT="${SDKROOT}/System/Library/Frameworks/Python.framework"
# LEGACYPTHONLOC="/Applications/Xcode5.0.1.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/System/Library/Frameworks/Python.framework"
# sudo ln -sF "$LEGACYPTHONLOC" "$PYTHONSHOULDBEEAT"

#[[ -d "$PYTHONSHOULDBEEAT" ]] ||
#/sd/UNIX/bin/finder reveal "$LEGACYPTHONLOC"
#/sd/UNIX/bin/finder reveal "$PYTHONSHOULDBEEAT"


#/Applications/Xcode5.0.1.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/System/Library/Frameworks/Python.framework

#END BLAH BLAH BLAH


##WAS LIONK FWS with ROOT
#cd "${CODESIGNING_FOLDER_PATH}/../.."
#[[ -e Frameworks ]] && /bin/rm Frameworks
#/bin/ln -sF Versions/Current/Frameworks Frameworks


#cd "${CODESIGNING_FOLDER_PATH}/../.."
#/sd/UNIX/bin/prompt $(pwd)
#ln -sF Versions/Current/Frameworks Frameworks
#ln -s Frameworks ../../


#export noitify="/Volumes/2T/ServiceData/UNIX/bin/notifycmd.app/Contents/MacOS/notifycmd"
##END FW's



### WAS CLEANCDA's
#echo "Cleaning Profiler Information"
#cd "${OBJECT_FILE_DIR_normal}/${CURRENT_ARCH}"
#COUNT=$(ls *.gcda 2> /dev/null | wc -l) # Delete *.gcda files in the current target
#if [ $COUNT -ne 0 ]; then
#    sayQuietly "Deleting $COUNT G C D A's"
#    rm -f *.gcda
#fi



INCLUDEDIR="${CONFIGURATION_BUILD_DIR}/include"

for X in $(ls "$INCLUDEDIR/") { ## As in, built products..
	
    ln -sF "$INCLUDEDIR/$X" "${CODESIGNING_FOLDER_PATH}/Headers"
    Z="/usr/local/include"
    [[ -d "$Z/$X" ]] || ln -sF "$INCLUDEDIR/$X" "$Z"
    Z="${SDKROOT}/usr/include"
    [[ -d "$Z/$X" ]] || sudo ln -sF "$INCLUDEDIR/$X" "$Z"
}

#[[ 0 == 0 ]] exit 0

function test { "$@";   status=$?;
    if [ $status -ne 0 ]; then
       echo "error with $1"; fi 
    return $status
}

#${BUILT_PRODUCTS_DIR}/AtoZCodeFactory
#touch "${SRCROOT}/${GCC_PREFIX_HEADER}"



#PRODUCT_PATH="${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}"
#BINARY="$PRODUCT_PATH/${PRODUCT_NAME}"
#if otool -l "$BINARY"
#then
 #   rm -r "/Volumes/4X4/DerivedData/AtoZ/Products/Debug/${WRAPPER_NAME}"
  #  cp -r "$PRODUCT_PATH" "/Volumes/4X4/DerivedData/AtoZ/Products/Debug/${WRAPPER_NAME}"
   # say linked framework
#else
 #   say not linking
#fi





#cd "${CODESIGNING_FOLDER_PATH}/Frameworks"
#COCOASERVERFW="RoutingHTTPServer.framework/Frameworks/CocoaHTTPServer.framework"
#COCOASOCKETFW="$COCOASERVERFW/Frameworks/CocoaAsyncSocket.framework"
#COCOALUMBERFW="$COCOASOCKETFW/Frameworks/CocoaLumberjack.framework"
#ln -sF $COCOASERVERFW .
#ln -sF $COCOASOCKETFW .
#ln -sF $COCOALUMBERFW .
# ln -s ../../Original Original
#ln -sF Versions/Current/Frameworks ../../Frameworks
#: '
##if [ 1 == 1 ]; then
#INCLUDE_PATH="${BUILT_PRODUCTS_DIR}/include"
#PRODUCT_PATH="${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}"
#      BINARY="$PRODUCT_PATH/Headers/"
#
#cd "$INCLUDE_PATH"
#for x in *; { 	logger "copying $x to $PRODUCT_PATH/Headers/";
#            	cp -R "$x" "$PRODUCT_PATH/Headers/"; }
#fi

# Save XCODE settings to file, for reference
#set > "${SRCROOT}/XcodeENV.sh"#
#
#'
#
#exit 0