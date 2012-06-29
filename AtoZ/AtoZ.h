//
//  AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

/** The appledoc application handler.
 
 This is the principal tool class. It represents the entry point for the application. The main promises of the class are parsing and validating of command line arguments and initiating documentation generation. Generation is divided into several distinct phases:
 
 1. Parsing data from source files: This is the initial phase where input directories and files are parsed into a memory representation (i.e. objects) suitable for subsequent handling. This is where the source code files are  parsed and validated for possible file or object-level incosistencies. This step is driven by `GBParser` class. 
 2. Post-processing of the data parsed in the previous step: At this phase, we already have in-memory representation of all source code objects, so we can post-process and validate things such as links to other objects etc. We can also update in-memory representation with this data and therefore prepare everything for the final phase. This step is driven by `GBProcessor` class.
 3. Generating output: This is the final phase where we use in-memory data to generate output. This step is driven by `GBGenerator` class.
 
 @warning *Global settings implementation details:* To be able to properly apply all levels of settings - factory defaults, global settings and command line arguments - we can't solely rely on `DDCli` for parsing command line args. As the user can supply templates path from command line (instead of using one of the default paths), we need to pre-parse command line arguments for templates switches. The last one found is then used to read global settings. This solves proper settings inheritance up to global settings level. Another issue is how to implement code that deals with global settings; there are several possible solutions (the simplest from programmers point of view would be to force the user to pass in templates path as the first parameter, then `DDCli` would first process this and when we would receive notification, we could parse the option, load in global settings and resume operation). At the end I chose to pre-parse command line for template arguments before passing it to `DDCli`. This did require some tweaking to `DDCli` code (specifically the method that converts option string to KVC key was moved to public interface), but ended up as very simple to inject global settings - by simply using the same KCV messages as `DDCli` uses. This small tweak allowed us to use exactly the same path of handling global settings as normal command line arguments. The benefits are many: all argument names are alreay unit tested to properly map to settings values, code reuse for setting the values.
 */

//  BaseModel.h
//  Version 2.3.1
//  ARC Helper
//  Version 1.3.1

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) (x)
#define AH_RELEASE(x) (void)(x)
#define AH_AUTORELEASE(x) (x)
#define AH_SUPER_DEALLOC (void)(0)
#define __AH_BRIDGE __bridge
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [(x) retain]
#define AH_RELEASE(x) [(x) release]
#define AH_AUTORELEASE(x) [(x) autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#define __AH_BRIDGE
#endif
#endif

//  ARC Helper ends


#import <Foundation/Foundation.h>
//Classes

#import "AZQueue.h"

// Views
#import "AZBlockView.h"

// Categories
#import "NSApplication+AtoZ.h"


extern NSString *const AtoZSharedInstanceUpdated;


//the BaseModel protocol defines optional methods that
//you can define on your BaseModel subclasses to extend their functionality

@protocol AtoZ <NSObject>
@optional

//loading sequence:
//setUp called first
//then setWithDictionary/Array/String if resource file exists
//then setWithCoder if save file exists

- (void)setUp;
- (void)setWithDictionary:(NSDictionary *)dict;
- (void)setWithArray:(NSArray *)array;
- (void)setWithString:(NSString *)string;
- (void)setWithNumber:(NSNumber *)number;
- (void)setWithData:(NSData *)data;
- (void)setWithCoder:(NSCoder *)coder;

//NSCoding

- (void)encodeWithCoder:(NSCoder *)coder;

@end


//use the BaseModel class as the base class for any of your
//model objects. BaseModels can be standalone objects, or
//act as sub-properties of a larger object

@interface AtoZ : NSObject <AtoZ>

//new autoreleased instance
+ (instancetype)instance;

//shared (singelton) instance
+ (instancetype)sharedInstance;
+ (BOOL)hasSharedInstance;
+ (void)setSharedInstance:(AtoZ *)instance;
+ (void)reloadSharedInstance;

//creating instances from collection or string
+ (instancetype)instanceWithObject:(id)object;
- (instancetype)initWithObject:(id)object;
+ (NSArray *)instancesWithArray:(NSArray *)array;

//creating an instance using NSCoding
+ (instancetype)instanceWithCoder:(NSCoder *)decoder;
- (instancetype)initWithCoder:(NSCoder *)decoder;


//resourceFile is a file, typically within the resource bundle that
//is used to initialise any BaseModel instance
//saveFile is a path, typically within application support that
//is used to save the shared instance of the model
//saveFileForID is a path, typically within application support that
//is used to save any instance of the model
+ (NSString *)resourceFile;
+ (NSString *)saveFile;

//save the model
- (void)save;

//generate unique identifier
//useful for creating universally unique
//identifiers and filenames for model objects
+ (NSString *)newUniqueIdentifier;

//optional uniqueID property
//you can enable this by adding BASEMODEL_ENABLE_UNIQUE_ID
//to your preprocessor macros in the project build settings
@property (nonatomic, strong) NSString *uniqueID;

@end




