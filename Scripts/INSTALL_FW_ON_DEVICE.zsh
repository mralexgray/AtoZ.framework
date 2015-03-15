#!/bin/zsh

#/a2z/Scripts/INSTALL_FW_ON_DEVICE.zsh

otool -L "$CODESIGNING_FOLDER_PATH/$TARGET_NAME" || { say "$TARGET_NAME build failed" && return 9 }

[[ "$EFFECTIVE_PLATFORM_NAME" =~ "iphoneos" ]] && { # we are building for device!

  [[ "$WRAPPER_EXTENSION" == "framework" ]] && {

    scp -r "$CODESIGNING_FOLDER_PATH" 6:"/Library/Frameworks" && say "installed $TARGET_NAME framework" \
                                                              || say "copy to device failed for $TARGET_NAME"

  } || {

    /xbin/installapp "$BUILT_PRODUCTS_DIR/$WRAPPER_NAME" && say "installed $TARGET_NAME on device" \
                                                         || say "$TARGET_NAME install failed"
  }
  
} || {

  rsync --delete -r -t -v --progress -c -l -s "$BUILT_PRODUCTS_DIR/$WRAPPER_NAME" "$USER_FWKS"
}
