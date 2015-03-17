#!/bin/zsh

EXE="$CODESIGNING_FOLDER_PATH/$TARGET_NAME"  #/a2z/Scripts/INSTALL_FW_ON_DEVICE.zsh

otool -L "$EXE" || { say "$TARGET_NAME build failed" && return 9 }

[[ "$EFFECTIVE_PLATFORM_NAME" =~ "iphoneos" ]] && { # we are building for device!

  [[ "$WRAPPER_EXTENSION" == "framework" ]] && {

    INSTALLED="$(defaults read com.mrgray.AtoZ $TARGET_NAME)"
         HASH="$(md5 -q $EXE)"

    [[ $HASH == $INSTALLED ]] && exit 0 || defaults write com.mrgray.AtoZ "$TARGET_NAME" $HASH

    scp -r "$CODESIGNING_FOLDER_PATH" 6:"/Library/Frameworks" 2> /tmp/ERR \
     && say "installed $TARGET_NAME framework" \
     || say "copy to device failed for $TARGET_NAME. $(cat /tmp/ERR)"

  } || /xbin/installapp   "$BUILT_PRODUCTS_DIR/$WRAPPER_NAME" \
                 && say "installed $TARGET_NAME on device" \
                 || say "$TARGET_NAME install failed"
  
} || rsync --delete -r -t -v --progress -c -l -s "$BUILT_PRODUCTS_DIR/$WRAPPER_NAME" "$USER_FWKS"

