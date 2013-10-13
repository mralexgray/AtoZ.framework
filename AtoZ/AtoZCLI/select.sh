#!/bin/sh

#  select.sh
#  AtoZ
#
#  Created by Alex Gray on 10/8/13.
#  Copyright (c) 2013 mrgray.com, inc. All rights reserved.#!/bin/bash

OPTIONS="Detailed Standard Summary Quit"
select opt in $OPTIONS; 
do
    if [ "$opt" = "Quit" ]; then
       echo Execution finished
       exit
    elif [ "$opt" = "Detailed" ]; then
     echo Now writing detailed report...
    elif [ "$opt" = "Standard" ]; then
     echo Now writing standard report...
    elif [ "$opt" = "Summary" ]; then
     echo Now writing summary report...
    else
       clear
       echo invalid option
    fi
done