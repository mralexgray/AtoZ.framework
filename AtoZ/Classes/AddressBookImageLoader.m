
#import <AtoZ/AtoZ.h>
#import "AddressBookImageLoader.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBookC.h>

static NSString * const kFirstNameKey = @"firstName";
static NSString * const kLastNameKey = @"lastName";
static NSString * const kCompanyKey = @"company";
static NSString * const kDisplayNameKey = @"displayName";
static NSString * const kURLsKey = @"urls";
static NSString * const kEmailsKey = @"emails";
static NSString * const kPhonesKey = @"phones";
static NSString * const kImageDataKey = @"image";

@interface AZContact ()
@property (strong) ABPerson *ref;
@end

//void x (){

//  id z = [@[] filterOneBlockObject:^id(id object) {

//  }
//}
//- (id)initWithImage:(NSImage*)image imageID:(NSString*)imageID andImageSubtitle:(NSString*) subtitle   andPersonUID:(NSString*) pUID

@implementation AZContact
@synthesize  organization = _organization, image = _image, personUID = _personUID, displayName = _displayName;

+ (instancetype)contactWithPerson:(ABPerson*)a	{  	AZContact *i = AZContact.new;  i.ref = a; return i;	}
- (NSString*) imageUID 		{ return self.personUID; }
- (NSString*) personUID 	{ return _personUID 	= _personUID 	?: [_ref uniqueId];	}
- (NSString*) imageTitle 	{ return _displayName  	= _displayName	?: [[[[_ref valueForProperty: kABFirstNameProperty]copy]
											stringByAppendingString:	 [[_ref valueForProperty: kABLastNameProperty] copy]]
											stringByReplacingOccurrencesOfString: @"(null)"  withString:@""];
}
- (NSString*) imageSubtitle 		  { return _organization 	= _organization ?: [_ref valueForProperty: kABOrganizationProperty];	}
- (NSString*) imageRepresentationType {	return IKImageBrowserNSImageRepresentationType;		}
- (void) 	  setImageSubtitle:	   ( NSString*) title {	_displayName = [title copy];	}
- (NSIMG*)	  image 	 			  {	return _image 	= _image ?: [_ref imageData]
														? [NSImage.alloc initWithData:_ref.imageData]
														: NSIMG.monoIcons[67];		}

@end


@implementation AZAddressBook

+ (AZAddressBook*)sharedInstance
{
	static  dispatch_once_t once;	static id sharedInstance;
			dispatch_once( &once, ^{ sharedInstance = self.new; });	return sharedInstance;
}

- (NSArray*) searchAddressesFor:(NSArray*)properties withValue:(NSString*)search
{
	return (search) ? 	[ABSHARED 		   recordsMatchingSearchElement:
						[ABSearchElement   searchElementForConjunction: 		kABSearchOr
								children: [properties map:^id(NSS *field) {
								  return  [ABPerson searchElementForProperty: 	field
													label: nil  key:nil  value:	search
													comparison: kABContainsSubStringCaseInsensitive];
										 }]
						]] : [_addressBook people];
}


//- (void) ind:(id) sender {	/._imageArray = nil;//removeAllObjects];
- (NSMA*) contacts {

	return _contacts = _contacts ?:
//	[AZSOQ addOperationWithBlock:^{
//		self.imageArray = [[self searchAddressesFor:@[kABOrganizationProperty,
//							  kABLastNameProperty,
//							  kABFirstNameProperty]withValue:[sender stringValue]]
		[[self.addressBook people] mapM:^id(ABPerson* person) {
			return [AZContact contactWithPerson:person];
		}];
//	NSLog(@"ContactsWithImages:%ld",  _contacts.count);
//	}];
//	[_imageBrowser performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//	[_imageTable reloadData];
}


- (id) init	{		if (!(self = super.init)) return nil;

	[AZStopwatch named:@"Create AddressBook" block:^{

		_addressBook 	= ABAddressBook.sharedAddressBook;
//		_images   		= NSMD.new;
//		[self performSelectorInBackground:@selector(find:) withObject:nil];

//		_contacts 		= [_addressBook.people map:^id(ABPerson *person) {
//			NSS* u		= [person valueForProperty:kABUIDProperty];
//			return u   != nil ? [AZContact.alloc initWithUid:u] : u;	}].mutableCopy;
	}];
	return self;
}
//- (NSMD*) images {  return _images = _images ?: [self.contacts :^id(id onj) {
//		return @{
//	}];
//}

@end


