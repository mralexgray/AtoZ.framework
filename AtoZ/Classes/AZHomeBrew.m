
#import "AZHomeBrew.h"

@implementation AZBrewFormula

- (void) setUp	{	_googleGenerated 	= NO; 	_installStatus = AZNotInstalled; _info = nil; }

+ (instancetype) instanceWithName: (NSS*)name { AZBrewFormula *n =  self.instance; n.name = name;  return n; }

+(NSSet*)keyPathsForValuesAffectingFancyDesc { return NSSET(@"name", @"info", @"version"); }

- (void) setInfo:(NSString *)info
{
	NSRange range = [info rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
	 if (range.location > 0)	{
		 self.url 	= [[info componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]filterOne:^BOOL(NSS* aLine) {  return [aLine startsWith:@"http"]; }];
		 _info 	= [info substringFromIndex:(range.location + 1)];
		 self.version 	= [[info substringToIndex:range.location] componentsSeparatedByString:@" "].lastObject;
	}
//	 NSLog(@"info:%@  vers: %@", info, version);
}

- (NSAS*) fancyDesc
{
	NSLog(@"getting fancy for:%@", self.name);
	static NSS* font = @"UbuntuMono-Bold";
	return  ^{
		__block NSMAS *fancy = [NSMAS.alloc initWithAttributedString:[NSAS.alloc initWithString:self.name attributes:@{NSFontAttributeName: [AtoZ font:font size:24], NSForegroundColorAttributeName: GREEN}]]; 	// Add the name
		!self.version ?: [fancy appendAttributedString:[NSAS.alloc initWithString:$(@"\tversion: %@", self.version) attributes:@{NSFontAttributeName: [AtoZ font:font size:18], NSForegroundColorAttributeName:GRAY8}]]; 	// Add the version
		!self.desc	?: [fancy appendAttributedString:[NSAS.alloc initWithString:$(@"\nDescription: %@", self.desc) attributes:@{NSFontAttributeName: [AtoZ font:font size:18], NSForegroundColorAttributeName:BLACK}]]; 	// Add the version
		!self.desc	?: [fancy appendAttributedString:[NSAS.alloc initWithString:$(@"\nURL: %@", self.url) attributes:@{NSFontAttributeName: [AtoZ font:font size:18], NSForegroundColorAttributeName:BLACK}]]; 	// Add the version

//		!self.info	?: ^{																// Add the info
//			NSMAS *fancyInfo = [NSMAS.alloc initWithString:$(@"\n%@\n", self.info)];
//			//			__block int index = 1;  // Detect the URLs  // Skip the leading newline
//			[[self.info componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] reduce:^id  (id memo, NSS*word) {
//				//			// each:^(NSS *word) {
//				![word hasPrefix:@"http"] ?:
//				[fancyInfo addAttributes:@{			   NSFontNameAttribute: [AtoZ font:@"UbuntuMono-Bold" size:24], // NSFontSizeAttribute: @22,
//		  NSForegroundColorAttributeName: GRAY9,									// NSUnderlineStyleAttributeName: @(NSSingleUnderlineStyle),
//					 NSLinkAttributeName: word} range:NSMakeRange([memo intValue], word.length)];
//				return @( [memo intValue] + word.length + 1 );
//			} withInitialMemo:@1];
//			[fancy appendAttributedString:fancyInfo]; 		// Put in output
//		}();
		return fancy;
	}();
}

//-(NSS*) info
//{
// 	return _info = _info ?: ^{
//		NSRange range = [output rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
//		if (range.location > 0)	{
//			self.info 		= [output substringFromIndex:(range.location + 1)];
//			self.version 	= [[output substringToIndex:range.location] componentsSeparatedByString:@" "].lastObject;
//		}	}();
//
//}


@end

@implementation AZHomeBrew

@synthesize commands = _commands;

- (void) setUp {

	[$(@"Inside %@ in class %@", AZSELSTR, AZCLSSTR) log];

	_commands = @{   		  @(BrewOperationNone)	:	@"",
							 @(BrewFormulaeInstalled) 	:	@"list",
							 @(BrewFormulaeAvailable)	:	@"search",
							  @(BrewFormulaeOutdated) 	:  @"outdated",
							  @(BrewOperationInstall)	:  @"install",
							@(BrewOperationUninstall) 	: 	@"uninstall",
								@(BrewOperationUpdate)	:	@"update",
							  @(BrewOperationUpgrade)  :  @"upgrade",
								  @(BrewOperationInfo)	:	@"info",
								  @(BrewOperationDesc)	:	@"desc"			};

	_entriesToAdd 	= NSMD.new;
	_savePath 		= [NSB.applicationSupportFolder withPath:@"updatedDescriptions.plist"];
	NSS *loadPath  = [AZFILEMANAGER fileExistsAtPath:_savePath] ? _savePath : [AZFWORKBUNDLE pathForResource:@"BrewDescriptions" ofType:@"plist"];
	_reference 		= [NSD dictionaryWithContentsOfFile:loadPath];
	_shouldExit 	= NO;
	_brewPath 		= @"/usr/local/bin/brew";
	self.content   = @[self.available];//.mutableCopy;
	self.childrenKeyPath = @"mutableChildNodes";
	self.objectClass = [AZBrewFormula class];

}

- (void)updateInstalled	{

		NSA *installed = [[[CWTask.alloc initWithExecutable:_brewPath andArguments:@[_commands[@(BrewFormulaeInstalled)]] atDirectory:nil]
								  launchTask:nil] sepByString:@"\n"].sansLast;
		if (installed.count == 0) return;
		[self.available.childNodes each:^(AZBrewFormula* obj) {
			if ([installed containsObject:obj.name]) obj.installStatus = AZInstalled;
		}];
		[self updateOutdated];
}

- (void)updateOutdated
{
	NSA* args = @[_commands[@(BrewFormulaeOutdated)]];
	NSA *outNames = [[[CWTask.alloc initWithExecutable:_brewPath andArguments:args atDirectory:nil]
					  launchTask:nil] sepByString:@"\n"].sansLast;
	if (outNames.count == 0) return;
	[self.available.childNodes each:^(AZBrewFormula* obj){
		if ([outNames containsObject:obj.name]) {
			obj.installStatus = obj.installStatus == AZInstalled ? AZInstalledNeedsUpdate : AZNeedsUpdate;
		}
	}];
//	[self updateAllFormulaeInfo];
}

- (NSTN*)available
{
	[@"querying brew!" log]; NSBeep();

	return _available = _available ?: ^{		NSA* args = @[_commands[@(BrewFormulaeAvailable)]];		AZLOG(args);

		_available		 		= NSTN.new;
		__block NSTN *nodes 	= _available;
		NSS* avaiNamesOutput = [[CWTask.alloc initWithExecutable:self.brewPath andArguments:args atDirectory:nil] launchTask:nil];
		NSLog(@"availnames: %@", avaiNamesOutput);
		[[avaiNamesOutput sepByString:@"\n"].sansLast each:^(NSS*availName) {
			AZBrewFormula *f = [AZBrewFormula instanceWithName:availName];
			if (!f) return;
			if ([_reference objectForKey:availName]) f.desc = _reference[availName];
			if (f.desc == nil)
				[AZSSOQ addOperationWithBlock:^{ NSS* s; NSLog(@"foundwiki for %@   wiki:%@", f.name, s = [f.name wikiDescription]);
					if (s) f.desc = $(@"W:%@",s);
				}];
			[nodes.mutableChildNodes addObject:[NSTN treeNodeWithRepresentedObject:f]];
		}];
		NSLog(@"Updating available.  Count:%ld", _available.childNodes.count);	//		[self updateInstalled];
		return _available;
	}();
}
-(void) updateAllFormulaeInfo	{  [self.available.childNodes each:^(AZBrewFormula* obj) { [self setInfoForFormula:obj]; }]; }

-(NSS*)setInfoForFormula:(AZBrewFormula*)formula {

	[[CWTask.alloc initWithExecutable:self.brewPath
							   andArguments:@[_commands[@(BrewOperationInfo)], formula.name] atDirectory:nil]
		launchTaskOnQueue:AZSSOQ withCompletionBlock:^(NSS*outP, NSERR*e) { if (outP) formula.info = outP; }];
}
- (void)setShouldLog:(BOOL)shouldLog	{	_shouldLog = shouldLog;	NSLog(@"Should log:  %@", self.propertiesPlease); }
@end

//	static BOOL hadDesc, hadVersion;  hadDesc = hadVersion = NO;
//	static NSS* font = @"UbuntuMono-Bold";
//	NSAS *aFancyDesc  = formula.fancyDesc ?: ^{
//			//=  hadVersion == (self.version != nil)  && hadDesc == (self.desc != nil) ? _fancyDesc : ^{
//
//			__block NSMAS *fancy = [NSMAS.alloc initWithAttributedString:[NSAS.alloc initWithString:formula.name attributes:@{NSFontAttributeName: [AtoZ font: size:24], NSForegroundColorAttributeName: GREEN}]]; 	// Add the name
//
//			!self.version ?: [fancy appendAttributedString:[NSAS.alloc initWithString:$(@"\tversion: %@", self.version) attributes:@{NSFontAttributeName: [AtoZ font:font size:18], NSForegroundColorAttributeName:GRAY8}]]; 	// Add the version
//			!self.desc	?: [fancy appendAttributedString:[NSAS.alloc initWithString:$(@"\nDescription: %@", self.desc) attributes:@{NSFontAttributeName: [AtoZ font:font size:18], NSForegroundColorAttributeName:BLACK}]]; 	// Add the version
//			hadVersion	=  self.version != nil;
//			hadDesc	   =  self.desc	!= nil;
//			!self.info	?: ^{																// Add the info
//				NSMAS *fancyInfo = [NSMAS.alloc initWithString:$(@"\n%@\n", self.info)];
//				//			__block int index = 1;  // Detect the URLs  // Skip the leading newline
//				[[self.info componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] reduce:^id  (id memo, NSS*word) {
//					//			// each:^(NSS *word) {
//					![word hasPrefix:@"http"] ?:
//					[fancyInfo addAttributes:@{			   NSFontNameAttribute: [AtoZ font:@"UbuntuMono-Bold" size:24], // NSFontSizeAttribute: @22,
//			  NSForegroundColorAttributeName: GRAY9,									// NSUnderlineStyleAttributeName: @(NSSingleUnderlineStyle),
//						 NSLinkAttributeName: word} range:NSMakeRange([memo intValue], word.length)];
//					return @( [memo intValue] + word.length + 1 );
//				} withInitialMemo:@1];
//				[fancy appendAttributedString:fancyInfo]; 		// Put in output
//			}();
//			return fancy;
//		}();
//	}
//
//
//
//}


//+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
//{
//	NSSet  *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
//	return 	areSame(key, @"shouldLog") 	?	[keyPaths setByAddingObjectsFromSet:NSSET(@"avail",@"installed")] :
//	//			areSame(key, @"avail")	  	?	[keyPaths setByAddingObjectsFromSet:NSSET(@"installed", @"shouldLog")] :
//	keyPaths;
//}

