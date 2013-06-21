//
//  DefinitionController.m
//  AtoZCodeFactory
//
//  Created by Alex Gray on 6/1/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import "DefinitionController.h"
#import "AZFactoryView.h"

@implementation ObjCFile
																	#pragma mark - Conveniences
- (NSData*) data  			{  return [NSKeyedArchiver archivedDataWithRootObject:self]; }
-    (NSD*) fileInfo 		{ 		NSError *e = nil; 	

	NSDictionary *info = [FM attributesOfItemAtPath:self.URL.path error:&e]; 
	return (e) ? NSLog(@"error reading file info!"), (NSDictionary*)nil : info; 
}
-    (BOOL) fileExists		{ return [FM fileExistsAtPath:self.URL.path]; }
-    (NSN*) fileModified 	{	 return @(self.fileInfo.fileModificationDate.timeIntervalSinceReferenceDate); }
																	#pragma mark - Initializers
-   (id) initWithCoder:	     (NSCoder*)c	{

	return (self = super.init) ? 	[self setURL:		 [c decodeObjectForKey:		  @"URL"]],
											[self setSavedDate:[c decodeObjectForKey:@"savedDate"]], self : nil;
}
- (void) encodeWithCoder:    (NSCoder*)c	{	[c encodeObject:_URL 			 forKey:      @"URL"];
															[c encodeObject:self.savedDate forKey:@"savedDate"]; }
-   (id) copyWithZone:	      (NSZone*)z 	{	id copy;

	return copy = [[self.class allocWithZone:z]init] ? [copy setURL:self.URL],[copy setSavedDate:self.savedDate], copy : nil;
}
+ (instancetype) fileWithData:(NSData*)d	{  return [NSKeyedUnarchiver unarchiveObjectWithData:d] ?: nil; }
+ (instancetype) fileWithPath:   (NSS*)p 	{ id n; return (n = self.class.new) ? [n setURL:[NSURL URLWithString:p]], [n setSavedDate:n], n : nil; 	}


- (void) setSavedDate:(id)s	{  _savedDate = !s ? nil : s == self ? self.fileModified : s; }
- (BOOL) outdated 				{ return  !(self.savedDate)  ?:	![self.fileModified isEqualToNumber:self.savedDate]; }
@end

@implementation  DefinitionController 
@synthesize pList = _pList, generatedHeader = _generatedHeader;

- (void) awakeFromNib 			{ 	[self.window makeKeyAndOrderFront:nil]; }
//- (id) init { if (!(self=super.init))return self;  _atozobjc = AtoZObjC.new; return self; }