/*
 - (NSArray *) dictionaryArrayForProperty: (ABPropertyID) aProperty
 {
 NSA *valueArray = [self.record valueForKey::aProperty];
 NSA *labelArray = [self.record valueForKey:aProperty];

 int num = MIN(valueArray.count, labelArray.count);
 NSMutableArray *items = [NSMutableArray array];
 for (int i = 0; i < num; i++)
 {
 NSMutableDictionary *md = @{}.mutableCopy;
 [md setObject:[valueArray objectAtIndex:i] forKey:@"value"];
 [md setObject:[labelArray objectAtIndex:i] forKey:@"label"];
 [items addObject:md];
 }
 return items;
 }

 - (NSArray *) emailDictionaries			{	return [self dictionaryArrayForProperty:kABEmailProperty];			}

 - (NSArray *) phoneDictionaries			{	return [self dictionaryArrayForProperty:kABPhoneProperty];			}

 - (NSArray *) relatedNameDictionaries	{	return [self dictionaryArrayForProperty:kABRelatedNamesProperty];	}

 - (NSArray *) urlDictionaries			{	return [self dictionaryArrayForProperty:kABURLProperty];			}

 - (NSArray *) dateDictionaries			{	return [self dictionaryArrayForProperty:kABDateProperty];			}

 - (NSArray *) addressDictionaries		{	return [self dictionaryArrayForProperty:kABAddressProperty];		}

 - (NSArray *) smsDictionaries			{	return [self dictionaryArrayForProperty:kABInstantMessageProperty];	}
 

*/

//- (id) init	{	return [self initWithUid:nil];	}
//
//- (id) initWithUid:(NSS*)uid
//{
//	if (!(self = super.init)) return nil;
//	_uid = uid.copy;
//	return self;
//}

//- (void) fetchImage {
//
//	ABRecord *pers = [ABAddressBook.sharedAddressBook recordForUniqueId:self.uid];
//	NSLog(@"pers: %@", pers);
//	if (pers && [pers isKindOfClass:ABPerson.class]) [(ABPerson*)pers beginLoadingImageDataForClient:self];
//}


//- (NSImage*) image
//{
//	return _image = _image ?: ^{
//		NSData *data = 	(__bridge NSData*)
//					 	( (CFDataRef) ABPersonCopyImageData (
////						  	( (__bridge ABPersonRef)[ABAddressBook.sharedAddressBook
////							recordForUniqueId:_uid])));
//		return [NSImage imageWithData:[ABAddressBook.sharedAddressBook recordForUniqueId:_uid] icpon];
//		//]data];
//	}();
////	CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)ABPersonCopyImageData( , NULL));
////	CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
////
////	[NSIMG imageWithData: ,kABPersonImageFormatThumbnail)] ?: nil;
//	 //[AZAddressBook.sharedInstance].images[_uid] ?:  [
//}

//+ (NSSet*) keyPathsForValuesAffectingImage  { return  NSSET(@"uid"); }

//- (void) onsumeImageData:(NSData *)data forTag:(NSInteger)tag;
//{
//	NSImage *iii;
////	NSLog(@"consuming! fetcghtag: %ld  tag:%ld", self.fetchTag, tag);
//	if (data) iii = [NSIMG.alloc initWithData:data];
//	if (iii) self.image = iii;
//}

//		if ([person imageData]) {
//			NSData * d = [person imageData];
//			NSLog(@"data: %@", d);
//			if (d) [_images setValue:[NSIMG imageWithData:d] forKey:u];
//		}

//	NSLog(@"images:%@", _images);
//	[self loadImages];

//-(void) loadImages {
//
//	[_contacts each:^(AZContact *obj) {
////		[AZSharedSingleOperationQueue() addOperationWithBlock:^{
//		[((ABPerson*)[ABAddressBook.sharedAddressBook recordForUniqueId:[obj uid]]) beginLoadingImageDataForClient:obj];
////		}];
//	}];
//}
//- (NSMA*) contacts
//{
//	return _contacts  = _contacts ?: [[ABAddressBook.sharedAddressBook people] map:^id(ABPerson *person) {
//			return [AZContact.alloc initWithRecord:person] ?: nil;
//		}].mutableCopy;
////	[self.class setSharedInstance:self];
//}


//- (void) oadAddresses
//{
	// - Load all Address Book addresses. This is neither efficient nor elegant. In the real world, one
	//   would do this in a much lazier and nicer way.


//		 *personRecord = [AZContact new];

//			NSString *displayName = [self displayNameForPerson: person];
//			if (displayName) personRecord.displayName = displayName;//	[personRecord setValue: displayName forKey: kDisplayNameKey];


//			personRecord.uid = /copy];
	//			[personRecord setValue: company forKey: kCompanyKey];

