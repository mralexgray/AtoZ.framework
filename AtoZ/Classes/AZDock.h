//
//  AZDock.h
//  AtoZ
//
//  Created by Alex Gray on 7/3/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>

@class AZApp;
@interface AZDock : AtoZ

@end

/**

- (void)insertObject:(id)object atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)addObject:(id) object;
- (void)removeLastObject;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object;
//
//
//+ (NSArray*) sort;
//
//@property (assign) BOOL sorted;
//-(AZApp*) appAtIndex:(NSUInteger)index;
//@property (retain, nonatomic) NSMutableArray *apps;
//@property (retain, nonatomic) NSMutableArray *sortedApps;
//@property (assign) id delegate;
//
//- (DBXApp*) 	forPath:(NSString*)file;

@end

////@interface NSObject (DBXObjectDelegate)
////-(void) setStartupStepStatus:(NSUInteger)status;
////-(void) setNumberOfDBXObjects:(NSUInteger)objects;
////-(void) didFinishDBXInit;
////-(void) madeDBXApp:(DBXApp*)app;
////@end
//
//@end
*/