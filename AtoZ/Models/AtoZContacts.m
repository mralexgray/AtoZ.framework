

#import "AtoZ.h"
#import <Quartz/Quartz.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABImageLoading.h>
#import <AddressBook/ABTypedefs.h>
#import <AddressBook/ABRecord.h>
#import "AtoZContacts.h"

@interface AtoZContact ()
@property (STRNG)	NSS* uid;
@end

@implementation AtoZContact
//+(instancetype) instanceWithImage:(NSIMG*)img imageID:(NSS*)imgID andImageSubTitle:(NSS*) subT andPersonUID:(NSS*)pUID	{
//	AtoZContact *c 	= self.instance;	c.image 				= img;	c.imageIDKey		= imgID;	c.company		 	= subT;	c.firstName				= pUID;
//	return c;}
- (NSS*) fullName { return  [$(@"%@ %@", _firstName, _lastName) stringByReplacingOccurrencesOfString:@"(null)" withString:@""]; }
@end


@interface AtoZContacts ()
@property (STRNG,NATOM) NSMA *contacts;
@property (STRNG)			NSMIS *cachedRanges;

@end

#define ABAB ABAddressBook.sharedAddressBook

@implementation AtoZContacts

+ (NSA*) contacts 		{ return [self.shared contacts]; 	}

- (id) init  								{
	
	if (self != super.init ) return nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[AZStopwatch named:@"contacts.create" block:^{
			_cachedRanges = NSMIS.new;
			_contacts = [ABAB.people cw_mapArray:^id(ABPerson* person){ 
				AtoZContact *cc = AtoZContact.instance;
				cc.lastName 	= [[person valueForProperty:     kABLastNameProperty]	copy];
				cc.firstName	= [[person valueForProperty:    kABFirstNameProperty] copy];
				cc.company 		= [[person valueForProperty: kABOrganizationProperty] copy];
				cc.uid  = [[person valueForProperty: kABUIDProperty]				copy];
				return cc ?: nil;
			}].mutableCopy;
		}];
	});
	return self;
}
//		return [AtoZContact instanceWithImage:[person imageData] ? [NSImage imageWithData:person.imageData] : nil
//		             imageID:name andImageSubTitle:[person valueForProperty: kABOrganizationProperty] 
//				  andPersonUID: [person uniqueId]];
- (NSA*) contactImages 						{  return  [self.contacts cw_mapArray:^id(AZContact *c) {  return [c image] ?: nil; }]; }
-   (id)	contactAtIndex:(NSUI)i				{ 

	AtoZContact *c = _contacts[i]; if (c.cached) return c;
	
	ABRecord *b = [ABAB recordForUniqueId:c.uid];
	c.image 	= ([b imageData]) ? [NSImage imageWithData:[b imageData]] : nil;
	c.cached = YES; [self.cachedRanges addIndex:i];
	return c;
}
								
- (NSUI) numberOfContacts { return self.contacts.count; }
- (NSA*)	contactsInRange:(NSRange)r {  

	NSA* a = [[@(r.location) to:@(r.length + r.location)] cw_mapArray:^id(id object) {
		NSUI currentIndex = [object unsignedIntegerValue]; 
		return [self.cachedRanges containsIndex:currentIndex] ? _contacts[currentIndex] : [self contactAtIndex:currentIndex];
	}];
	[self.cachedRanges addIndexesInRange:r];
	return a;
}

- (id) find:(id) sender						{

	#define SSS [sender stringValue]
	#define ABCOMP kABContainsSubStringCaseInsensitive
	return [SSS isEqualToString:@""] ? self.contacts : ^{

      ABSearchElement *lastNameFrom 	= [ABPerson searchElementForProperty:kABLastNameProperty 	 	   label:nil key:nil value:SSS comparison:ABCOMP];
		ABSearchElement *firstNameFrom 	= [ABPerson searchElementForProperty:kABFirstNameProperty  	      label:nil key:nil value:SSS comparison:ABCOMP];
      ABSearchElement *companyFrom 		= [ABPerson searchElementForProperty:kABOrganizationProperty      label:nil key:nil value:SSS comparison:ABCOMP];
		ABSearchElement *wholeQuery 		= [ABSearchElement searchElementForConjunction:kABSearchOr children:@[lastNameFrom, firstNameFrom, companyFrom]];
//		return [self.contacts filter:^BOOL(id object) {
		return [[ABAddressBook sharedAddressBook] recordsMatchingSearchElement:wholeQuery];
	}();
}
//- (AZContact*)	contactAtIndex:(NSUI)i 									{ return _contacts[i]; }
- (void) openCardAtIndex:(NSUI)index									{

	[AZWORKSPACE openURL: [NSURL URLWithString:[NSS stringWithFormat:@"addressbook://%@",[_contacts[index] personUID]]]];
}
- (void) controlTextDidChange:(NSNotification *)aNotification	{    [self find:nil];	}


@end