/*			ABMultiValue *urls = [person valueForProperty: kABURLsProperty];
			NSUInteger i, count = [urls count];
			NSMutableArray *displayURLs = [NSMutableArray arrayWithCapacity: count];
			for (i = 0; i < count; ++i)
				[displayURLs addObject: [urls valueAtIndex: i]];
			if ([displayURLs count])
				personRecord.urls = displayURLs;

			ABMultiValue *emails = [person valueForProperty: kABEmailProperty];
			count = [emails count];
			NSMutableArray *displayEmails = [NSMutableArray arrayWithCapacity: count];
			for (i = 0; i < count; ++i)
				[displayEmails addObject: [emails valueAtIndex: i]];
			if ([displayEmails count])
				[personRecord setValue: displayEmails forKey: kEmailsKey];
	//
	//		ABMultiValue *phones = [person valueForProperty: kABPhoneProperty];
	//		count = [phones count];
	//		NSMutableArray *displayPhones = [NSMutableArray arrayWithCapacity: count];
	//		for (i = 0; i < count; ++i)
	//			[displayPhones addObject: [phones valueAtIndex: i]];
	//		if ([displayPhones count])
	//			[personRecord setValue: displayPhones forKey: kPhonesKey];
*/
//			personRecord.personRecord = person;
//			NSData *imageData = [person imageData];
//			if (imageData) {
//				NSLog(@"imagedata: %@", imageData);
//				personRecord.image = [NSImage imageWithData:imageData];
//			}
//			[person beginLoadingImageDataForClient:personRecord];//.imageData = [person imageData];
//			[self insertValue:personRecord atIndex:_contacts.count inPropertyWithKey:@"contacts"];// addObject: personRecord];
//			return personRecord;
//		}].mutableCopy;
//	}
//	[sortedPeople sortUsingDescriptors: @[[NSSortDescriptor.alloc initWithKey: kDisplayNameKey ascending: YES]]];

//	self.contacts = sortedPeople;

//- (NSString *)displayNameForPerson: (ABPerson *)person
//{
//	NSString *firstName = [person valueForProperty: kABFirstNameProperty];
//	NSString *lastName = [person valueForProperty: kABLastNameProperty];
//	NSString *company = [person valueForProperty: kABOrganizationProperty];
//
//	if ([firstName length] && [lastName length])
//		return [NSString stringWithFormat: @"%@ %@", firstName, lastName];
//	else if ([firstName length])
//		return firstName;
//	else if ([lastName length])
//		return lastName;
//	else if ([company length])
//		return company;
//
//	return nil;
//}


//- (NSUI) contactsCount { return  [self.class.sharedInstance contacts].count; }
//- (NSUI) contactsWithImageCount { return  [[self.class.sharedInstance contacts] filter:^BOOL(AZContact *u){  return u.image != nil; }].count; }

// Find contacts
//+ (NSA*) contactsMatchingName: (NSS*)name;
//+ (NSA*) contactsMatchingEmail: (NSS*)email;
//+ (NSA*) contactsMatchingPhone: (NSS*)number;
//// Find groups
//+ (NSArray *) groupsMatchingName: (NSString *) fname;
//- (id) initWithRecord: (ABRecord*) aRecord
//{
//	if (!(self = super.init)) return nil;
//	[@{ @"firstname" : kABFirstNameProperty, @"middlename": kABMiddleNameProperty,  @"lastname"	 : kABLastNameProperty,
//		@"suffix" 	 : kABSuffixProperty, 	 @"nickname"  : kABNicknameProperty, 	@"organization" : kABOrganizationProperty }
//		enumerateEachKeyAndObjectUsingBlock:^(NSS* key, NSS* obj) {
//			id someValue = [aRecord valueForProperty:obj];
//			if (someValue && [self respondsToString:key])  [self setValue:someValue forKey:key];
//	}];
//	NSData *iData = [aRecord imageData];
//	_image = iData ? [NSImage.alloc initWithData:iData] : [NSIMG imageNamed:@"missing"];
//	return self;
//}

#pragma mark Record ID and Type
//- (ABRecordID) recordID	{	return ABRecordGetRecordID(record);}
//- (ABRecordType) recordType	{	return ABRecordGetRecordType(record);}
//- (BOOL) isPerson	{	return [[self.record valueForKey:kABPersonFlags] isEqualToString:kABShowAsPerson];		}
//
#pragma mark Getting Single Value Strings
//- (NSS*) getRecordString:(ABPropertyID) anID
//{
//	return [(NSS*) ABRecordCopyValue(record, anID) autorelease];
//}
//- (NSS*) firstname		{	return [self.record valueForKey:   kABFirstNameProperty]; 	}
//- (NSS*) middlename		{	return [self.record valueForKey:  kABMiddleNameProperty];	}
//- (NSS*) lastname 		{	return [self.record valueForKey:	kABLastNameProperty];	}
//- (NSS*) suffix			{	return [self.record valueForKey:	  kABSuffixProperty];	}
//- (NSS*) nickname		{	return [self.record valueForKey:	kABNicknameProperty];	}
//- (NSS*) organization	{	return [self.record valueForKey:kABOrganizationProperty];	}
//- (NSS*) jobtitle		{	return [self.record valueForKey:	kABJobTitleProperty];	}
//- (NSS*) department		{	return [self.record valueForKey:  kABDepartmentProperty];	}
//- (NSS*) note			{	return [self.record valueForKey:		kABNoteProperty];	}

