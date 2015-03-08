#!/bin/zsh

#[[ $# == 1 ]] || echo "Please pass Name of Framework!" && exit 99

FW="${1:-AtoZUniversal}"
say "$FW"
env |sort >! /tmp/uni

support() { echo "-sdk $1 SUPPORTED_PLATFORMS=\"$1\"" }

xarchs="ARCHS=\"x86_64\" VALID_ARCHS=\"i386 x86_64\""


xcodebuild $(support macosx) clean build -target AtoZUniversal  $xarchs
xcodebuild $(support iphoneos) clean build -target AtoZUniversal \
            VALID_ARCHS="arm64 armv7s" \
                  ARCHS="arm64 armv7s"



 # xcodebuild -sdk  clean build  -target AtoZUniversal
 # SUPPORTED_PLATFORMS="iphoneos"


#SUPPORTED_PLATFORMS="iphonesimulator iphoneos" VALID_ARCHS="arm armv7 arm7s arm64"

# xcodebuild -target "$FW" SUPPORTED_PLATFORMS="macosx"   ARCHS="x86_64"        VALID_ARCHS="x86_64"
# xcodebuild -target "$FW" SUPPORTED_PLATFORMS="iphoneos" ARCHS="armv7s arm64"  VALID_ARCHS="armv7s arm64"


#CONFIGURATION_BUILD_DIR="$AZBUILD/../$CONFIGURATION$OTHER" \
#-configuration $CONFIGURATION -sdk "${OTHER/-/}" | xcpretty

# what xcode DIDN't just build.
#[[ "${EFFECTIVE_PLATFORM_NAME}" -eq "-iphoneos" ]] && OTHER="-iphonesimulator"    \
#|| OTHER="-iphoneos"
#
#
#cp -R "$TARGET_BUILD_DIR/$NAME.framework" "$AZBUILD/.." # Copy the previously built Framework
#
#lipo "$TARGET_BUILD_DIR/$NAME.framework/$NAME" \
#"$TARGET_BUILD_DIR/../$CONFIGURATION$OTHER/$NAME.framework/$NAME" \
#-create -output "$AZBUILD/../$NAME.framework/$NAME"
#
#/xbin/install_product.sh "$AZBUILD/../$NAME.framework/$NAME" "$AZBUILD/../$NAME.framework" "/Library/Frameworks"
#
##$(which mate) < $(env)
#
#/xbin/install_product.sh "$TARGET_BUILD_DIR/AtoZTouchTester" "$TARGET_BUILD_DIR/AtoZTouchTester" "/usr/local/bin"


# say "Done"
# This script is based on Jacob Van Order's answer on apple dev forums https://devforums.apple.com/message/971277
# See also http://spin.atomicobject.com/2011/12/13/building-a-universal-framework-for-ios/ for the start

# To get this to work with a Xcode 6 Cocoa Touch Framework, create Framework
# Then create a new Aggregate Target. Throw this script into a Build Script Phrase on the Aggregate


#xcodebuild -target ${PROJECT_NAME} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" | echo

#xcodebuild -target ${PROJECT_NAME} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" | echo

# Create directory for universal
# rm -rf "${UNIVERSAL_LIBRARY_DIR}"
# mkdir -p "${UNIVERSAL_LIBRARY_DIR}"
# mkdir "${FRAMEWORK}"


# On Release, copy the result to desktop folder
#if [ "${CONFIGURATION}" == "Release" ]; then
#    mkdir "${HOME}/Desktop/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneuniversal/"
#    cp -r "${FRAMEWORK}" "${HOME}/Desktop/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneuniversal/"
#fi


# If needed, open the Framework folder
#if [ "$REVEAL_ARCHIVE_IN_FINDER" = "YES" ]; then
#    if [ "${CONFIGURATION}" == "Release" ]; then
#        open "${HOME}/Desktop/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneuniversal/"
#    else
#        open "${UNIVERSAL_LIBRARY_DIR}/"
#    fi
#fi
#  SIM_PATH="$AZBUILD/$CONFIGURATION-iphonesimulator"
#  IOS_PATH="$AZBUILD/$CONFIGURATION-iphoneos"
# /${CONFIGURATION}-iphoneuniversal"




#
#CPFROM="$AZBUILD/../Staged/AtoZ.framework" #STAGED - IS IT VALID?
#
#find "$AZBUILD" -depth 1 -type d -regex '.*\.framework' \
#-exec ln -sF {} "$CPFROM/Frameworks" \;
#
##logger "PATH IS $CPFROM. COPYTO:$CPTO"
#
#otool -L "${CODESIGNING_FOLDER_PATH}/${TARGET_NAME}"
#
#if [[ ($? == 0) ]]; then
#
##--delete-excluded --delete --spectials --exclude='.DS_Store'
#/usr/local/bin/rsync -r -t -v --progress --delete -c -l -s "$CPFROM" "$AZBUILD"
#
#[[ ($? == 0) ]] && STATUS="SUCCESS!" || STATUS="FAILED!! ($?)"
#
#$(which terminal-notifier) -title "Rsync AtoZ" -message "${STATUS}"
#else
#$(which terminal-notifier) -title "AtoZ Build Failed" -message "NOT Copying!"
#fi
#
#
#ln -sF "$AZBUILD/AtoZ.framework" $USER_FWKS
#

# EOF


# if [ ! $(xctool -scheme Deps -project ${SRCROOT}/AtoZ.xcodeproj -configuration Debug) ]; then#
#    say You may want to rebuild AtoZ, now;#
#    else  rm -r /dd/AtoZ/Intermediates/PrecompiledHeaders
# fi#
#fi
#CPFROM="${CONFIGURATION_BUILD_DIR}/${FULL_PRODUCT_NAME}"
