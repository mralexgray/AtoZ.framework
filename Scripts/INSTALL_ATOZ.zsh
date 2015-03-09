
set -e

otool -L "${CODESIGNING_FOLDER_PATH}/${TARGET_NAME}"

CPFROM="$AZBUILD/Staged/AtoZ.framework"

[[ -z "$CPFROM" ]] && return -1

## say "$AZBUILD" # /dd/AtoZ

CREATE_TOP_LEVEL_FW_LINKAGE () {

#  cd "${CODESIGNING_FOLDER_PATH}"
#  mkdir -p Frameworks
#  cd ../..
#  ln -sF ./Versions/A/Frameworks .

  find "$AZBUILD/Debug" -depth 1 -type d -regex '.*\.framework' \
                  -exec ln -sF {} "$USER_FWKS" \; # "$CPFROM/Frameworks" \;

}

#logger "PATH IS $CPFROM. COPYTO:$CPTO"

RSYNCH_IT () {

  otool -L "${CODESIGNING_FOLDER_PATH}/${TARGET_NAME}"

  if [[ ($? == 0) ]]; then

    #--delete-excluded --delete --spectials --exclude='.DS_Store'
    /usr/local/bin/rsync -r -t -v --progress --delete -c -l -s "$CPFROM" "$AZBUILD"

    [[ ($? == 0) ]] && STATUS="SUCCESS!" || STATUS="FAILED!! ($?)"

    terminal-notifier -title "Rsync AtoZ" -message "${STATUS}"
  else
    terminal-notifier -title "AtoZ Build Failed" -message "NOT Copying!"
  fi
}

touch /tmp/$TARGET_NAME.env
env | sort > /tmp/$TARGET_NAME.env

# CREATE_TOP_LEVEL_FW_LINKAGE
RSYNCH_IT

 ln -sF "$AZBUILD/AtoZ.framework" "$USER_FWKS"

# EOF


# if [ ! $(xctool -scheme Deps -project ${SRCROOT}/AtoZ.xcodeproj -configuration Debug) ]; then#
#    say You may want to rebuild AtoZ, now;#
#    else  rm -r /dd/AtoZ/Intermediates/PrecompiledHeaders
# fi#
#fi
#CPFROM="${CONFIGURATION_BUILD_DIR}/${FULL_PRODUCT_NAME}"

