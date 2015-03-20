#!/usr/bin/env zsh

set -e

# This script is /a2z/Scripts/INSTALL_FW_ON_DEVICE.zsh

/usr/libexec/PlistBuddy -c "Set :__TIMESTAMP__ $(date)" "${INFOPLIST_FILE}"

EXE="$CODESIGNING_FOLDER_PATH/$TARGET_NAME"

[[ -z "$EXE" ]] && exit 99

otool -L "$EXE" || { say "$TARGET_NAME build failed" && return 9 }

[[ "$EFFECTIVE_PLATFORM_NAME" =~ "iphoneos" ]] && {  logger "we are building for device!"

  [[ "$WRAPPER_EXTENSION" != "framework" ]] && {  logger "Installing an app! ($TARGET_NAME)"

    /xbin/installapp "$BUILT_PRODUCTS_DIR/$WRAPPER_NAME"            \
              && say "installed ${TARGET_NAME/#AtoZ/} on device"    \
              || say "${TARGET_NAME/#AtoZ/} install failed"

  } || { logger "Looking up histoprical hash to see i INstall is needed!"

    INSTALLED="$(defaults read com.mrgray.AtoZ $TARGET_NAME)"
         HASH="$(md5 -q $EXE)"

    [[ $HASH == $INSTALLED ]] && { logger "Hashes match, aborting"; exit 0 }\
                              || defaults write com.mrgray.AtoZ "$TARGET_NAME" $HASH

    logger "Installing TARGET_NAME Framework onto device."
    scp -r "$CODESIGNING_FOLDER_PATH" 6:"/Library/Frameworks" 2> /tmp/ERR \
     && say "installed ${TARGET_NAME/#AtoZ/} framework" \
     || say "copy to device failed for ${TARGET_NAME/#AtoZ/}. $(cat /tmp/ERR)"

  }
  
} || { logger "Rsyning local framework named $TARGET_NAME"

        rsync --delete -r -t -v --progress -c -l -s "$BUILT_PRODUCTS_DIR/$WRAPPER_NAME" "$USER_FWKS" }




#buildPlist="${PRODUCT_NAME}-Info.plist"
## Get the existing buildVersion and buildNumber values from the buildPlist
#buildVersion=$(/usr/libexec/PlistBuddy -c "Print CFBuildVersion" $buildPlist)
#buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBuildNumber" $buildPlist)
#buildDate=$(date "+%Y%m%d.%H%M%S")
# 
## Increment the buildNumber
#buildNumber=$(($buildNumber + 1))
# 
## Set the version numbers in the buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBuildNumber $buildNumber" $buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBuildDate $buildDate" $buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildVersion.$buildNumber" $buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $buildVersion.$buildNumber" $buildPlist
#/usr/libexec/PlistBuddy -c "Set :CFBundleLongVersionString $buildVersion.$buildNumber.$buildDate" $buildPlist
#+%s)
