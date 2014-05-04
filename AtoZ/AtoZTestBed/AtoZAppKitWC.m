//
//  AtoZAppKitWC.m
//  AtoZ
//
//  Created by Alex Gray on 2/13/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//

#import "AtoZAppKitWC.h"

@interface AtoZAppKitWC ()

@end

@implementation AtoZAppKitWC

static NSA *rmObjects;

-(id) init { return [super initWithWindowNibName:self.className] ? rmObjects = NSIMG.monoIcons, self : nil; }

- (void) indowDidLoad
{
    [super windowDidLoad];
    AZLOGCMD;
    XX(_suggestionPanel);
    [_suggestionPanel reloadData];
}


#pragma mark - RMSuggestionPanel Datasource


- (int) numberOfItemsOfSuggestionPanel:(RMSuggestionPanel *) textfield { AZLOGCMD;

  XX(rmObjects);
  return rmObjects.count;
}
- (NSString *) identifierOfItemIndex: (int) index ofSuggestionPanel:(RMSuggestionPanel *) textfield {
  return [NSS.badWords normal:index];
}
- (NSString *) titleOfItemIndex: (int) index ofSuggestionPanel:(RMSuggestionPanel *) textfield {
  return [NSS.badWords normal:index];
}
- (NSString *) informationTextOfItemIndex: (int) index ofSuggestionPanel:(RMSuggestionPanel *) textfield {
  return [NSS.dicksonisms normal:index];
}
- (NSImage *) imageOfItemIndex: (int) index ofSuggestionPanel:(RMSuggestionPanel *) textfield {
  return [rmObjects normal:index];
}

@end
