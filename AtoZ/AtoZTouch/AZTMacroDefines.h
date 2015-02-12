//
//  AZTMacroDefines.h
//  AtoZ
//
//  Created by Alex Gray on 2/5/15.
//  Copyright (c) 2015 mrgray.com, inc. All rights reserved.
//

#ifndef AtoZ_AZTMacroDefines_h
#define AtoZ_AZTMacroDefines_h


#pragma mark -  DATASOURCE


#define TVMethod(RET_TYPE)   \
      - (RET_TYPE) tableView:(UITableView*)tv

#define TVNumRowsInSection    \
        TVMethod(NSInteger) numberOfRowsInSection:(NSInteger)section

#define TVNumSections         \
      - (NSInteger) numberOfSectionsInTableView:(UITableView*)tv

#define TVCellForRowAtIP  \
        TVMethod(UITableViewCell*) cellForRowAtIndexPath:(NSIndexPath *)ip


#pragma mark -  DELEGATE


#define TVHeightForRowAtIP \
        TVMethod(CGFloat) heightForRowAtIndexPath:(NSIndexPath*)ip

#define TVDidSelectRowAtIP \
        TVMethod(void) didSelectRowAtIndexPath:(NSIndexPath*)ip


#endif