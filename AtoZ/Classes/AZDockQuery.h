//
//  AZDockQuery.h
//  AtoZ
//
//  Created by Alex Gray on 7/5/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"
#import "AtoZModels.h"
#import "AZFile.h"
@interface AZDockQuery : BaseModel
{
	NSArray *_dock, *_dockSorted;
}
@property (nonatomic, strong) NSArray *dock;
- (CGPoint) locationNowForAppWithPath:(NSString*)aPath;

@end
