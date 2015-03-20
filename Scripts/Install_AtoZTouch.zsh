
#env | sort >! /tmp/uni

NAME="${TARGET_NAME/Tester/}"

OTHER="-iphonesimulator"

xcodebuild -target $NAME  CONFIGURATION_BUILD_DIR="$AZBUILD/../$CONFIGURATION$OTHER" \
           -configuration $CONFIGURATION -sdk "${OTHER/-/}" | xcpretty

cp -Rf "$TARGET_BUILD_DIR/$NAME.framework" "$AZBUILD/.." # Copy the previously built Framework

lipo "$TARGET_BUILD_DIR/$NAME.framework/$NAME" \
     "$TARGET_BUILD_DIR/../$CONFIGURATION$OTHER/$NAME.framework/$NAME" \
     -create -output "$AZBUILD/../$NAME.framework/$NAME"

/xbin/install_product.sh "$AZBUILD/../$NAME.framework/$NAME" "$AZBUILD/../$NAME.framework" "/Library/Frameworks"

/xbin/install_product.sh "$TARGET_BUILD_DIR/$TARGET_NAME" "$TARGET_BUILD_DIR/$TARGET_NAME" "/usr/local/bin"


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

# what xcode DIDN't just build.
#[[ "$GCC_PREPROCESSOR_DEFINITIONS" =~ "SIMULATOR" ]] && OTHER="-iphoneos" \
#|| OTHER="-iphonesimulator"

