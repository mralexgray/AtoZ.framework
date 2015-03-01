
#import "AtoZUmbrella.h"

typedef BOOL(^IsDocumentEdited)(id _self); 

@protocol AZDoc 
@concrete
- (BOOL) isDocumentEdited;
- (void) setIsDocumentEdited:(IsDocumentEdited)x;
@end

#define OUTERROR  if ( outErr != NULL ) *outErr = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL]
#define DATAOFTYPE(...) - (DTA*) dataOfType:(NSS*)t error:(NSERR*__autoreleasing*) outErr{ OUTERROR;  __VA_ARGS__  }
#define READFROMDATA(...) - (BOOL) readFromData:(DTA*)d ofType:(NSS*)type error:(NSERR*__autoreleasing*)outErr { OUTERROR; __VA_ARGS__  }

@protocol AutoCopying <NSCopying>
@end

@protocol AutoCoding <NSCoding>
@end



/*
//  BaseModel.h

//  Version 2.3.1 ALEX

//  Created by Nick Lockwood on 25/06/2011.
//  Copyright 2011 Charcoal Design

//  Distributed under the permissive zlib license
//  Get the latest version from either of these locations:

//  http://charcoaldesign.co.uk/source/cocoa#basemodel
//  https://github.com/nicklockwood/BaseModel

//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.

//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:

//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.

//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.

//  3. This notice may not be removed or altered from any source distribution.

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>
//#import "AtoZ.h"
//#import "AtoZFunctions.h"
//#import "AtoZUmbrella.h"
//#import "NSObject+AtoZ.h"

extern NSString *const AZBaseModelSharedInstanceUpdatedNotification;
//the BaseModel protocol defines optional methods that
//you can define on your BaseModel subclasses to extend their functionality

@protocol AZBaseModel <NSObject, NSFastEnumeration>
@optional
//loading sequence:
//setUp called first
//then setWithDictionary/Array/String if resource file exists
//then setWithCoder if save file exists

- (void) setUp;
//- (void) setWithDictionary:(NSDictionary *)dict;
- (void) setWithArray:(NSArray *)array;
- (void) setWithString:(NSString *)string;
- (void) setWithNumber:(NSNumber *)number;
- (void) setWithData:(NSData *)data;
- (void) setWithCoder:(NSCoder *)coder;

//NSCoding
- (void) encodeWithCoder:(NSCoder *)coder;

@end

//use the BaseModel class as the base class for any of your
//model objects. BaseModels can be standalone objects, or
//act as sub-properties of a larger object

#import "AtoZUmbrella.h"

@interface AZBaseModel : NSObject
<AZBaseModel, NSCoding, NSCopying, NSFastEnumeration>

//new autoreleased instance
+ (instancetype)instance;

//shared (singelton) instance
+ (instancetype)sharedInstance;
+ (BOOL)hasSharedInstance;
+ (void)setSharedInstance:(AZBaseModel *)instance;
+ (void)reloadSharedInstance;

//creating instances from collection or string
+ (instancetype)instanceWithObject:(id)object;
- (instancetype)initWithObject:(id)object;
+ (NSArray *)instancesWithArray:(NSArray *)array;

//creating an instance using NSCoding
+ (instancetype)instanceWithCoder:(NSCoder *)decoder;
- (instancetype)initWithCoder:(NSCoder *)decoder;

//loading and saving the model from a plist file
+ (instancetype)instanceWithContentsOfFile:(NSString *)path;
- (instancetype)initWithContentsOfFile:(NSString *)path;
- (void) riteToFile:(NSString *)path atomically:(BOOL)atomically;
- (BOOL)useHRCoderIfAvailable;

//resourceFile is a file, typically within the resource bundle that
//is used to initialise any BaseModel instance
//saveFile is a path, typically within application support that
//is used to save the shared instance of the model
//saveFileForID is a path, typically within application support that
//is used to save any instance of the model
+ (NSString *)resourceFile;
+ (NSString *)saveFile;

//save the model
- (void) ave;

//generate unique identifier
//useful for creating universally unique
//identifiers and filenames for model objects
+ (NSString *)newUniqueIdentifier;

//#define BASEMODEL_ENABLE_UNIQUE_ID 1
//#ifdef BASEMODEL_ENABLE_UNIQUE_ID

//optional uniqueID property
//you can enable this by adding BASEMODEL_ENABLE_UNIQUE_ID
//to your preprocessor macros in the project build settings
@property (nonatomic, strong) NSString *uniqueID;

- (void) numerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (id) objectAtIndexedSubscript: (NSInteger) index;
- (void) setObject: (id) thing;
- (id)objectForKeyedSubscript:(NSString *)key;
- (void) setObject:(id)object forKeyedSubscript:(NSString *)key;

//#endif

@property (nonatomic, strong) NSMutableArray *backingstore;
- (id)randomElement;
- (NSArray *)shuffeled;
- (NSArray *)randomSubarrayWithSize:(NSUInteger)size;
- (id)objectAtNormalizedIndex:(NSInteger)index;
- (id)normal:(NSInteger)index;


- (void) eachWithIndex:(VoidIteratorArrayWithIndexBlock) block;
- (NSMA*) map:(MapArrayBlock) block;
- (NSMA*) nmap:(id (^)(id obj, NSUInteger index))block;
- (NSA*) filter:(BoolArrayBlock) block;
- (NSString*) saveInstanceInAppSupp;
+ (instancetype) instanceWithID:(NSString*)uniqueID;
	// NSCODING extras
+ (id)retrieve:(NSString *)key;
+ (BOOL)persist:(id)object key:(NSString *)key;
+ (BOOL)delete:(NSString *)key;
+ (BOOL)deleteEverything;
@end
*/
