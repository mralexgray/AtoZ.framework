
otool -L "$CODESIGNING_FOLDER_PATH/$TARGET_NAME" || exit 99

ln -s `ls -d $AZBUILD/Debug/*\.framework` $USER_FWKS 2> /dev/null

rsync -r -t -v --progress --delete -c -l -s "$CPFROM" "$AZBUILD"  && \
\
  terminal-notifier -title "Rsync AtoZ" -message "$SUCCESS!" ||
\
  terminal-notifier -title "AtoZ Build Failed" -message "NOT Copying!"

ln -sF "$AZBUILD/AtoZ.framework" "$USER_FWKS"

# EOF


# if [ ! $(xctool -scheme Deps -project ${SRCROOT}/AtoZ.xcodeproj -configuration Debug) ]; then#
#    say You may want to rebuild AtoZ, now;#
#    else  rm -r /dd/AtoZ/Intermediates/PrecompiledHeaders
# fi#
#fi
#CPFROM="${CONFIGURATION_BUILD_DIR}/${FULL_PRODUCT_NAME}"


#  cd "${CODESIGNING_FOLDER_PATH}"
#  mkdir -p Frameworks
#  cd ../..
#  ln -sF ./Versions/A/Frameworks .
#  find "$AZBUILD/Debug" -depth 1 -type d -regex '.*\.framework' \
                  -exec ln -s {} "$USER_FWKS" > /dev/null \;  "$CPFROM/Frameworks" \;


#logger "PATH IS $CPFROM. COPYTO:$CPTO"
#--delete-excluded --delete --spectials --exclude='.DS_Store'
#touch /tmp/$TARGET_NAME.env
#env | sort > /tmp/$TARGET_NAME.env

#CREATE_TOP_LEVEL_FW_LINKAGE
#RSYNCH_IT
#
