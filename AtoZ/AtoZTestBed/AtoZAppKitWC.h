//
//  AtoZAppKitWC.h
//  AtoZ
//
//  Created by Alex Gray on 2/13/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//


@interface AtoZAppKitWC : NSWindowController <RMSuggestionPanelDatasource>
@property (assign) IBOutlet RMSuggestionPanel *suggestionPanel;
@end
