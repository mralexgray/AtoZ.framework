@import AppKit;
#import <AtoZ/AtoZ.h>
//#import "AZBeetlejuice.h"

@interface Contacts: BaseModel <NSCoding>
@property NSS *firstName, *lastName, *streetAddress, *zipCode, *email, *phoneNumber, *notes;
@end
@implementation Contacts
-(void) print											{
	NSLog (@"%@ %@", _firstName, _lastName);
	NSLog (@"%@, %@", _streetAddress, _zipCode);
	NSLog (@"%@, %@", _email, _phoneNumber);
	NSLog (@"%@\n\n", _notes);
}
//-(void) encodeWithCoder:(NSCDR*)e	{
//
//	[e encodeObject:firstName forKey:@"ContactFirstName"];
//	[encoder encodeObject:lastName forKey:@"ContactLastName"];
//	[encoder encodeObject:streetAddress forKey:@"ContactStreetAddress"];
//	[encoder encodeObject:zipCode forKey:@"ContactZipCode"];
//	[encoder encodeObject:email forKey:@"ContactEmail"];
//	[encoder encodeObject:phoneNumber forKey:@"ContactPhoneNumber"];
//	[encoder encodeObject:notes forKey:@"ContactNotes"];
//}
//-  (id) initWithCoder: (NSCoder *) decoder	{
//	firstName = [decoder decodeObjectForKey:@"ContactFirstName"];
//	lastName = [decoder decodeObjectForKey:@"ContactLastName"];
//	streetAddress = [decoder decodeObjectForKey:@"ContactStreetAddress"];
//	zipCode = [decoder decodeObjectForKey:@"ContactZipCode"];
//	email = [decoder decodeObjectForKey:@"ContactEmail"];
//	phoneNumber = [decoder decodeObjectForKey:@"ContactPhoneNumber"];
//	notes = [decoder decodeObjectForKey:@"ContactNotes"];
//	return self;
//}
@end


@interface ContactList: NSObject <NSCoding>
@property (strong,nonatomic) NSMutableArray *list;
@property (readonly) NSArray *frameworks;
-  (id) init;
-(void) addContact;
-(void) printContact:(NSString*)c type:(NSString*)value;
-(void) printAll;
-(void) loadContacts;
-(void) saveContacts;
-  (id) promptWithArray:(NSArray*)a;
-(void) loadBundles;
-(void) loadAZ;
@end

typedef void (^menuWithContacts)(ContactList*);
menuWithContacts contactMenu = ^(ContactList *contacts)			{

//	AZBeetlejuiceLoadAtoZ();
//	__block BOOL exit = NO;
	__block NSString *temp;
	
	XX(@"\nWelcome to the Contact List App \nPlease choose from the following options: \n");

	NSD *o =
   @{ @" to Add a Contact"						  : ^{ [contacts addContact]; },
      @" to Print a Full List"				  : ^{ 	[contacts printAll];  },
      @" to Search for a Last Name"			: ^{

        printf ("%s","Enter Last Name: ");  char cTemp[80];
        scanf("%s",(char*) &cTemp);
        temp = [NSString stringWithCString: cTemp encoding: NSASCIIStringEncoding];
        [contacts printContact: @"last" type:temp];
      },
      @" to Search for an Email"				: ^{

        fprintf ( stderr, "%s","Enter Email: ");char cTemp[80];
        scanf("%s",(char*) &cTemp);
        temp = [NSString stringWithCString: cTemp encoding: NSASCIIStringEncoding];
        [contacts printContact: @"email"type:temp];
      },
      @" to Search for a Zip Code"			: ^{
        fprintf ( stderr, "%s","Enter Zip Code: ");char cTemp[80];
        scanf("%s", (char*)&cTemp);
        temp = [NSString stringWithCString: cTemp encoding: NSASCIIStringEncoding];
        [contacts printContact: @"zip" type: temp];
        temp = @"";																			},
      @" to Save & Exit"						: ^{	[contacts saveContacts]; 	},
      @" to Load Frameworks"   			 	: ^{	[contacts loadBundles]; 	},
      @" To Load AZ"								: ^{	/*AZBeetlejuiceLoadAtoZ();*/	},//[contacts loadAZ]; 			},
      @" To print AtoZ Methods" 				: ^{  
      [contacts performSelector:@selector(promptWithArray:)
        withObject:[CPROXY(AtoZ) performSelectorWithoutWarnings:NSSelectorFromString(@"instanceMethods")]]; }};

	void (^mapBlock)(void) = [o valueForKey:[contacts performSelector:@selector(promptWithArray:) withObject:o.allKeys]];
	if (mapBlock) mapBlock();
	
//		scanf("%i", &option); 	while( option < 1 || option > 8 ); {
//	exit ? nil : ^{
		double delayInSeconds = 2.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			contactMenu(contacts);
		});
