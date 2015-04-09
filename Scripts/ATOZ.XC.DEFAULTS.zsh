#!/bin/zsh

FWKS=${USER_LIBRARY_DIR}/Frameworks
  DD=/Volumes/dd/AtoZ
 TAG=/usr/local/bin/tag

[[ ! type -f $TAG ]] && say "Installing tag" && brew install tag

for x in $(ls -d ${DD}/${CONFIGURATION}/*.framework(/)); {

  DEST="${FWKS}/${x:t}"

  [[ -a "$DEST" ]] && { $TAG -r "$DEST"; $TAG -a Green "$DEST"; } ||  {

    if /bin/ln -s "$x" $FWKS 2>&1 /dev/null; then $TAG -a Red "$DEST"; fi
  }

}
