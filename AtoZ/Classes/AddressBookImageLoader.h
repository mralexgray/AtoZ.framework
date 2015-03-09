/* Erica Sadun, http://ericasadun.com iPhone Developer's Cookbook, 3.0 Edition BSD License, Use at your own risk	*/

#import <AddressBook/AddressBook.h>
#define ABSHARED ABAddressBook.sharedAddressBook

@interface AZAddressBook : NSObject

+(AZAddressBook*) sharedInstance;
@property (strong) ABAddressBook *addressBook;
@property (strong, nonatomic) NSMA *contacts;
//@property (retain) NSMutableArray *imageArray;
//@property (strong, nonatomic ) NSMA *images;
@end

@interface AZContact : NSObject //<ABImageClient>
+ (instancetype)contactWithPerson:(ABPerson*)a;
//- (id) initWithUid:(NSS*)uid;
@property (readonly) NSImage *image;
@property (readonly) NSString *displayName, *personUID, *organization;
@end;
//
//@property (nonatomic, copy) NSString *uid;
//@property (nonatomic, readonly)	NSS *company, *lastName, *firstName;
//@property (readonly) NSIMG *image;
//


//+ (NSArray *) groups; // groups
// Counting
//@property (nonatomic, readonly) NSUI contactsCount, contactsWithImageCount;//, contactsWithoutImageCount, numberOfGroups;
// Sorting
//@property (nonatomic) BOOL firstNameSorting;

// Find contacts
//+ (NSA*) contactsMatchingName: (NSS*)name;
//+ (NSA*) contactsMatchingEmail: (NSS*)email;
//+ (NSA*) contactsMatchingPhone: (NSS*)number;
// Find groups
//+ (NSArray *) groupsMatchingName: (NSString *) fname;


//- (id) initWithRecord: (ABRecord*) record;
//@property (nonatomic, copy) ABRecord *record;
//@property (nonatomic) NSI fetchTag;

//- (void) consumeImageData:(NSData *)data forTag:(NSInteger)tag;
//- (void) fetchImage;

//@property (nonatomic, strong) NSA	*urls, *emails, *phones;
//@property (nonatomic, strong) NSData *imageData;

//@property (nonatomic, readonly) BOOL isPerson;
#pragma mark SINGLE VALUE STRING
//@property (nonatomic, strong) NSString *firstname, *lastname, *suffix, *organization, *nickname;
//@property (nonatomic, readonly) NSString *contactName; // my friendly utility

#pragma mark NUMBER
//@property (nonatomic, assign) NSNumber *kind;

// Each of these produces an array of NSStrings
//@property (nonatomic, readonly) NSArray *emailArray;
//@property (nonatomic, readonly) NSArray *emailLabels;
//@property (nonatomic, readonly) NSArray *urlArray;
//@property (nonatomic, readonly) NSArray *urlLabels;

//@property (nonatomic, readonly) NSString *emailaddresses;
//@property (nonatomic, readonly) NSString *phonenumbers;
//@property (nonatomic, readonly) NSString *urls;

// Each of these uses an array of dictionaries
//@property (nonatomic, assign) NSArray *emailDictionaries;
//@property (nonatomic, assign) NSArray *urlDictionaries;

#pragma mark IMAGES

#pragma mark REPRESENTATIONS

// Conversion to dictionary
//- (NSDictionary *) baseDictionaryRepresentation; // no image
//- (NSDictionary *) dictionaryRepresentation; // image where available
//
//// Conversion to data
//- (NSData *) baseDataRepresentation; // no image
//- (NSData *) dataRepresentation; // image where available
//
//+ contactWithDictionary: (NSDictionary *) dict;
//+ contactWithData: (NSData *) data;