//	}();
};


//#define PROMPT(X,VAR) NSS*VAR; NSLog(@#X,
@implementation ContactList
- (id)init																		{

	if (!(self = super.init)) return nil;	_list = NSMutableArray.new;	return self;
}
-(void) addContact															{

	NSLog(@"List Count is: %ld", _list.count);
	Contacts *contactTemp = Contacts.new;
	char cFName[80], cLName[80], cSAddress[80], cZCode[80], cEmail[80], cPNumber[80], cNotes[80];
	NSString *fName, *lName, *sAddress, *zCode, *mail, *pNumber, *memo;

	NSLog(@"Enter First Name: ");		scanf("%s",(char*) &cFName);
	NSLog(@"Enter Last Name: ");		scanf("%s", (char*)&cLName);
	NSLog(@"Enter Street Address: ");scanf("%s",(char*) &cSAddress);
	NSLog(@"Enter Zip Code: ");		scanf("%s",(char*) &cZCode);
	NSLog(@"Enter Email: ");			scanf("%s", (char*)&cEmail);
	NSLog(@"Enter Phone Number: ");	scanf("%s", (char*)&cPNumber);
	NSLog(@"Enter Notes: ");			scanf("%s", (char*)&cNotes);

	fName = [NSString stringWithCString:cFName encoding: NSASCIIStringEncoding];
	lName = [NSString stringWithCString:cLName encoding: NSASCIIStringEncoding];
	sAddress = [NSString stringWithCString: cSAddress encoding: NSASCIIStringEncoding];
	zCode = [NSString stringWithCString: cZCode encoding: NSASCIIStringEncoding];
	mail = [NSString stringWithCString: cEmail encoding: NSASCIIStringEncoding];
	pNumber = [NSString stringWithCString: cPNumber encoding: NSASCIIStringEncoding];
	memo = [NSString stringWithCString: cNotes encoding: NSASCIIStringEncoding];

	[contactTemp setFirstName: fName];
	[contactTemp setLastName: lName];
	[contactTemp setStreetAddress: sAddress];
	[contactTemp setZipCode: zCode];
	[contactTemp setEmail: mail];
	[contactTemp setPhoneNumber: pNumber];
	[contactTemp setNotes: memo];
	[_list addObject:contactTemp];

	NSLog(@"List Count is: %ld", _list.count);
}
-(void) printContact: (NSString *)type type:(NSString *)value	{
	int i;
	NSString * cmpStr;
	for( i = 0; i < [_list count]; i++ )
	{
		Contacts *contactTemp = Contacts.new;
		contactTemp = [_list objectAtIndex: i];

		if( [type isEqualToString:@"last"] )
		{
			cmpStr = [contactTemp lastName];
			if( [cmpStr caseInsensitiveCompare: value] == NSOrderedSame )
			{
				[contactTemp print];
			}
		} else if([type  isEqualToString: @"email"] )
		{
			cmpStr = [contactTemp email];
			if( [cmpStr caseInsensitiveCompare: value] == NSOrderedSame )
			{
				[contactTemp print];
			}
		} else if( [type  isEqualToString:@"zip"] )
		{
			cmpStr = [contactTemp zipCode];
			if( [cmpStr caseInsensitiveCompare: value] == NSOrderedSame )
			{
				[contactTemp print];
			}
		}
	}
}
-(void) printAll																{	[_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {	[(Contacts *)obj print];  }]; }
-(void) encodeWithCoder: (NSCoder *) encoder							{	[encoder encodeObject:_list forKey:@"ContactListList"];	}
-(id) initWithCoder: (NSCoder *) decoder								{	_list = [decoder decodeObjectForKey:@"ContactListList"];	return self;}
-(void) loadContacts															{	if( [[NSFileManager defaultManager] fileExistsAtPath:@"contactList.dat"] )
																						_list = [NSKeyedUnarchiver unarchiveObjectWithFile:@"contactList.dat"];
}
-(void) saveContacts															{	if( [NSKeyedArchiver archiveRootObject:_list toFile:@"contactList.dat"] == NO) NSLog(@"Archiving Failed");
}

