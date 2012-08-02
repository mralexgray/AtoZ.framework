//
//  BaseModel.h
//
//  Version 2.3.1
//
//  Created by Nick Lockwood on 25/06/2011.
//  Copyright 2011 Charcoal Design
//


#import <Foundation/Foundation.h>


extern NSString *const BaseModelSharedInstanceUpdatedNotification;


//the BaseModel protocol defines optional methods that
//you can define on your BaseModel subclasses to extend their functionality

@protocol BaseModel <NSObject>
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

@interface BaseModel : NSObject <BaseModel>

//new autoreleased instance
+ (instancetype)instance;

//shared (singelton) instance
+ (instancetype)sharedInstance;
+ (BOOL)hasSharedInstance;
+ (void)setSharedInstance:(BaseModel *)instance;
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
- (void)writeToFile:(NSString *)path atomically:(BOOL)atomically;
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
- (void)save;

//generate unique identifier
//useful for creating universally unique
//identifiers and filenames for model objects
+ (NSString *)newUniqueIdentifier;

//#ifdef BASEMODEL_ENABLE_UNIQUE_ID

//optional uniqueID property
//you can enable this by adding BASEMODEL_ENABLE_UNIQUE_ID
//to your preprocessor macros in the project build settings
@property (nonatomic, strong) NSString *uniqueID;

//#endif

@end