#pragma mark Contact Name Utility
/*- (NSS*) contactName
{
	return [$(@"%@%@%@%@",
			_firstname 		? $(@"%@ ", _firstname) : @"",
			_lastname  		? $(@"%@", _lastname) : @"",
			_suffix 		? $(@", %@ ", _suffix) : @" ",
			_organization 	?: @"") stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
//		if (self.firstname || self.lastname)
//		{
//			if (self.firstname) [string appendFormat:@"%@ ", 	 self.firstname];
//			if (self.nickname) 	[string appendFormat:@"\"%@\" ",  self.nickname];
//			if (self.lastname) 	[string appendFormat:@"%@", 		  self.lastname];
//			self.suffix && string.length ? [string appendFormat:@", %@ ", self.suffix] : [string appendFormat:@" "];
//		}
//		if (self.organization) [string appendString:self.organization];
//		self.contactName = [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
//		return _contactName;
//	}();
}*/

//- (NSS*) compositeName	{	return (NSS*)ABRecordCopyCompositeName(record);	}

//- (NSDate *) birthday			{	return [self.record valueForKey:		kABBirthdayProperty];	}
//- (NSDate *) creationDate		{	return [self.record valueForKey:	kABCreationDateProperty];	}
//- (NSDate *) modificationDate	{	return [self.record valueForKey:kABModificationDateProperty];	}
//
//- (NSArray *) emailArray		{	return [self.record valueForKey:		 kABEmailProperty];	}
//- (NSArray *) emailLabels		{	return [self.record valueForKey:		 kABEmailProperty];	}
//- (NSArray *) phoneArray		{	return [self.record valueForKey:		 kABPhoneProperty];	}
//- (NSArray *) phoneLabels		{	return [self.record valueForKey:  		 kABPhoneProperty];	}
//- (NSArray *) relatedNameArray	{	return [self.record valueForKey:  kABRelatedNamesProperty];	}
//- (NSArray *) relatedNameLabels	{	return [self.record valueForKey:  kABRelatedNamesProperty];	}
//- (NSArray *) urlArray			{	return [self.record valueForKey:		   kABURLsProperty];	}
//- (NSArray *) urlLabels			{	return [self.record valueForKey:		   kABURLsProperty];	}
//
//- (NSS*) phonenumbers	{	return [self.phoneArray componentsJoinedByString:@" "];}
//- (NSS*) emailaddresses	{	return [self.emailArray componentsJoinedByString:@" "];}
//- (NSS*) urls			{	return [self.urlArray   componentsJoinedByString:@" "];}

//- (void) onsumeImageData:(NSData *)data forTag:(NSInteger)tag;
//{
//	NSLog(@"consumer callback");
//	self.image = [NSImage imageWithData:data].copy;
//}
//- (NSIMG*) image
//{
//	return _image ?: ^{
//		[AZSharedSingleOperationQueue() addOperationWithBlock:^{
//			ABAddressBook *addressBook = ABAddressBook.sharedAddressBook;
//			NSLog(@"self.uid: %@", _uid);
//			ABRecord *f = [addressBook recordForUniqueId:_uid];
//			NSData *d = [f imageData];
//			if (d) _image = [NSImage.alloc initWithData:d];
//		}];
//		return [NSImage imageNamed:@"missing"];
//	}();
//}
////	NSLog(@"self.oerson  %@", self.personRecord);
//	return
//	_image ?: /* [NSImage.alloc initWithData:_imageData] :*/ [NSIMG imageNamed:@"missing"];//
//	/*^{
//		[AZSharedSingleOperationQueue() addOperationWithBlock:^{
//			NSData *iData = [_personRecord imageData];
//////		NSLog(@"iDataexista: %@", StringFromBOOL(iData != nil));
//			if (iData)  self.image = [NSImage.alloc initWithData:iData];
//		}];
////////		NSLog(@"iImgexista: %@", StringFromBOOL(iImg != nil));
////////		AZLOG(iImg);
//
//		return _image ?: [NSIMG imageNamed:@"missing"];
////		return [NSIMG imageNamed:@"missing"];
//	}();
//	*/
//}