- (NSArray*) frameworks						{ return @[@"AtoZAppKit.framework", @"BWTK.framework", @"Zangetsu.framework", @"Rebel.framework", @"PhFacebook.framework", @"MapKit.framework", @"KSHTMLWriter.framework", @"FunSize.framework", @"CocoaPuffs.framework", @"AtoZBezierPath.framework", @"TwUI.framework", @"SVGKit.framework", @"NoodleKit.framework", @"MenuApp.framework", @"Lumberjack.framework", @"DrawKit.framework", @"CocoatechCore.framework", @"BlocksKit.framework" ];	}
- (NSString*) basePath 						{ return @"/Library/Frameworks/AtoZ.framework/Versions/A/Frameworks";	}
- (NSString*) clr:(NSString*)s 			{

//	BOOL inTTY =  [@(isatty(STDERR_FILENO))boolValue];
//	if (inTTY) return s;
	NSArray* cs = @[@31,@32,@33,@34,@35,@36,@37];
	NSArray* bg = @[@40];//,@41,@42,@43,@44,@45,@46,@47];

	NSNumber* num = cs[arc4random() % 7 ];
	NSNumber* nub = bg[arc4random() % 1 ];
	NSString *let = [num stringValue];
	NSString *blet = [nub stringValue];

	return [NSString stringWithFormat:@"\033[%@;%@m%@\033[0m - %@", let,blet, s, num];
}

- (void) loadBundles 						{

	id a = [self performSelector:@selector(promptWithArray:) withObject:self.frameworks];
	NSString* path = [self.basePath stringByAppendingPathComponent:a];
	NSBundle *b = [NSBundle bundleWithPath:  path];
	NSError *e = nil;
	fprintf ( stderr, "Preflighting path: %s\n", path.UTF8String);
	BOOL okdok = [b preflightAndReturnError:&e];
	if (okdok) {
		[b load];
//		fprintf ( stderr, "%s\n%s\n", [self clr:a].UTF8String, [self clr:b.description].UTF8String);
	}
	else fprintf ( stderr, "Error loading %s: %s\n", path.UTF8String, [e debugDescription].UTF8String);
	//		Class atoz = NSClassFromString(@"AtoZ");
	//		id obj = [atoz sharedInstance];
//	NSLog(@"%@ %@  %@  %@",[self clr:a], [self clr:b], [self clr:NSStringFromClass(c)], [self clr:[b bundleIdentifier]] );
}
- (id) promptWithArray:(NSA*)a 		{

//	XX(@"What would you like to do?");
//	fprintf ( stderr, "%s","What would you like to do? \n");
//	int option = 0;/
//	[a sV:GRAY2 fKP:@"logBackground"];
//  /  each:^(id obj) {
     // [obj setValue:GRAY2 forKey:];
//		NSS* printer = [NSString stringWithFormat:@"%@ : %@",@(idx), obj];
//		NSPRINT(printer);// withString:[[CPROXY(CPROXY(AZLog) valueForKey:@"sharedInstance" ] colorizeString:obj withColor:RANDOMCOLOR]]);
//			NSString *Uugh = [NSString stringWithFormat:@"%i %@", (int)(idx + 1), [self clr:obj], nil];
//		NSPRINT(Uugh);
//		[CPROXY(AZLog) performSelector:NSSelectorFromString(@"colorizeString:withColor:") withObject:[NSString stringWithFormat:@"%i %@", (int)(idx + 1), [self clr:obj]] NSColor.orangeColor, nil)[0]clr]);
//		fprintf ( stderr, "%d %s\n", (int)(idx + 1), [self clr:obj].UTF8String);
//	}];
//	do {
//		option = (int)[CPROXY(NSTerminal) performSelectorWithoutWarnings:$SEL(@"readInt")];
//		NSPRINT(@(option).stringValue);//[NSString stringWithFormat:@"%i", option, nil]);
//	} while ( ! NSRangeContainsIndex(NSMakeRange(0,a.count),option));//option = 0 && option < a.count + 1);
//		if (!inRange)  {  fprintf(stderr,"%s", "not valid, try again..\n"); fflush(stdin); }
//	}	while(!inRange);
//	return a[option -1];			//char cTemp[80];NSString *temp;
}
@end

static ContactList *contacts;
int main( int argc, const char *argv[] )	{	@autoreleasepool {

  AZSHAREDAPP;
  [contacts = ContactList.new loadContacts];
  contactMenu(contacts);
//  NSW* windy = NSWINDOWINIT(AZScreenFrameUnderMenu(),NSNotFound);
//  LOGCOLORS(windy,nil);
//	windy.bgC= RED;
//	[windy makeKeyAndOrderFront:nil];
   AZAPPRUN;
	}
	return 0;
}