- (AZNodeProtocolKeyPaths) keyPaths { return AZNodeProtocolKeyPathsMake(@"key", @"value", @"children"); }
- (void) addChild:(id<AtoZNodeProtocol>)c
{
	[self.root addChild:c];
}
- (NSA*)  children 				{ return self.root.children; } 
-     (id) key 					{ return @"Expansions";} 
-     (id) value 					{ return nil; }
-   (NSD*) plistData				{ 

	return _plistData = _plistData ?: ^{  /* parse the plist */		NSError *e = nil;	NSPropertyListFormat fmt;	NSData *data;	
		return !self.pList.fileExists 													?	NSLog(@"Plist URL is wrong! (%@)",self.pList.URL),  (id) nil:
				 !(data = [NSData dataWithContentsOfFile:self.pList.URL.path]) ?	NSLog(@"could not make data from plist"), 			 (id) nil:
		[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&fmt error:&e] ?: nil; }();
}	
-   (AZN*) root 					{ return _root = _root ?: ^{ 	_root = AZN.new; __block AZNode *cat, *def;

//	_allKeywords = NSMA.new; _allReplacements = NSMA.new; _allCats = NSMA.new;
	return [self.plistData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		cat = AZNode.new;
		NSLog(@"Added category:%@ class:%@", cat.key = key, NSStringFromClass([key class]));
//		[@[_allCats,
		[_root addChild:cat];
		//] makeObjectsPerformSelector:@selector(addObject:) withObject:cat];
		[obj enumerateKeysAndObjectsUsingBlock: ^(NSS *macro,NSS *expansion, BOOL*s){ 
			[cat addChild:def 		  = AZNode.new]; 
//			[_allKeywords 		addObject:
			def.key   = 	   macro;
//			[_allReplacements addObject:
			def.value =  expansion;	
		}];//	if (cat.children.count) { if (_searchField.stringValue) cat.expanded = @YES; [_root.children addObject:cat]; }
	}], _root; // <--- returns node
	}();
}
-   (NSS*) generatedHeaderStr	{  // this "MAKES" the header

	__block NSString *define, *definition; __block NSUInteger pad, longest; __block NSMutableArray *keys;
	__block NSMutableString *definer = @"#import <QuartzCore/QuartzCore.h>\n".mutableCopy;  // put some other crap here ??
	[self.children enumerateObjectsUsingBlock:^(AZNode* category,NSUInteger idx,BOOL *stop) {
		[definer appendFormat:@"\n#pragma mark - %@\n\n", category.key];   // pragma section per "category"
		// figure out the longest member for pretty psacing.
		[keys = [[category.children valueForKeyPath:@"key"]mutableCopy] sortUsingComparator:^NSComparisonResult(NSString *s1, NSString *s2) {
			return 	s1.length < s2.length ? (NSComparisonResult) NSOrderedDescending :
						s1.length > s2.length ? (NSComparisonResult) NSOrderedAscending  : (NSComparisonResult)NSOrderedSame;
		}];
		longest = [keys[0] length];
		[category.children enumerateObjectsUsingBlock:^(AZNode *defineNode, NSUInteger idx, BOOL *stop) {
			if (!defineNode.key || [defineNode.key isEqualToString:@"Inactive"]) return; else definition = defineNode.key;
			pad 		= MAX(8, (NSInteger)(longest - definition.length + 8));
//			NSLog(@"def: %@  pad: %lu",definition, pad);  //  log ALL entries?
			define	= [@"#define" stringByPaddingToLength:pad withString:@" " startingAtIndex:0];
			[definer appendString:[define stringByAppendingFormat:@"%@ %@\n", definition, defineNode.value ?: @""]];
		}];
	}];		
	return definer;
}
-   (NSW*) window					{   return _window = _window ?: ^{

		_window = [NSWindow.alloc initWithContentRect:(NSRect){0,0,200,[NSScreen.mainScreen frame].size.height} styleMask:0|1|2|8 backing:2 defer:YES];
		[_window setContentView:self.view = [AZFactoryView.alloc initWithFrame:_window.contentRect controller:self]];
	//	[self bind:@"matched" toObject:self withKeyPath:@"allKeywords.@count" options:@{NSContinuouslyUpdatesValueBindingOption:@YES}]; 
		_window.level 		= NSNormalWindowLevel;
		NSLog(@"bundle:    %@", [[NSBundle mainBundle] bundleIdentifier]);
		return _window; 
	}();
}

