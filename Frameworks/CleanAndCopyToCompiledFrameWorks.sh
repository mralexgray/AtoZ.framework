#!/bin/sh

#  CleanAndCopyToCompiledFrameWorks.sh
#  AtoZ
#
#  Created by Alex Gray on 10/14/12.
#  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#echo `dirname $(readlink -f $0)`
cd ${0%/*}
pwd

COMPILED_FWRKS="../AtoZ/Compiled Frameworks"
COMPILED_PPATH="${COMPILED_FWRKS}/${WRAPPER_NAME}"
BUILT_PRODPATH="${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}"


echo "deleting built ${WRAPPER_NAME}  located at ${COMPILED_FWRKS}/${WRAPPER_NAME}."
echo "copying new ${WRAPPER_NAME}  from ${BUILT_PRODPATH} to ${COMPILED_FWRKS}/ ."

if [ -d "${COMPILED_PPATH}" ];then
rm -r  "${COMPILED_FWRKS}/${WRAPPER_NAME}"
fi
cp -r  "${BUILT_PRODPATH}" "${COMPILED_FWRKS}/"

cd ${0%/*}
cd ..
#find . -name *.DS_Store -type f -exec rm {} \;
