#!/bin/sh
##
# Open a terminal window and change directory to a folder
#
# Wilfredo Sanchez | wsanchez@opensource.apple.com
# Copyright (c) 2001-2002 Wilfredo Sanchez Vega.
# All rights reserved.
#
# Permission to use, copy, modify, and distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all
# copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS DISCLAIM ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHORS BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
# OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
# WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
##

# EXTENSIONS  : 				# Accepted file extentions
# OSTYPES     : "fold"				# Accepted file types
# ROLE        : Editor				# Role (Editor, Viewer, None)
# SERVICEMENU : Terminal/New Shell Here		# Name of Service menu item

Destination="$1";


say "inside script"


if [ ! -d "${Destination}" ]; then exit 1; fi;

"$(dirname "$0")/terminal" --activate --showtitle false -e "
  cd \"${Destination}\" || exit;

  clear;

  echo \"Working directory is: ${Destination}\";

  ";