- (ObjCFile*) pList 							{  return _pList = _pList ?: ^{

		if ([UDEFS objectForKey:@"pList"]) _pList = [ObjCFile fileWithData:[UDEFS objectForKey:@"pList"]];
		if (_pList && [_pList ISKINDA:ObjCFile.class]) return _pList;
		else return  _pList = [ObjCFile fileWithPath:@"/sd/AtoZ.framework/AtoZMacroDefines.plist"];
	}();
}		// Searches /makes from UDefs or makes ObjCFile from hardcoded path.
- (void) setPList:(id)p					{  

	_pList = [p isKindOfClass:NSPathControl.class] ? [ObjCFile fileWithPath:[p URL].path] : [p isKindOfClass:ObjCFile.class] ? p : _pList;  
	if (_pList!=nil && _pList.fileExists && self.plistData!=nil) {
		[NSUserDefaults.standardUserDefaults setObject:_pList.data forKey:@"plist"]; NSLog(@"New plist Path: %@", _pList.URL.path);
	} else NSLog(@"Problem setting PLIST");
}   	// Accepts ObjCFile or NSPathControl.  // Sets ObjCFile to Udef "pList"
- (ObjCFile*) generatedHeader 				{	return _generatedHeader = _generatedHeader ?: [NSUserDefaults.standardUserDefaults objectForKey:@"generatedHeader"] ?: 
																									 [ObjCFile fileWithPath:@"/sd/AtoZ.framework/AtoZMacroDefines.h"]; 	
}		// Searches /makes from UDefs or makes ObjCFile from hardcoded path.
- (void) setGeneratedHeader:(id)g	{ 	

	_generatedHeader = [g isKindOfClass:NSPathControl.class] ? [ObjCFile fileWithPath:[[[g URL]path] stringByAppendingPathComponent:@"AtoZMacroDefines.h"]] 
						  : [g isKindOfClass:ObjCFile.class] ? g : _generatedHeader;  
	_generatedHeader && _generatedHeader.fileExists ?
	[NSUserDefaults.standardUserDefaults setObject:_generatedHeader forKey:@"generatedHeader"], 
	NSLog(@"New _generatedHeaderURL Path: %@", _generatedHeader) : NSLog(@"Problem setting _generatedHeaderURL");
}   	// Accepts ObjCFile or NSPathControl
- (void)    			pathControl: (NSPathControl*)p 
				willDisplayOpenPanel:   (NSOpenPanel*)o 	{ [o setCanChooseDirectories:YES],	[o setCanChooseFiles:NO], [o setCanCreateDirectories:YES];	}
- (NSA*)  				    control:     (NSControl*)c 
							   textView:    (NSTextView*)v 
						   completions:           (NSA*)w
				 forPartialWordRange:        (NSRange)r 
				 indexOfSelectedItem:     (NSInteger*)i	{
	
	NSLog(@"annoying method called");
	//	Use this method to override NSFieldEditor's default matches (which is a much bigger	list of keywords).  
	NSString *partial 		= [_view.searchField.stringValue substringWithRange:r];
//	NSAssert(self.allKeywords.count == self.allReplacements.count, @"all keywords should match count of replacements?");
//   NSArray *keywords 		= [self.allKeywords arrayByAddingObjectsFromArray:self.allReplacements];
   __block NSMutableArray *matches = NSMutableArray.new;
    // find any match in our keyword array against what was typed -
//   [keywords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { NSLog(@"enumerating class: %@", NSStringFromClass([obj class])); if (![obj isKindOfClass:[NSString class]]) return;
//		[obj rangeOfString:partial options:NSAnchoredSearch|NSCaseInsensitiveSearch range:NSMakeRange(0,[obj length] )].location != NSNotFound ? [matches addObject:obj] : nil;
//	}];
	[matches sortUsingSelector:@selector(compare:)];
   return matches;
}
-   (void) controlTextDidChange:			   (NSNOT*)n	{ 	

	static BOOL isCompleting; NSLog(@"%@", n.userInfo); static NSString *last = nil; 
	if (!isCompleting && [[(NSTextView*)n.userInfo[@"NSFieldEditor"]  string]length] > last.length) { isCompleting = YES; [n.userInfo[@"NSFieldEditor"] complete:nil]; isCompleting = NO; }
	last = _view.searchField.stringValue;
}
-   (void) applicationWillFinishLaunching:(NSNOT*)n	{ if (!self.window.isVisible) [self.window makeKeyAndOrderFront:self];	}
- 	 (void) applicationDidFinishLaunchng:  (NSNOT*)n 	{

//	[UDEFS registerDefaults:@{@"plistOutdated":@YES,@"headerExists":@NO,@"newBuild":@YES}];
	//@"generatedHeaderURL":[NSURL URLWithString:@"/sd/AtoZ.framework/AtoZMacroDefines.h"]}];
//   NSLog(@"udefs says:%@", [[NSUserDefaultsController sharedUserDefaultsController] URLForKey:@"generatedHeaderURL"]);
//	[UDEFSCTL bind:@"values.plistOutdated" toObject:self.pList withKeyPath:@"outdated" options:@{CONTINUOUS}];
//	[self bind:@"headerExists"  toObject:UDEFSCTL withKeyPath:@"values.headerExists"  options:@{CONTINUOUS}];
//	[self bind:@"newBuild"      toObject:UDEFSCTL withKeyPath:@"values.newBuild"		 options:@{CONTINUOUS}];
//	[UDEFS synchronize];
}  // Nothing
-   (void) search:								  	 (id)s	{	static NSString *lastSearch = nil; 
	
	if (![lastSearch isEqualToString:[s stringValue]]) { 
//		[self root];  [_view.nodeView reloadData]; [_view.nodeView expandItem:nil expandChildren:YES]; lastSearch = [sender stringValue]; 
	}
}