/*

#pragma mark Setting Strings
- (BOOL) setString: (NSS*) aString forProperty:(ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, (CFStringRef) aString, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (void) setFirstname: (NSS*) aString {[self setString: aString forProperty: kABFirstNameProperty];}
- (void) setMiddlename: (NSS*) aString {[self setString: aString forProperty: kABMiddleNameProperty];}
- (void) setLastname: (NSS*) aString {[self setString: aString forProperty: kABLastNameProperty];}

- (void) setPrefix: (NSS*) aString {[self setString: aString forProperty: kABPrefixProperty];}
- (void) setSuffix: (NSS*) aString {[self setString: aString forProperty: kABSuffixProperty];}
- (void) setNickname: (NSS*) aString {[self setString: aString forProperty: kABNicknameProperty];}

- (void) setFirstnamephonetic: (NSS*) aString {[self setString: aString forProperty: kABFirstNamePhoneticProperty];}
- (void) setMiddlenamephonetic: (NSS*) aString {[self setString: aString forProperty: kABMiddleNamePhoneticProperty];}
- (void) setLastnamephonetic: (NSS*) aString {[self setString: aString forProperty: kABLastNamePhoneticProperty];}

- (void) setOrganization: (NSS*) aString {[self setString: aString forProperty: kABOrganizationProperty];}
- (void) setJobtitle: (NSS*) aString {[self setString: aString forProperty: kABJobTitleProperty];}
- (void) setDepartment: (NSS*) aString {[self setString: aString forProperty: kABDepartmentProperty];}

- (void) setNote: (NSS*) aString {[self setString: aString forProperty: kABNoteProperty];}

#pragma mark Setting Numbers
- (BOOL) setNumber: (NSNumber *) aNumber forProperty:(ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, (CFNumberRef) aNumber, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

// const CFNumberRef kABKindPerson;
// const CFNumberRef kABKindOrganization;
- (void) setKind: (NSNumber *) aKind {[self setNumber:aKind forProperty: kABKindProperty];}

#pragma mark Setting Dates

- (BOOL) setDate: (NSDate *) aDate forProperty:(ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, (CFDateRef) aDate, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (void) setBirthday: (NSDate *) aDate {[self setDate: aDate forProperty: kABBirthdayProperty];}

#pragma mark Setting MultiValue

- (BOOL) setMulti: (ABMutableMultiValueRef) multi forProperty: (ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, multi, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (ABMutableMultiValueRef) createMultiValueFromArray: (NSArray *) anArray withType: (ABPropertyType) aType
{
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(aType);
	for (NSDictionary *dict in anArray)
		ABMultiValueAddValueAndLabel(multi, (CFTypeRef) [dict objectForKey:@"value"], (CFTypeRef) [dict objectForKey:@"label"], NULL);

	return CFAutorelease(multi);
}

- (void) setEmailDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABEmailProperty];
	// CFRelease(multi);
}

- (void) setPhoneDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPhoneMobileLabel, kABPhoneIPhoneLabel, kABPhoneMainLabel
	// kABPhoneHomeFAXLabel, kABPhoneWorkFAXLabel, kABPhonePagerLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPhoneProperty];
	// CFRelease(multi);
}

- (void) setUrlDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABHomePageLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABURLProperty];
	// CFRelease(multi);
}

// Not used/shown on iPhone
- (void) setRelatedNameDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABMotherLabel, kABFatherLabel, kABParentLabel,
	// kABSisterLabel, kABBrotherLabel, kABChildLabel,
	// kABFriendLabel, kABSpouseLabel, kABPartnerLabel,
	// kABManagerLabel, kABAssistantLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABRelatedNamesProperty];
	// CFRelease(multi);
}

- (void) setDateDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABAnniversaryLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDateTimePropertyType];
	[self setMulti:multi forProperty:kABDateProperty];
	// CFRelease(multi);
}

- (void) setAddressDictionaries: (NSArray *) dictionaries
{
	// kABAddressStreetKey, kABAddressCityKey, kABAddressStateKey
	// kABAddressZIPKey, kABAddressCountryKey, kABAddressCountryCodeKey
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDictionaryPropertyType];
	[self setMulti:multi forProperty:kABAddressProperty];
	// CFRelease(multi);
}

- (void) setSmsDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel,
	// kABInstantMessageServiceKey, kABInstantMessageUsernameKey
	// kABInstantMessageServiceYahoo, kABInstantMessageServiceJabber
	// kABInstantMessageServiceMSN, kABInstantMessageServiceICQ
	// kABInstantMessageServiceAIM,
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDictionaryPropertyType];
	[self setMulti:multi forProperty:kABInstantMessageProperty];
	// CFRelease(multi);
}
*/
/*
#pragma mark Images
- (UIImage *) image
{
	if (!ABPersonHasImageData(record)) return nil;
	CFDataRef imageData = ABPersonCopyImageData(record);
	UIImage *image = [UIImage imageWithData:(NSData *) imageData];
	CFRelease(imageData);
	return image;
}

- (void) setImage: (UIImage *) image
{
	CFErrorRef error;
	BOOL success;

	if (image == nil) // remove
	{
		if (!ABPersonHasImageData(record)) return; // no image to remove
		success = ABPersonRemoveImageData(record, &error);
		if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
		return;
	}

	NSData *data = UIImagePNGRepresentation(image);
	success = ABPersonSetImageData(record, (CFDataRef) data, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
}

#pragma mark Representations

// No Image
- (NSDictionary *) baseDictionaryRepresentation
{
	NSMutableDictionary *dict = @{}.mutableCopy;
	if (self.firstname) [dict setObject:self.firstname forKey:FIRST_NAME_STRING];
	if (self.middlename) [dict setObject:self.middlename forKey:MIDDLE_NAME_STRING];
	if (self.lastname) [dict setObject:self.lastname forKey:LAST_NAME_STRING];

	if (self.prefix) [dict setObject:self.prefix forKey:PREFIX_STRING];
	if (self.suffix) [dict setObject:self.suffix forKey:SUFFIX_STRING];
	if (self.nickname) [dict setObject:self.nickname forKey:NICKNAME_STRING];

	if (self.firstnamephonetic) [dict setObject:self.firstnamephonetic forKey:PHONETIC_FIRST_STRING];
	if (self.middlenamephonetic) [dict setObject:self.middlenamephonetic forKey:PHONETIC_MIDDLE_STRING];
	if (self.lastnamephonetic) [dict setObject:self.lastnamephonetic forKey:PHONETIC_LAST_STRING];

	if (self.organization) [dict setObject:self.organization forKey:ORGANIZATION_STRING];
	if (self.jobtitle) [dict setObject:self.jobtitle forKey:JOBTITLE_STRING];
	if (self.department) [dict setObject:self.department forKey:DEPARTMENT_STRING];

	if (self.note) [dict setObject:self.note forKey:NOTE_STRING];

	if (self.kind) [dict setObject:self.kind forKey:KIND_STRING];

	if (self.birthday) [dict setObject:self.birthday forKey:BIRTHDAY_STRING];
	if (self.creationDate) [dict setObject:self.creationDate forKey:CREATION_DATE_STRING];
	if (self.modificationDate) [dict setObject:self.modificationDate forKey:MODIFICATION_DATE_STRING];

	[dict setObject:self.emailDictionaries forKey:EMAIL_STRING];
	[dict setObject:self.addressDictionaries forKey:ADDRESS_STRING];
	[dict setObject:self.dateDictionaries forKey:DATE_STRING];
	[dict setObject:self.phoneDictionaries forKey:PHONE_STRING];
	[dict setObject:self.smsDictionaries forKey:SMS_STRING];
	[dict setObject:self.urlDictionaries forKey:URL_STRING];
	[dict setObject:self.relatedNameDictionaries forKey:RELATED_STRING];

	return dict;
}

// With image where available
- (NSDictionary *) dictionaryRepresentation
{
	NSMutableDictionary *dict = [[[self baseDictionaryRepresentation] mutableCopy] autorelease];
	if (ABPersonHasImageData(record))
	{
		CFDataRef imageData = ABPersonCopyImageData(record);
		[dict setObject:(NSData *)imageData forKey:IMAGE_STRING];
		CFRelease(imageData);
	}
	return dict;
}

// No Image
- (NSData *) baseDataRepresentation
{
	NSS*errorString;
	NSDictionary *dict = [self baseDictionaryRepresentation];
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	if (!data) CFShow(errorString);
	return data;
}


// With image where available
- (NSData *) dataRepresentation
{
	NSS*errorString;
	NSDictionary *dict = [self dictionaryRepresentation];
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	if (!data) CFShow(errorString);
	return data;
}

+ contactWithDictionary: (NSDictionary *) dict
{
	ABContact *contact = [ABContact contact];
	if ([dict objectForKey:FIRST_NAME_STRING]) contact.firstname = [dict objectForKey:FIRST_NAME_STRING];
	if ([dict objectForKey:MIDDLE_NAME_STRING]) contact.middlename = [dict objectForKey:MIDDLE_NAME_STRING];
	if ([dict objectForKey:LAST_NAME_STRING]) contact.lastname = [dict objectForKey:LAST_NAME_STRING];

	if ([dict objectForKey:PREFIX_STRING]) contact.prefix = [dict objectForKey:PREFIX_STRING];
	if ([dict objectForKey:SUFFIX_STRING]) contact.suffix = [dict objectForKey:SUFFIX_STRING];
	if ([dict objectForKey:NICKNAME_STRING]) contact.nickname = [dict objectForKey:NICKNAME_STRING];

	if ([dict objectForKey:PHONETIC_FIRST_STRING]) contact.firstnamephonetic = [dict objectForKey:PHONETIC_FIRST_STRING];
	if ([dict objectForKey:PHONETIC_MIDDLE_STRING]) contact.middlenamephonetic = [dict objectForKey:PHONETIC_MIDDLE_STRING];
	if ([dict objectForKey:PHONETIC_LAST_STRING]) contact.lastnamephonetic = [dict objectForKey:PHONETIC_LAST_STRING];

	if ([dict objectForKey:ORGANIZATION_STRING]) contact.organization = [dict objectForKey:ORGANIZATION_STRING];
	if ([dict objectForKey:JOBTITLE_STRING]) contact.jobtitle = [dict objectForKey:JOBTITLE_STRING];
	if ([dict objectForKey:DEPARTMENT_STRING]) contact.department = [dict objectForKey:DEPARTMENT_STRING];

	if ([dict objectForKey:NOTE_STRING]) contact.note = [dict objectForKey:NOTE_STRING];

	if ([dict objectForKey:KIND_STRING]) contact.kind = [dict objectForKey:KIND_STRING];

	if ([dict objectForKey:EMAIL_STRING]) contact.emailDictionaries = [dict objectForKey:EMAIL_STRING];
	if ([dict objectForKey:ADDRESS_STRING]) contact.addressDictionaries = [dict objectForKey:ADDRESS_STRING];
	if ([dict objectForKey:DATE_STRING]) contact.dateDictionaries = [dict objectForKey:DATE_STRING];
	if ([dict objectForKey:PHONE_STRING]) contact.phoneDictionaries = [dict objectForKey:PHONE_STRING];
	if ([dict objectForKey:SMS_STRING]) contact.smsDictionaries = [dict objectForKey:SMS_STRING];
	if ([dict objectForKey:URL_STRING]) contact.urlDictionaries = [dict objectForKey:URL_STRING];
	if ([dict objectForKey:RELATED_STRING]) contact.relatedNameDictionaries = [dict objectForKey:RELATED_STRING];

	if ([dict objectForKey:IMAGE_STRING])
	{
		CFErrorRef error;
 		BOOL success = ABPersonSetImageData(contact.record, (CFDataRef) [dict objectForKey:IMAGE_STRING], &error);
		if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	}

	return contact;
}

+ contactWithData: (NSData *) data
{
	// Otherwise handle points
	CFStringRef errorString;
	CFPropertyListRef plist = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data, kCFPropertyListMutableContainers, &errorString);
	if (!plist)
	{
		CFShow(errorString);
		return nil;
	}

	NSDictionary *dict = (NSDictionary *) plist;
	[dict autorelease];

	return [self contactWithDictionary:dict];
}
@end


#define CFAutorelease(obj) ({CFTypeRef _obj = (obj); (_obj == NULL) ? NULL : [(id)CFMakeCollectable(_obj) autorelease]; })

@implementation ABGroup
@synthesize record;

// Thanks to Quentarez, Ciaran
- (id) initWithRecord: (ABRecordRef) aRecord
{
	if (self = [super init]) record = CFRetain(aRecord);
	return self;
}

+ groupWithRecord: (ABRecordRef) grouprec
{
	return [[ABGroup.alloc initWithRecord:grouprec] autorelease];
}

+ groupWithRecordID: (ABRecordID) recordID
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	ABRecordRef grouprec = ABAddressBookGetGroupWithRecordID(addressBook, recordID);
	ABGroup *group = [self groupWithRecord:grouprec];
	CFRelease(grouprec);
	return group;
}

// Thanks to Ciaran
+ group
{
	ABRecordRef grouprec = ABGroupCreate();
	id group = [ABGroup groupWithRecord:grouprec];
	CFRelease(grouprec);
	return group;
}

- (void) dealloc
{
	if (record) CFRelease(record);
	[super dealloc];
}

- (BOOL) removeSelfFromAddressBook: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	if (!ABAddressBookRemoveRecord(addressBook, self.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook,  (CFErrorRef *) error);
}

#pragma mark Record ID and Type
- (ABRecordID) recordID	{	return ABRecordGetRecordID(record);}
- (ABRecordType) recordType	{	return ABRecordGetRecordType(record);}
- (BOOL) isPerson	{	return self.recordType == kABType;}

#pragma mark management
- (NSArray *) members
{
	NSArray *contacts = (NSArray *)ABGroupCopyArrayOfAllMembers(self.record);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:contacts.count];
	for (id contact in contacts)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)contact]];
	[contacts release];
	return array;
}

// kABSortByFirstName = 0, kABSortByLastName  = 1
- (NSArray *) membersWithSorting: (ABPersonSortOrdering) ordering
{
	NSArray *contacts = (NSArray *)ABGroupCopyArrayOfAllMembersWithSortOrdering(self.record, ordering);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:contacts.count];
	for (id contact in contacts)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)contact]];
	[contacts release];
	return array;
}

- (BOOL) addMember: (ABContact *) contact withError: (NSError **) error
{
	return ABGroupAddMember(self.record, contact.record, (CFErrorRef *) error);
}

- (BOOL) removeMember: (ABContact *) contact withError: (NSError **) error
{
	return ABGroupRemoveMember(self.record, contact.record, (CFErrorRef *) error);
}

#pragma mark name

- (NSS*) getRecordString:(ABPropertyID) anID
{
	return [(NSS*) ABRecordCopyValue(record, anID) autorelease];
}

- (NSS*) name
{
	NSS*string = [self.record valueForKey::kABGroupNameProperty];
	return string;
}

- (void) setName: (NSS*) aString
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, kABGroupNameProperty, (CFStringRef) aString, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
}
@end


#define CFAutorelease(obj) ({CFTypeRef _obj = (obj); (_obj == NULL) ? NULL : [(id)CFMakeCollectable(_obj) autorelease]; })

@implementation ABContactsHelper

// Note: You cannot CFRelease the addressbook after CFAutorelease(ABAddressBookCreate());

+ (ABAddressBookRef) addressBook
{
	return CFAutorelease(ABAddressBookCreate());
}

+ (NSArray *) contacts
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:thePeople.count];
	for (id person in thePeople)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
	[thePeople release];
	return array;
}

+ (int) contactsCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	return ABAddressBookGetPersonCount(addressBook);
}

+ (int) contactsWithImageCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

+ (int) contactsWithoutImageCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (!ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

// Groups
+ (int) numberOfGroups
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	int ncount = groups.count;
	[groups release];
	return ncount;
}

+ (NSArray *) groups
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:groups.count];
	for (id group in groups)
		[array addObject:[ABGroup groupWithRecord:(ABRecordRef)group]];
	[groups release];
	return array;
}

// Sorting
+ (BOOL) firstNameSorting
{
	return (ABPersonGetCompositeNameFormat() == kABCompositeNameFormatFirstNameFirst);
}

#pragma mark Contact Management

// Thanks to Eridius for suggestions re: error
+ (BOOL) addContact: (ABContact *) aContact withError: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	if (!ABAddressBookAddRecord(addressBook, aContact.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (BOOL) addGroup: (ABGroup *) aGroup withError: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	if (!ABAddressBookAddRecord(addressBook, aGroup.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (NSArray *) contactsMatchingName: (NSS*) fname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", fname, fname, fname, fname];
	return [contacts filteredArrayUsingPredicate:pred];
}

+ (NSArray *) contactsMatchingName: (NSS*) fname andName: (NSS*) lname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", fname, fname, fname, fname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", lname, lname, lname, lname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	return contacts;
}

+ (NSArray *) contactsMatchingPhone: (NSS*) number
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"phonenumbers contains[cd] %@", number];
	return [contacts filteredArrayUsingPredicate:pred];
}

+ (NSArray *) groupsMatchingName: (NSS*) fname
{
	NSPredicate *pred;
	NSArray *groups = [ABContactsHelper groups];
	pred = [NSPredicate predicateWithFormat:@"name contains[cd] %@ ", fname];
	return [groups filteredArrayUsingPredicate:pred];
}
@end


@implementation AddressBookImageLoader
@synthesize images, view;//, dbx, bv;

- (void) awakeFromNib
{


	//	[view setRowHeight:60];
	[self willChangeValueForKey:@"images"];

	images = [NSMutableArray array];


	//	dbx = [DBXObject sharedInstance];
	for (ABPerson *person in [[ABAddressBook sharedAddressBook] people])
		//	for (DBXApp *app in dbx.appArray) {
	{
		NSData *imageData = [person imageData];
		if (nil != imageData)
		{
		}
		////			AGBox *b = [AGBox new];
		//			NSImage *image = [NSImage.alloc initWithData:imageData];
		//			[[NSImageView alloc]initWithFrame: setContents:image];
		//			[images addbject:b];
		////			b.layer.contents = [NSImage  image imageData ima]
		//
		//		}
		//		//		[images addObject:];
		//		//NSLog(@" Adding images for %@", app.name);
		//
		//		//			[images addObject:app.image];
		//		//		}
		//		}
		//		[self didChangeValueForKey:@"images"];
		//
		//		for (int x =0; x <100; x++) {
		//
		//		[bv addSubview:[images objectAtIndex:x]];
		
	}
}
@end

*/


