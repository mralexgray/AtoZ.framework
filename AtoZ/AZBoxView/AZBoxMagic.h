//
//  AZBoxMagic.h
//  AtoZ
//
//  Created by Alex Gray on 7/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"
#import "AZFile.h"
@class AZBoxMagic;
@protocol AZBoxMagicDataSource <NSObject>
@required
/*** This method is invoked to ask the data source for the number of cells inside the collection view.  **/
- (NSUInteger)totalFilesToBeBoxedIn:(AZBoxMagic *)magicView;
/*** This method is involed to ask the data source for a cell to display at the given index. You should first try to dequeue an old cell before creating a new one!  **/
- (AZFile *)magicView:(AZBoxMagic *)magicView fileForIndex:(NSUInteger)index;
@end

@interface AZBoxMagic : NSView
{
//id <AZBoxMagicDataSource> __unsafe_unretained dataSource;
}

@property (nonatomic, retain) IBOutlet id <AZBoxMagicDataSource> dataSource;

-(void) reload;

@end
