
#import <AtoZ/AtoZ.h>
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
@property NSMA *contacts;
@property NSMIS *cachedRanges;
@end
#define ABAB ABAddressBook.sharedAddressBook
@implementation AtoZContacts 
- (id) init  								{
	
	if (!(self = super.init)) return nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[AZStopwatch named:@"contacts.create" block:^{
			_cachedRanges = NSMIS.new;
			_contacts = [ABAB.people cw_mapArray:^id(ABPerson* person){

      //properties);
				AtoZContact *cc = AtoZContact.instance;
				cc.lastName 	= [[person valueForProperty:     kABLastNameProperty]	copy];
				cc.firstName	= [[person valueForProperty:    kABFirstNameProperty] copy];

        ABMultiValue *x; if ((x = [person valueForProperty:kABPhoneProperty])) {

          [@"ss".properties self];
          NSString *__unused phone = nil;
          int count = [x count];
//          if (count > 1) {
          // find the right one (work?)
          unsigned i;
          for (i = 0; i < count; i++) { if (!!cc.tel) break;
            NSString *label = [x labelAtIndex:i];
            if ([label isEqualToString:kABPhoneMainLabel] || [label isEqualToString:kABPhoneWorkLabel])
            cc.tel = [x valueAtIndex:i];
          }
        }
//if (IS_NULL(phone)) phone = [obj valueAtIndex:0];
//if (NOT_NULL(phone)) [doc setPhone:phone];
//}




//        CFTypeRef phoneProperty = ABRecordCopyValue((__bridge ABRecordRef)person,
//                                                    (__bridge CFStringRef)kABPhoneProperty);
//        NSArray *phones = (__bridge NSArray*)ABMultiValueCreateCopy(phoneProperty);
//        if (phones.count) cc.tel = [phones.firstObject copy];
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
+ (NSA*) contactImages {
  return  [[self.shared contacts] cw_mapArray:^id(AZContact *c) {  return [c image] ?: nil; }];
}
-   (id)	contactAtIndex:(NSUI)i				{ 
	AtoZContact *c = _contacts[i]; if (c.cached) return c;
	
	ABRecord *b = [ABAB recordForUniqueId:c.uid];
	c.image 	= ([b imageData]) ? [NSImage imageWithData:[b imageData]] : nil;
	c.cached = YES; [self.cachedRanges addIndex:i];
	return c;
}
								
- (NSUI) numberOfContacts { return self.contacts.count; }
+ (NSA*)	contactsInRange:(NSRange)r { return [self.shared contactsInRange:r]; }
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

// <prototypes>
int usage();
void printPeopleWithFormat(NSArray *people, NSString *format);
void showHeader(NSArray* formatters);
NSInteger peopleSort(id peep1, id peep2, void *context);
// </prototypes>
// members
BOOL show_headers = YES;
BOOL only_birthdays = NO;
BOOL sort = NO;
// These are declared in FormatHelper.m
//extern BOOL loose
//extern BOOL strict;/
//extern BOOL firstname_first;

BOOL loose, strict, firstname_first;

/*
 * contacts.m
 * Makes the Mac OS X address book available from the command-line AddressBook info available from this URL: *
 * http://developer.apple.com/techpubs/macosx/AdditionalTechnologies/AddressBook
 * @author Shane Celis <shane@gnufoo.org>
 */
/*
 * Here are the format specifies:
 *
 * %u   unique identifier
 *
 * %n   name (first and last)
 * %fn  first name
 * %ln  last name
 * %nn  nick name
 *
 * %p   phone (whichever comes up first)
 * %hp  home phone
 * %wp  work phone
 * %mp  mobile phone
 * %Mp  main phone
 * %fp  fax phone
 * %op  other phone
 * %pp  pager phone
 *
 * %a   addresss (whichever comes up first)
 * %ha  home address
 * %wa  work address
 *
 * %e   email (whichever comes up first)
 * %he  home email
 * %we  work email
 * %oe  other email
 *
 * %t   title
 * %c   company
 * %g   group
 * %w   homepage/webpage
 *
 * %b   birthday (full NSCalendarDate description)
 * %bb  birthday (mm/dd)
 * %i   instant messaging
 * %ai  aim IM
 * %yi  Yahoo IM
 * %ji  Jabber IM
 * %ii  ICQ IM
 * %mi  MSN IM
 *
 * %N   note
 *
 * Maybe the best way to do this would be to create a map.  Use the
 * format tag (e.g. "%n") as the key and the header (e.g. "NAME") and
 * the printf format tag (e.g. "%-15s") pair as the value.  This would
 * be a nice solution for _most_ of the entries, however, there are a
 * number of special cases that require more than just a map.
 *
 */
#import <unistd.h>


NSString * returnPeopleWithFormat(NSArray *people,
                           NSString *format);
                           
/*
  Returns true if the object is nil or the string is empty (e.g. "").
*/
BOOL isNullString(NSString* string) {
    if (string == nil)
        return true;
    else if ([string length] == 0)
        return true;
    // could trim it and check too.
    else
        return false;
}
/*
  Returns the value for a given property and label (purely convenience).
*/
id getValueForLabel(ABPerson *person,
                    NSString *property,
                    NSString *label) {
    id value;
    int count;
    int index;
    ABMultiValue* multi;
    
    value = [person valueForProperty:property];
    if (label == nil) {
        return value; // may be nil
    }
    multi = value;
    count = [multi count];
    for(index = 0; index < count; index++) {
        if ([label isEqualToString: [multi labelAtIndex: index]]) {
            return [multi valueAtIndex: index];
        }
    }
    return nil;
}
/*
  Returns a string value for a given property and label (purely
  convenience); if the value is nil, it'll return a zero-length
  string.
*/
NSString *getStringForLabel(ABPerson *person,
                           NSString *property,
                           NSString *label) {
    NSString *value;
    value = (NSString *) getValueForLabel(person, property, label);
    if (value == nil)
        return @"";
    return value;
    
}
/*
 * Returns a string value for a date-property 
 * NSCalendarDate seems to be obsolete now ...
*/
NSString *getDateForLabel(ABPerson *person,
                               NSString *property,
                               NSString *label) {
    NSCalendarDate *value;
    value = (NSCalendarDate *) getValueForLabel(person, property, label);
    if (value == nil)
      return @"99/99";
    return [value descriptionWithCalendarFormat:@"%m/%d"];
}


@interface FormatHelper : NSObject {
@protected
    NSString *literalValue;
    NSString *token;
}
- (id) initWithFormatToken: (NSString *) atoken;

- (id) initWithStringLiteral: (NSString *) literal;
    
- (char) type;

- (char) subtype;

- (int) fieldSize;

- (NSString *) printfToken;

- (NSString *) headerName;

- (NSString *) valueForPerson: (ABPerson *) person;

- (NSString *) valueForPerson: (ABPerson *) person withToken: (NSString *) aToken;
- (NSString *) valueForPerson: (ABPerson *) person withTokenPref: (NSArray *) tokens;

- (NSString *) addressForPerson: (ABPerson *) person withLabel: (NSString *) label;
                                                                             
- (NSString *) getNameString: (ABPerson *) person;

@end

/*
  Parses the format string for FormatHelper tokens.
*/
NSArray *getFormatHelpers(NSString *format) {

    NSMutableArray *array = [NSMutableArray array];
    const char *str;
    
    for(str = (char*)format.UTF8String; str != NULL; str++) {
        if (str[0] == '%') {
            if (&str[1] != NULL) {
                // skip double percents
                if (str[1] == '%') {
                    str++;
                    [array addObject: [[FormatHelper alloc] 
                                          initWithStringLiteral: @"%"]];
                    continue;
                }
                NSString *token = nil;
                if (str[2] && (str[2] == 'e' || str[2] == 'p'
                                       || str[2] == 'n' || str[2] == 'i' 
                                       || str[2] == 'a' || str[2] == 'b')) {
                    token = [NSString stringWithFormat: @"%%%c%c", 
                                      str[1], str[2]];
                    str++;
                    str++;
                } else {
                    token = [NSString stringWithFormat: @"%%%c", str[1]];
                    str++;
                }
                    
                FormatHelper *helper = [[FormatHelper alloc] 
                                           initWithFormatToken: token];
                if ([helper headerName] == nil) 
                    fprintf(stderr, "warning: invalid format token given \"%s\"\n",
                            [token UTF8String]);
                else
                    [array addObject: helper];
            }
        } else {
            FormatHelper *helper = [[FormatHelper alloc] initWithStringLiteral: 
                                    [NSString stringWithFormat: @"%c", str[0]]];
            [array addObject: helper];
            //printf("got literal \"%c\"\n", str[0]);
        }
    }
    return array;
}

@implementation FormatHelper
/*
  Initialize with a token (e.g. "%fn").
*/
- (id) initWithFormatToken: (NSString *) atoken {
    token = atoken; literalValue = nil; return self;
}
- (id) initWithStringLiteral: (NSString *) literal {
    token = nil;
    literalValue = literal;
    return self;
}
/*
  Returns a printf token (e.g. "%-12.11s").
*/
- (NSString *) printfToken {
    if (literalValue != nil)
        return @"%s";
    int size = [self fieldSize];
//    if (strict)
//        return @"%s";
//    else if (loose)
        return [NSString stringWithFormat: @"%%-%ds", size];
//    else
//        return [NSString stringWithFormat: @"%%-%d.%ds", size, size];
}
/*
  Returns the field size for a particular token.
*/
- (int) fieldSize {
    if (literalValue != nil)
        return 1;
    // these values should be in the preferences...
    switch ([self type]) {
    case 'u':
        return 45;
    case 'n':
        switch ([self subtype]) {
        case 'f':
            return 12;
        case 'l':
            return 12;
        case 'n':
            return 12;
        default:
            return 21;
        }
    case 'w':
        return 25;
    case 'i':
        return 19;
    case 'e':
        return 23;
    case 'a': 
        return 45;
    case 'p':
        return 14;
        //     case 'N':
        //         return @"\nNOTE: %s";
    case 'N':
        return 76;
    default:
        return 12;
    }
}
/*
  Returns the type of the token.  For example, the token "%fn" has a
  'n' type.
*/
- (char) type {
    return [token characterAtIndex: ([token length] - 1)];
}
/*
  Returns the subtype of the token.  For example, the token "%fn" has
  a 'f' type.
*/
- (char) subtype {
    return [token characterAtIndex: ([token length] - 2)];
}
/*
  Returns the header for the token.  For example, the token "%n" has a
  header of "NAME".
*/
- (NSString *) headerName {
    if (literalValue != nil)
        return literalValue;
    int subtype = [self subtype];
    switch ([self type]) {
    case 'u':
        return @"UID";
    case 'n':
        switch (subtype) {
        case 'f':
            return @"FIRST";
        case 'l':
            return @"LAST";
        case 'n':
            return @"NICK";
        default:
            return @"NAME";
        }
    case 'p':
        switch (subtype) {
        case 'h':
            return @"HOME";
        case 'w':
            return @"WORK";
        case 'm':
            return @"MOBILE";
        case 'p':
            return @"PAGER";
        case 'f':
            return @"FAX";
        case 'M':
            return @"MAIN";
        case 'o':
            return @"OTHER";
        default:
            return @"PHONE";
        }
    case 'a':
        switch (subtype) {
        case 'h':
            return @"HOME";
        case 'w':
            return @"WORK";
        default:
            return @"ADDRESS";
        }
    case 'e':
        switch (subtype) {
        case 'h':
            return @"HOME";
        case 'w':
            return @"WORK";
        case 'o':
            return @"OTHER";
        default:
            return @"EMAIL";
        }
    case 't':
        return @"TITLE";
    case 'c':
        return @"COMPANY";
    case 'g':
        return @"GROUP";
    case 'w':
        return @"HOMEPAGE";
    case 'b':
        switch (subtype) {
        case 'b':
          return @"BIRTHDAY";
        default:
          return @"BIRTHDAY";
        }
    case 'i':
        switch (subtype) {
        case 'a':
            return @"AIM";
        case 'y':
            return @"YAHOO";
        case 'j':
            return @"JABBER";
        case 'i':
            return @"ICQ";
        case 'm':
            return @"MSN";
        default:
            return @"IM";
        }
    case 'N':
        return @"";             // Note doesn't have a header (should
                                // come at the end)
    }
    return nil;
}
/*
  Returns the value for a person with this instance's token.
*/
- (NSString *) valueForPerson: (ABPerson *) person {
    return [self valueForPerson: person withToken: token];
}
/*
  Returns the value for a person with a particular token (e.g. "%fn")
*/
- (NSString *) valueForPerson: (ABPerson *) person 
                    withToken: (NSString *) aToken {
    NSString *scratch = nil;          // just a temp value
    //int subtype = [self subtype];
    int length = [aToken length];
    char type = [aToken characterAtIndex: (length - 1)];
    char subtype = [aToken characterAtIndex: (length - 2)];
    if (literalValue != nil)
        return literalValue;
    switch (type) {
    case 'u':
        return [person uniqueId];
    case 'n':
        switch (subtype) {
        case 'f':
            return getStringForLabel(person, kABFirstNameProperty, nil);
        case 'l':
            return getStringForLabel(person, kABLastNameProperty, nil);
        case 'n':
            return getStringForLabel(person, kABNicknameProperty, nil);
        default:
            return [self getNameString: person];
            // Show company name if no first and last name is given.
//             if (isNullString([self valueForPerson: person withToken: @"%fn"])
//                && isNullString([self valueForPerson: person withToken: @"%ln"]))
//                 return [self valueForPerson: person withToken: @"%c"];
//             return [NSString stringWithFormat: @"%@ %@",
//                              [self valueForPerson: person withToken: @"%fn"],
//                              [self valueForPerson: person withToken: @"%ln"]];
        }
    case 'p':
        switch (subtype) {
        case 'h':
            return getStringForLabel(person, 
                                    kABPhoneProperty, 
                                    kABPhoneHomeLabel);
        case 'w':
            return getStringForLabel(person, 
                                    kABPhoneProperty, 
                                    kABPhoneWorkLabel);
        case 'm':
            return getStringForLabel(person, 
                                    kABPhoneProperty, 
                                    kABPhoneMobileLabel);
        case 'M':
            return getStringForLabel(person, 
                                    kABPhoneProperty, 
                                    kABPhoneMainLabel);
        case 'f':
            // We don't differentiate here... I don't think it's worth the effort
            scratch = getStringForLabel(person, 
                                       kABPhoneProperty, 
                                       kABPhoneHomeFAXLabel);
            if (!isNullString(scratch))
                return scratch;
            return getStringForLabel(person, 
                                    kABPhoneProperty, 
                                    kABPhoneWorkFAXLabel);
        case 'p':
            return getStringForLabel(person, 
                                    kABPhoneProperty, 
                                    kABPhonePagerLabel);
        case 'o':
            return getStringForLabel(person, 
                                    kABPhoneProperty, 
                                    kABOtherLabel);
        default:
            return [self valueForPerson: person withTokenPref: 
                             [NSArray arrayWithObjects: @"%hp", @"%wp", @"%mp", 
                                      @"%Mp", @"%pp", @"%fp", @"%op", nil]];
        }
    case 'a':
        switch (subtype) {
        case 'h':
            return [self addressForPerson: person
                         withLabel: kABAddressHomeLabel];
        case 'w':
             return [self addressForPerson: person
                          withLabel: kABAddressWorkLabel];
        case 'o':
             return [self addressForPerson: person
                          withLabel: kABOtherLabel];
        default:
             return [self valueForPerson: person withTokenPref: 
                              [NSArray arrayWithObjects: @"%ha", @"wa", 
                                       @"oa", nil]];
        }
        
    case 'e':
        switch (subtype) {
        case 'h':
            return getStringForLabel(person, 
                                    kABEmailProperty, 
                                    kABEmailHomeLabel);
        case 'w':
            return getStringForLabel(person, 
                                    kABEmailProperty, 
                                    kABEmailWorkLabel);
        case 'o':
            return getStringForLabel(person, 
                                    kABEmailProperty, 
                                    kABOtherLabel);
        default:
            return [self valueForPerson: person withTokenPref: 
                             [NSArray arrayWithObjects: @"%he", @"%we", 
                                      @"%oe", nil]];
        }
    case 't':
        return getStringForLabel(person, 
                                kABJobTitleProperty, 
                                nil);
    case 'c':
        return getStringForLabel(person, 
                                kABOrganizationProperty,
                                nil);
    case 'w':
        return getStringForLabel(person, 
                                kABHomePageProperty,
                                nil);
    case 'b': 
        switch (subtype) {
        case 'b':
            return getDateForLabel(person, 
                                   kABBirthdayProperty,
                                   nil);
        default:
            return [getStringForLabel(person, 
                                   kABBirthdayProperty,
                                   nil) description];
        }
    case 'i':
        switch (subtype) {
        case 'a':
            return getStringForLabel(person, 
                                    kABAIMInstantProperty, 
                                    kABAIMHomeLabel);
        case 'y':
            return getStringForLabel(person, 
                                    kABYahooInstantProperty, 
                                    kABYahooHomeLabel);
        case 'j':
            return getStringForLabel(person, 
                                    kABJabberInstantProperty, 
                                    kABJabberHomeLabel);
        case 'i':
            return getStringForLabel(person, 
                                    kABICQInstantProperty, 
                                    kABICQHomeLabel);
        case 'm':
            return getStringForLabel(person, 
                                    kABMSNInstantProperty, 
                                    kABMSNHomeLabel);
        default:
            return [self valueForPerson: person withTokenPref: 
                             [NSArray arrayWithObjects: @"%ai", @"%yi", @"%ji",
                                      @"%ii", @"%mi", nil]];
        }
    case 'g':
        return getStringForLabel(person, kABGroupNameProperty, nil);
            
    case 'N':
        // trim the note string
        scratch = getStringForLabel(person, kABNoteProperty, nil);
        scratch = [scratch stringByTrimmingCharactersInSet: 
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // make it all fit on one line, if we're not loosely formatting
        if (!loose) {
            int len = [scratch length];
            NSMutableString *temp = [NSMutableString stringWithCapacity: len];
            [temp setString: scratch];
            [temp replaceOccurrencesOfString: @"\n" 
                  withString: @" "
                  options: NSLiteralSearch
                  range: NSMakeRange(0, len)];
            scratch = temp;
        }
            
        return [NSString stringWithFormat: @"\nNOTE: %@", scratch];
    }
    return nil;
}
/*
  Returns value for a person with a set of tokens in order of preference.
*/
- (NSString *) valueForPerson: (ABPerson *) person 
                 withTokenPref: (NSArray *) tokens
{
    NSEnumerator* tokenEnum = [tokens objectEnumerator];
    NSString* atoken;
    NSString* scratch;
    while((atoken = [tokenEnum nextObject]) != nil) {
        scratch = [self valueForPerson: person withToken: atoken];
        if (!isNullString(scratch))
            return scratch;
    }
    return @"";
}
/*
  Returns a string version of the address.
*/
- (NSString *) addressForPerson: (ABPerson *) person
                      withLabel: (NSString *) label 
{
    NSDictionary *dict;
    NSMutableString *address;
    NSString *value;
    dict = (NSDictionary *) getValueForLabel(person,
                                             kABAddressProperty,
                                             label);
    if (dict == nil)
        return @"";
    address = [NSMutableString string];
    if (value = [dict objectForKey: kABAddressStreetKey]) {
        [address appendFormat: @"%@, ", value];
    }
    if (value = [dict objectForKey: kABAddressCityKey]) {
        [address appendFormat: @"%@, ", value];
    }
    if (value = [dict objectForKey: kABAddressStateKey]) {
        [address appendFormat: @"%@ ", value];
    }
    if (value = [dict objectForKey: kABAddressZIPKey]) {
        [address appendFormat: @"%@", value];
    }
    return [NSString stringWithString: address];
}
/*
  Returns the name of the person, or company, taking into account
  whether it should be firstname first or lastname first.
*/
- (NSString *) getNameString: (ABPerson *) person
{
    NSString * firstname;
    NSString * lastname;
    NSString * companyname;
    int flags;
    firstname = getStringForLabel(person, kABFirstNameProperty, nil);
    lastname = getStringForLabel(person, kABLastNameProperty, nil);
    companyname = getStringForLabel(person, kABOrganizationProperty, nil);
    
    if (isNullString(firstname) && isNullString(lastname)) {
        // Show company name if no first and last name is given.
        return companyname;
    }
    flags = [[person valueForProperty: kABPersonFlags] intValue];
    if (flags & kABShowAsCompany) {
        return companyname;
    }
    
    if (flags & kABLastNameFirst || firstname_first == NO) {
        if (isNullString(lastname))
            return firstname;
        else
            return [NSString stringWithFormat: @"%@, %@",
                             lastname,
                             firstname];
    }
    // by default use firstname first
    
    //printf("flags %d\n", flags);
    return [NSString stringWithFormat: @"%@ %@", 
                     firstname, 
                     lastname];
}
@end

/*
  Prints usage and returns an error code of 2.
*/
int usage() {
    fprintf(stderr, "usage: contacts [-hHsmnlS] [-c|-f format] [search]\n");
    // I don't know if I should make it a full-fledged client.
    //fprintf(stderr, "       contacts -a first-name last-name phone-number\n");
    fprintf(stderr, "      -h displays help (this)\n");
    fprintf(stderr, "      -H suppress header\n");
    fprintf(stderr, "      -s sort list\n");
    fprintf(stderr, "      -m show me\n");
    fprintf(stderr, "      -n displays note below each record\n");
    fprintf(stderr, "      -l loose formatting (doesn't truncate record values)\n");
    fprintf(stderr, "      -S strict formatting (doesn't add space between columns)\n");
    fprintf(stderr, "      -c output as calendar(1) file format\n");
    fprintf(stderr, "      -f accepts a format string (see man page)\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "displays contacts from the AddressBook database\n");
    return 2;
}
//int main (int argc, char * argv[]) {

NSString* shit(int argc,const char argv)  {

    BOOL show_me = NO;
    BOOL show_all = NO;
    BOOL display_note = NO;
    char ch;
    NSString *format = @"%n %p %i %e";
    while ((ch = getopt(argc, argv, "lSHsnmhcf:")) != -1)
        switch (ch) {
        case 'l':
            loose = YES;
            break;
        case 'f':
            format = [NSString stringWithUTF8String: optarg];
            break;
        case 'c':
            show_headers = NO;
            strict = YES;
            format = @"%bb\t%n"; 
            only_birthdays = YES;
            break;
        case 'H':
            show_headers = NO;
            break;
        case 'n':
            display_note = YES;
            break;
        case 'm':
            show_me = YES;
            break;
        case 's':
            sort = YES;
            break;
        case 'S':
            strict = YES;
            break;
        case 'h':
        default: break;
//            return usage();
        }
//    argc -= optind;
//    argv += optind;
//    if (argc == 0) 
//        show_all = YES;
//    if (argc > 1)
//        return usage();
    ABAddressBook *AB = [ABAddressBook sharedAddressBook];
    NSArray *peopleFound; 
    
    firstname_first = ([AB defaultNameOrdering] == kABFirstNameFirst ?
                       YES : NO);
    
    if (display_note)
        format = [format stringByAppendingString: @" %N"];
    if (show_me) {
        
        peopleFound = [NSArray arrayWithObjects: [AB me], nil];
    } else if (show_all) {
        peopleFound = [AB people];
    } else {
        // search for the string given
        NSString *searchString = [NSString stringWithUTF8String:""];// argv[0]];
        ABSearchElement *firstName =
            [ABPerson searchElementForProperty:kABFirstNameProperty
                      label:nil
                      key:nil
                      value:searchString
                      comparison:kABContainsSubStringCaseInsensitive];
        //comparison:kABEqualCaseInsensitive];
        
        ABSearchElement *lastName =
            [ABPerson searchElementForProperty:kABLastNameProperty
                      label:nil
                      key:nil
                      value:searchString
                      comparison:kABContainsSubStringCaseInsensitive];
        ABSearchElement *companyName =
            [ABPerson searchElementForProperty:kABOrganizationProperty
                      label:nil
                      key:nil
                      value:searchString
                      comparison:kABContainsSubStringCaseInsensitive];
        ABSearchElement *homeEmail =
            [ABPerson searchElementForProperty:kABEmailProperty
                      label:kABEmailHomeLabel
                      key:nil
                      value:searchString
                      comparison:kABContainsSubStringCaseInsensitive];
        ABSearchElement *workEmail =
            [ABPerson searchElementForProperty:kABEmailProperty
                      label:kABEmailWorkLabel
                      key:nil
                      value:searchString
                      comparison:kABContainsSubStringCaseInsensitive];
        ABSearchElement *aimName =
            [ABPerson searchElementForProperty:kABAIMInstantProperty
                      label:kABAIMHomeLabel
                      key:nil
                      value:searchString
                      comparison:kABContainsSubStringCaseInsensitive];
        ABSearchElement *notes =
            [ABPerson searchElementForProperty:kABAIMInstantProperty
                      label:kABNoteProperty
                      key:nil
                      value:searchString
                      comparison:kABContainsSubStringCaseInsensitive];

        
        ABSearchElement *criteria =
            [ABSearchElement searchElementForConjunction:kABSearchOr
                             children:[NSArray arrayWithObjects:
                                               firstName, 
                                               lastName,
                                               companyName,
                                               homeEmail,
                                               workEmail, 
                                               aimName,
                                               notes,
                                               nil]];
        
        
        peopleFound = [AB recordsMatchingSearchElement: criteria];
    }
    return returnPeopleWithFormat(peopleFound, format);
//    printPeopleWithFormat(peopleFound, format);
//    }
//    return 0;
}

/*
  Prints the headers from the given formatters.
*/
void showHeader(NSArray* formatters) {
    NSEnumerator *formatEnumerator = [formatters objectEnumerator];
    FormatHelper *formatter;
    while((formatter = [formatEnumerator nextObject]) != nil) {
        printf([[formatter printfToken] UTF8String],
               [[formatter headerName] UTF8String]);
    }
    printf("\n");
}


NSString * returnPeopleWithFormat(NSArray *people,
                           NSString *format) {
    ABPerson *person; 
    NSEnumerator *peopleEnum;
    NSEnumerator *formatEnumerator;
    FormatHelper *formatter;
    NSArray *formatters = getFormatHelpers(format);
    if ([formatters count] == 0)
        return @"error: no formatter tokens found\n";
    if ([people count] == 0)
        return @"error: no one found\n";
    // print the header first    
//    if (show_headers) {
//        showHeader(formatters);
//    }
//    if (sort) {
//        people = [people sortedArrayUsingFunction: peopleSort
//                         context: [formatters objectAtIndex: 0]];
//    }
    NSMutableString *o = @"".mutableCopy;

    peopleEnum = [people objectEnumerator];
    
    while((person = [peopleEnum nextObject]) != nil) {
        
        if ( !only_birthdays || [person valueForProperty:kABBirthdayProperty] != nil ) {
      
          formatEnumerator = [formatters objectEnumerator];
          while((formatter = [formatEnumerator nextObject]) != nil) {

              [o appendString:[NSString.alloc initWithFormat:formatter.printfToken, [[formatter valueForPerson: person] UTF8String]]];
//            printf([[formatter printfToken] UTF8String],
//                   [[formatter valueForPerson: person] UTF8String]);
          }
//          printf("\n");
        }
    }
  return o;
}

/*
  Prints people using the given format string.  Here's an example
  format string: "%n %ph %pw %pm".
*/
void printPeopleWithFormat(NSArray *people, 
                           NSString *format) {
    ABPerson *person; 
    NSEnumerator *peopleEnum;
    NSEnumerator *formatEnumerator;
    FormatHelper *formatter;
    NSArray *formatters = getFormatHelpers(format);
    if ([formatters count] == 0) {
        fprintf(stderr, "error: no formatter tokens found\n");
        exit(3);
    }
    if ([people count] == 0) {
        printf("error: no one found\n");
        exit(1);
    }
    // print the header first    
    if (show_headers) {
        showHeader(formatters);
    }
    if (sort) {

        people = [people sortedArrayUsingFunction: peopleSort 
                         context: (__bridge void *)([formatters objectAtIndex: 0])];
    }
    
    peopleEnum = [people objectEnumerator];
    
    while((person = [peopleEnum nextObject]) != nil) {
        
        if ( !only_birthdays || [person valueForProperty:kABBirthdayProperty] != nil ) {
      
          formatEnumerator = [formatters objectEnumerator];
          while((formatter = [formatEnumerator nextObject]) != nil) {
            
            printf([[formatter printfToken] UTF8String],
                   [[formatter valueForPerson: person] UTF8String]);
          }
          printf("\n");
        }
    }
}
/*
  Sorts people by the FormatHelper given in the context.
*/
NSInteger peopleSort(id peep1, id peep2, void *context) {
    ABPerson *p1 = peep1;
    ABPerson *p2 = peep2;
    FormatHelper *formatter = (__bridge FormatHelper *)(context);
    NSString *n1 = [formatter valueForPerson: p1];
    NSString *n2 = [formatter valueForPerson: p2];
    return [n1 caseInsensitiveCompare: n2];
}
