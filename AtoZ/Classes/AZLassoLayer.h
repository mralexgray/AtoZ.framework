
//  AZLassoLayer.h
//  AtoZ

//  Created by Alex Gray on 8/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//#import "BaseModel.h"
//#import "AtoZ.h"
#import <QuartzCore/QuartzCore.h>



@interface AZLassoLayer : AZSingleton

@property (ASS)		CGF strokeMultiplier;
@property (NATOM,WK) CAL *layer;

+(void) setLayer:(CAL*)layer;
+ (NSR) frame;
@end


//@interface LassoMaster : AZSingleton
//@property (nonatomic, retain) NSMutableArray *lassos;
//+ (void)add:	(id) obj;
//+ (void)remove: (id) obj;
////- (id)objectForKeyedSubscript:(NSString *)key;
//+ (NSMutableArray*) lassos;
//+ (BOOL) isLassoed:(id)item;
//@end

//			PRIOR

/*
@interface AZLassoLayer : CALayer
+ (AZLassoLayer*) lasso: (CALayer*)layer;
@end
*/