
#import "Project.h"

@implementation Project

//- (NSMutableArray*) nodeChildren { return  nil; }
//- (id) nodeKey { return  self.projectFilename; 	}
//- (id) nodeValue { return  self.exitStatus; 		}
//+     (NSArray*) uncodableKeys									{  return @[@"stdOutDelegate"]; }
-   		 (void) save 												{ [HRCoder  archiveRootObject:self toFile:self.saveFile]; }
-         (NSS*) projectFolder									{ return  self.projectPath.stringByDeletingLastPathComponent; 							}
-         (NSS*) projectFilename									{ return  self.projectPath.lastPathComponent.stringByDeletingPathExtension; 		}
+ (instancetype) instanceWithProjectPath:(NSString*)path { 	

		NSLog(@"%@", [[[self superclass]superclass] codableKeys]);	
		Project *x = [self.alloc init];
		x.projectPath 	= path;	
		x.executable 	= @"/usr/bin/xcodebuild";
		x.launchPath 	= x.projectFolder;
		x.args			= @"CODE_SIGN_IDENTITY='' CODE_SIGNING_REQUIRED=NO -sdk macosx10.8";
		return x;	
}
@end

@implementation 			ProjectArchive
#pragma mark NSOutlineView delegate methods
//- (NSMutableArray*) nodeChildren { return  _projects.children; }
//- (id) nodeKey { return  @"archives"; }
//- (id) nodeValue { return  nil; }

-             (id) outlineView:(NSOutlineView*)v
	  objectValueForTableColumn:(NSTableColumn*)c 							 byItem:(id)x	{	
		NSLog(@"inquiry: %@  %@", NSStringFromSelector(_cmd), x);
	return [c.identifier isEqualToString:@"projects"] ? [_projects valueForKeyOrKeyPath:x] : nil;
	//allKeys.count : nil// : ((AZNode*)x).value:((AZNode*)x).key;
}
- 				(BOOL) outlineView:(NSOutlineView*)v 			 		  isGroupItem:(id)x 	{ return !(x); }
-           (BOOL) outlineView:(NSOutlineView*)v 		      isItemExpandable:(id)x	{ return !(x); }
//	id cfkp = [_items valueForKeyOrKeyPath:@"project.projectFilename"];
//	BOOL isit = [cfkp containsObject:x]; 
//	NSLog(@"isitem expandable..:%@  item is %@ class:%@   cfkp: %@ ",isit?@"YES":@"NO", x, NSStringFromClass([x class]), cfkp);

-      (NSInteger) outlineView:(NSOutlineView*)v      numberOfChildrenOfItem:(id)x	{ NSInteger ct = !x ? 1 : [(AZNODEPRO x).children count];	
																																				  return NSLog(@"Item: %@ children ct: %ld", x, ct),ct;
}
- 			     (id) outlineView:(NSOutlineView*)v child:(NSInteger)idx ofItem:(id)x	{	return !x ? self.projects : self.projects[idx];
//_items : _items[idx]; //root : [x children][idx];	
}  
// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -   
+ (void) addProject:(Project*)object 	{
 	if ( !object || [[self.sharedInstance projects] containsObject:object]) return;
	[[[self sharedInstance] projects] addObject:object];
	// );// forKey:object.projectFilename];
//	[[[self.class sharedInstance] archives] addObject:object.saveFile];
//	NSLog(@"added savePath: %@", saveP);
//	[(ProjectArchive*)self.sharedInstance save];
}
+ (NSS*) saveFile 							{

	//get the path to the application support folder
	__block NSString *folder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED		//append application name on Mac OS
	folder = [folder stringByAppendingPathComponent:[AZAPPBUNDLE bundleIdentifier]];
#endif
		//create the folder if it doesn't exist
		NSS*savefile = [[folder withPath:AZCLSSTR]withExt:@"plist"];
	return [AZFILEMANAGER fileExistsAtPath:folder] ? savefile : ^{ return 
				[AZFILEMANAGER createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL], savefile; }();
}
+ (void) save 									{ [[[self sharedInstance]projects] writeToFile:self.saveFile atomically:YES]; }
#pragma mark - SINGLETON PATTERN
static id _sharedSingleton		= nil;
- (id) init 			 						{	if (!(self = super.init)) return nil;	
_projects = AZNode.new;
//_projects.children = // [AZFILEMANAGER fileExistsAtPath:self.class.saveFile] ? [NSMD dictionaryWithContentsOfFile:self.class.saveFile] : NSMD.new;	_ac = [NSArrayController new];
//		_items =
// @[@{@"project"		:  @{@"projectFilename": @"whatecver", @"projectFolder":@"whatveerrrrrrr"} }].mutableCopy;
// 
//										@"children"	: @[@{@"title":@"Campaign"},@{@"title":@"Reaction"}],
//						@"header"   : @YES}].mutableCopy;
    
//	_tc = [NSTreeController new];
//	[_tc bind:@"content" toObject:@"self" withKeyPathUsingDefaults:@"items"];

//	[_ac bind:@"content" toObject:_items withKeyPath:<#(NSString *)#> nilValue:<#(id)#>]
return self; }
+ (instancetype) sharedInstance 			{
	
	// return before any locking .. should perform better
	if (_sharedSingleton) return _sharedSingleton;
	// THREAD SAFTEY
	@synchronized(self) { if (	!	_sharedSingleton) _sharedSingleton		= self.new;	}
	return _sharedSingleton;
}
+ (id) alloc 			 						{	NSAssert(_sharedSingleton == nil, @"Attempted to allocate a 2nd instance of a singleton."); return super.alloc; }
@end