-   (BOOL) saveGeneratedHeader {
	
	if (!self.generatedHeader.outdated) return NO;   NSError *e;
	NSLog(@"Just Procesing %ld \"Child\" Hedaers to %@!",self.root.numberOfChildren, self.generatedHeader.URL.path);
	return  [self.generatedHeaderStr writeToFile:self.generatedHeader.URL.path atomically:YES encoding:NSUTF8StringEncoding error:&e]
	
	? 	[UDEFS setObject:_generatedHeader.fileModified forKey:@"headerSaved"],
		[UDEFS setObject:self.generatedHeader.URL.path forKey:@"generatedHeaderPath"],
		[UDEFS synchronize] : NSLog(@"FAILED saving generated Header! error:%@", e), NSBeep(), NO;
// playSound();playChirp() 	NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.AppKit"] pathForResource:@"Tock" ofType:@"aiff"];	SystemSoundID soundID; AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID); AudioServicesPlaySystemSound(soundID);		AudioServicesDisposeSystemSoundID(soundID);
}
- 	 (BOOL) newBuild {	// check if this is a new build of this tool

	NSError *e;
	NSD               *toolInfo = [FM attributesOfItemAtPath:PINFO.arguments[0] error:&e];
	NSDate        *toolModified = toolInfo.fileModificationDate;
	NSTimeInterval sinceToolMod = toolModified.timeIntervalSinceReferenceDate;
 	NSTimeInterval savedToolMod = [UDEFS doubleForKey:@"savedToolMod"];
	return ( (e) || savedToolMod != savedToolMod || savedToolMod == 0) ?   // ? timeIntString(sinceToolMod - savedToolMod) : nil;
				NSLog(@"the tool %@ has been rebuilt since last use.\n %@",PINFO.arguments[0], toolModified),
				[UDEFS setDouble:sinceToolMod forKey:@"savedToolMod"], [UDEFS synchronize], YES : NO;	
}
@end
/*
NSString*(^timeIntString)(NSTimeInterval) = ^(NSTimeInterval time) { 	
	return [NSString stringWithFormat:@"%02li:%02li:%02li", 
			lround(floor(time / 3600.)) % 100, lround(floor(time / 60.)) % 60, lround(floor(time)) % 60]; 
};


-   (NSD*) filteredRoot			{  // builds root, and matches searches simultaneously 
	_matched = 0; 
	NSS* w = [_view.searchField.stringValue isEqualToString:@""] ? nil : w; 
	if (w && (macro || expansion)) / * if we have a search string, and either macro, or expansion exists.. parse * /
			if ([macro rangeOfString:w].location == NSNotFound && [expansion rangeOfString:w].location == NSNotFound) return; / *not found, don't add * /
			self.matched = _matched+1;
return  NSDictionary.new;
}
	NSLog(@"%@ no change: plistMod:%f savedMod:%f\ntool UNCHANGED toolModSaved:%f  currentMod:%f", 
	PINFO.arguments[0], sincePlistMod, savedPlistMod, savedToolMod, sinceToolMod), NO;
 v.plistURL, timeIntString(sinceToolMod),timeIntString(savedPlistMod)); 
	NSDateFormatter f = NSDateFormatter.new;f.formatterBehavior= NSDateFormatterBehavior10_4;f.dateFormat= @"dd/MM HH:mm:ss:SSS";
	NSString			 *plistDateString = [f stringFromDate:plistModified], *toolDateStringBOOL needsit = NO; 		 needsit = (toolTime != lastRunDate);
+ (void)initialize {
 Register the dictionary of defaults
    NSLog(@"registered defaults:%d", [UDEFSCTL boolForKey:@"values.plistOutdated"]);
*/
