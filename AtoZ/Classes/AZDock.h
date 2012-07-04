//
//  AZDock.h
//  AtoZ
//
//  Created by Alex Gray on 7/3/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"

@class AZApp;
@interface AZDock : AtoZ 
@property (retain, nonatomic) NSMutableArray *apps;
@property (retain, nonatomic) NSMutableArray *sortedApps;
@end

////@interface NSObject (DBXObjectDelegate)
////-(void) setStartupStepStatus:(NSUInteger)status;
////-(void) setNumberOfDBXObjects:(NSUInteger)objects;
////-(void) didFinishDBXInit;
////-(void) madeDBXApp:(DBXApp*)app;
////@end
//
//@end