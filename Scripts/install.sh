
cd "${CODESIGNING_FOLDER_PATH}"
mkdir -p Frameworks
cd ../..
ln -sF ./Versions/A/Frameworks .

CPFROM="$AZBUILD/../Staged/AtoZ.framework"

find "$AZBUILD" -depth 1 -regex '.*\.framework' -exec ln -sF {} "$CPFROM/Frameworks" \;

#logger "PATH IS $CPFROM. COPYTO:$CPTO"

otool -L "${CODESIGNING_FOLDER_PATH}/${TARGET_NAME}"

if [[ ($? == 0) ]]; then

  #--delete-excluded --delete --spectials --exclude='.DS_Store'
  /usr/local/bin/rsync -r -t -v --progress --delete -c -l -s "$CPFROM" "$AZBUILD/.."
  RES=$?
  [[ ($RES == 0) ]] && STATUS="SUCCESS!" || STATUS="FAILED!! ($RES)"

  $NOTIFIER -title "Rsync AtoZ" -message "${STATUS}"
else
  $NOTIFIER -title "AtoZ Build Failed" -message "NOT Copying!"
fi


ln -sF "$AZBUILD/../AtoZ.framework" $USER_FWKS

# if [ ! $(xctool -scheme Deps -project ${SRCROOT}/AtoZ.xcodeproj -configuration Debug) ]; then#

#    say You may want to rebuild AtoZ, now;#
#    else  rm -r /dd/AtoZ/Intermediates/PrecompiledHeaders
# fi#
#fi


#CPFROM="${CONFIGURATION_BUILD_DIR}/${FULL_PRODUCT_NAME}"
