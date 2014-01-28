//
//  Project.h
//  xcb
//  Created by Alex Gray on 5/14/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//#import "/Library/Frameworks/AtoZ.framework/Headers/BaseModel.h"
//#import "/Library/Frameworks/AtoZ.framework/Headers/BaseModel+AtoZ.h"

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NotifyingOperationQueue.h"
#import <AtoZ/AtoZ.h>



@interface 							 Project : NSTaskOperation //<AtoZNodeProtocol>

@property (nonatomic,retain)    NSDate	* date;
@property (nonatomic,retain)  NSString * builtProduct, 
												   * projectPath, 
													* notes;
@property (nonatomic, retain) NSNumber * buildTime,
													* label, 
													* arch;
@property (readonly)  			NSString	* projectFilename, 		
													* projectFolder;

+ (instancetype)instanceWithProjectPath:(NSString*)path;

@end

@interface 					ProjectArchive : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource > //, AtoZNodeProtocol>
@property 				   NSMutableArray * projects;
//@property 				 NSTreeController * tc;

+ (void) save;
+ (void) addProject:(Project*)object;
+ (instancetype) sharedInstance;
@end



//+ (void) addProject:(Project*)object;
//@property (nonatomic) NSMutableArray *archives;
//@property NSArrayController *ac;
//+ (void) save;