/*

// [(AZNode*)x value] == nil; }
// YES;
// !x ?   : [[x children]count];	}

- (NSView *) outlineView:(NSOutlineView *)outlineView
                    viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    BOOL isHeader = [[[item representedObject] objectForKey:@"header"] boolValue];
    return [outlineView makeViewWithIdentifier:(isHeader ? @"HeaderCell" : @"DataCell")
                                         owner:self];
}

- (BOOL) outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [[item representedObject][@"header"] boolValue];
}

- (BOOL) outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return ![[item representedObject][@"header"] boolValue];
}

//+ (void) print:	 (NSS*)name 								{
//
//	Project *item = [ProjectArchive.sharedInstance get:name];
//	[item log];
//}
// INTERNALS
//- (Project*) get:(NSS*)name {	return  name ? (AZStopwatchItem *)items[name] : nil;	}
//- (void) remove:(NSS*)name 	  		{		if ( ! name) return; 	[items removeObjectForKey:name];	}
//- (void) add:   (NSS*)name 	 		{ if ( ! name) return; [self remove:name]; items[name] = [AZStopwatchItem named:name]; }
*/

 
//+ (instancetype) sharedInstance { 
////	
//	if ([self hasSharedInstance]) return [self sharedInstance];
////	ProjectArchive *o;
//	BOOL exists =  [NSFileManager.defaultManager fileExistsAtPath:self.saveSharedFile];
//	return exists ? [HRCoder objectWithContentsOfFile:self.saveSharedFile] : 
//		[[self alloc]init];
//}
//+ (void) save { [HRCoder archiveRootObject:self.sharedInstance toFile:self.saveSharedFile]; }
//
////+ (NSS*) resourceFile { return self.saveSharedFile; }
//
//- (NSMA*)archives { return _archives = _archives ?:NSMutableArray.new; }
////  NSLog(@"%ld objects in archiove", _archives.count); }
//
////- (id) initWithContentsOfFile:(NSString *)path
//



//- (BOOL) convertToXML { return YES; }
	
//	NSString* s = 	[[[[self.class saveFile]stringByDeletingLastPathComponent]withString:self.uniqueID]withExt:@"plist"];
//	[self writeToFile:s atomically:YES];
//	[self save];
	
//+ (NSArray*) codableKeys {
//
//	NSMutableArray *keys = NSMutableArray.new;
//	Class k = self;
////	while (k!= NSObject.class) { NSLog(@"super:%@", NSStringFromClass(k)); k = [k superclass]; }
//	while (k!= BaseModel.class) { NSLog(@"super:%@", NSStringFromClass(k));
////		NSLog(@"Adding codables:%@ from class:%@", [k codableKeys], NSStringFromClass(k));
//		[keys addObject:NSStringFromClass(k)];//addObjectsFromArray:[k codableKeys]];
//	 	k = [k superclass]; 
//	}
////	do {
////
////	 ;   k = [k superclass]; 
////	} while ( k != [NotifyingOperation class]);
//	NSLog(@"ALL codables: %@", keys);
//	return keys;
//}
