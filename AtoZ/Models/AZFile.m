#import "AZFile.h"


@implementation AZFile
@synthesize name=_name,
			image=_image,
			colors=_colors,
			hasLabel=_hasLabel,
			labelColor=_labelColor,
			labelNumber=_labelNumber,
			calulatedBundleID=_calulatedBundleID;
@synthesize hue=_hue;

-(void)didChangeValueForKey:(NSString *)key {
//	NSLog(@"Object chaged:%@   val:%@",key, self[key]);
	[key isEqualToString:@"path"] ? ^{}()
								  : NSLog(@"no action taken.");
}
-(id) init {self = self ? self : [super init]; [self addObserver:self forKeyPaths:@[@"path",@"name",@"color",@"image"]]; return self; }
-(id) initWithObject:(id)object {	self = [self init];
	[object isKindOfClass:[NSString class]] ? ^{ self.path 	= object; }() 	:
	[object isKindOfClass:[NSImage class]]  ? ^{ _image = object; }() 	:
	[object isKindOfClass:[NSColor class]]  ? ^{ _color = object; }() 	: nil;
	return self;
}
- (NSString *)itemDisplayName {
	return self.name;
}

- (NSString *)itemKind {
	return _itemKind = _itemKind ?: [_path hasSuffix:@"app"] ? @"Application" : @"Folder";
}


-(NSS*) name	{
	return _name = _name ? _name :
				   _path ? [AZFILEMANAGER displayNameAtPath:_path] :
				   _path ? [[_path lastPathComponent] stringByDeletingPathExtension] :
				  _color ? [_color nameOfColor] :
				  _image ? [_image name] : @"N/A";
}
-(NSIMG*) image {
	NSSize theSize = AZSizeFromDimension(512);
	return _image = _image ? _image
				  : [AZWORKSPACE iconForFile:_path] ? [[AZWORKSPACE iconForFile:_path]imageScaledToFitSize:theSize]
				  :	_color ? [[NSImage az_imageNamed:@"missing.png"]tintedWithColor: _color]
				  : [NSImage az_imageNamed:@"missing.png"];
}
-(NSA*) colors 	{
	return _colors = _colors ? _colors : (NSArray*)^{
		[AZStopwatch start:$(@"%@.colorquant", _name)];
		@autoreleasepool {
			NSArray *raw = [self.image quantize];
			NSBag *allBag = [NSBag bagWithObjects:raw]; // put all colors in a bag //[raw do:^(id obj) { [allBag add:obj];}];
			NSBag *rawBag = [NSBag bag];
			NSUI total = 0;
			NSArray *filtered = [raw filter:^BOOL(NSColor* aColor) {
				return [allBag occurrencesOf:aColor] > ( .0005 * [raw count]) && [aColor isExciting] ? YES : NO;
			}];
			return [[filtered map:^id(id obj) {
				return [AZColor instanceWithColor:obj count:[rawBag occurrencesOf:obj] total:filtered.count];
			}] sortedWithKey:@"count" ascending:NO];
		}
	}();
}
-(NSC*) color 	{	return _color = _color ? _color : [self.colors normal:0][@"color"]; }

- (BOOL) isRunning {
	return  ([[[[NSWorkspace sharedWorkspace] runningApplications] valueForKeyPath:@"localizedName"]containsObject:self.name] ? YES : NO);
}
//			if ( filtered.count < 2) || (exciting.count < 2 )) {
//				for ( NSColor *salvageColor in raw ) {
//					NSColor *close = [salvageColor closestNamedColor];
//					total++;
//					[rawBag add:close];
//				}
//			}
//			for ( NSColor *aColor in raw ) {
//					//get rid of any colors that account for less than 10% of total
//				if ( ( [allBag occurrencesOf:aColor] > ( .0005 * [raw count]) )) {
//
//					if ( [aColor isBoring] == NO ) { // test for borigness
//						NSColor *close = [aColor closestNamedColor];
//						total++;
//						[rawBag add:close];
//					}
//				}
//			}
//			NSArray *exciting = 	[[rawBag objects] filter:^BOOL(id object) {
//				NSColor *idColor = object;
//				return ([idColor isBoring] ? FALSE : TRUE);
//			}];
//				//uh oh, too few colors
//			if ( ([[rawBag objects]count] < 2) || (exciting.count < 2 )) {
//				for ( NSColor *salvageColor in raw ) {
//					NSColor *close = [salvageColor closestNamedColor];
//					total++;
//					[rawBag add:close];
//				}
//			}
//			NSA*colorsUnsorted = [[rawBag objects]nmap:^id(NSColor* obj, NSUInteger index) {
//				AZColor *acolor = [AZColor instance];
//				acolor.color = obj;
//				NSUInteger occ = [rawBag occurrencesOf:obj];
//				acolor.count = occ;
//				acolor.percent = occ / (float)total;
//				return acolor;
//			}];
//
//			rawBag = nil; allBag = nil;
//			[AZStopwatch stop:$(@"%@.colorquant", _name)];
//			return [colorsUnsorted sortedWithKey:@"count" ascending:NO];
//		}

- (BOOL) hasLabel
{
	return NO;
}
-(NSColor*)labelColor
{
	return RED;
}
-(NSUInteger)labelNumber
{
	return 0;
}
-(NSS*)calulatedBundleID
{
	return _calulatedBundleID = _calulatedBundleID ? _calulatedBundleID : [NSBundle calulatedBundleIDForPath:_path];
}
-(CGFloat)hue
{
	return self.color.hueComponent;
}

+ (instancetype)instanceWithPath:(NSString *)path {	return [[[self class] alloc]initWithObject:path]; }

/*
-(NSArray*) colors {
	[AZStopwatch start:$(@"%@.colorquant", self.name)];
//	if (_colors) return  _colors;
	@autoreleasepool {
		NSArray *raw = [self.image quantize];
			// put all colors in a bag
		NSBag *allBag = [NSBag bag];
		[raw do:^(id obj) { [allBag add:obj];}];
		NSBag *rawBag = [NSBag bag];
		int total = 0;
		for ( NSColor *aColor in raw ) {
				//get rid of any colors that account for less than 10% of total
			if ( ( [allBag occurrencesOf:aColor] > ( .0005 * [raw count]) )) {
					// test for borigness
				if ( [aColor isBoring] == NO ) {
					NSColor *close = [aColor closestNamedColor];
					total++;
					[rawBag add:close];
				}
			}
		}
		NSArray *exciting = 	[[rawBag objects] filter:^BOOL(id object) {
			NSColor *idColor = object;
			return ([idColor isBoring] ? FALSE : TRUE);
		}];
			//uh oh, too few colors
		if ( ([[rawBag objects]count] < 2) || (exciting.count < 2 )) {
			for ( NSColor *salvageColor in raw ) {
				NSColor *close = [salvageColor closestNamedColor];
				total++;
				[rawBag add:close];
			}
		}
		NSA*colorsUnsorted = [[rawBag objects]nmap:^id(NSColor* obj, NSUInteger index) {
			AZColor *acolor = [AZColor instance];
			acolor.color = obj;
			NSUInteger occ = [rawBag occurrencesOf:obj];
			acolor.count = occ;
			acolor.percent = occ / (float)total;
			return acolor;
		}];

		rawBag = nil; allBag = nil;
		return [colorsUnsorted sortedWithKey:@"count" ascending:NO];
	}
	[AZStopwatch stop:$(@"%@.colorquant", self.name)];
}
*/
	//
	//- (NSColor*) labelColor {
	//	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	//	NSDictionary *d = [fileURL resourceValuesForKeys:$array(NSURLLabelColorKey) error:nil];
	//	return ( [d valueForKey:NSURLLabelColorKey]  ? (NSColor*) [d valueForKey:NSURLLabelColorKey] : nil);
	//}
	//
	//
	//- (NSNumber*) labelNumber {
	//	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	//	NSDictionary *d = [fileURL resourceValuesForKeys:$array(NSURLLabelNumberKey) error:nil];
	//	return ( [d valueForKey:NSURLLabelNumberKey] ? [d valueForKey:NSURLLabelNumberKey] : nil);
	//	//	You can use both the NSURLLabelNumberKey to get the number of the Finder's assigned label or the NSURLLabelColorKey to get the actual color.
	//
	//}
- (void)setActualLabelColor:(NSColor *)aLabelColor {
	NSError *error = nil;
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	[fileURL setResourceValue:(id)aLabelColor forKey:NSURLLabelColorKey error:&error];
	if (error) NSLog(@"Problem setting label for %@", self.name);
}
- (void)setActualLabelNumber:(NSNumber*)aLabelNumber {
	NSError *error = nil;
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	[fileURL setResourceValue:aLabelNumber forKey:NSURLLabelNumberKey error:&error];
	if (error) NSLog(@"Problem setting label (#) for %@", self.name);
    return;
}
+ (instancetype) forAppNamed:(NSString*)appName  {
	return [[[AtoZ dock] valueForKeyPath:@"name"]  filterOne:^BOOL(id object) {
		return ([object isEqualTo:appName] ? YES : NO);
	}];
}
+ (instancetype) dummy {		return [[AZFile alloc]initWithObject:[[NSBundle bundleForClass:[AtoZ class]]pathForImageResource:@"missing.png"]]; }

+ (instancetype) instanceWithColor: (NSColor*)color {
		//	return [[AZFile alloc]initWithObject:path];
	AZFile*d = [AZFile dummy];
		//	d.color = [color isBoring] ? RANDOMCOLOR : color;
		//	d.colors = @[color];
		//	NSImage *ren = [[NSImage alloc]initWithContentsOfFile:d.path];
		//	d.image = [[[NSImage az_imageNamed:@"missing.png"]imageByScalingProportionallyToSize:AZSizeFromDimension(512)] tintedWithColor:color];
	return d;
}
+ (instancetype) instanceWithImage:(NSImage *)image {
		//	AZFile*d = [AZFile dummy];
		//	NSLog($(@"colors is ** %@ ** boring", StringFromBOOL([d.color isBoring])));
		//	return d;
}

@end

@interface  AZFolder ()

//@property (nonatomic, retain) NSMutableArray *paths;
@property (nonatomic, retain) NSMA *backingstore;
//@property (RONLY) NSUI count;
//@property (RONLY) NSA *files;
//@property (RONLY) NSA *folders;
@property (RONLY) NSA *appFolder;
//@property (RONLY) NSA *categories;
@end

@implementation AZFolder
- (NSUI) count { 						return self.backingstore.count; 	}
//- (id)   initWithCapacity: (NSUI) capacity 	{	return [super init]; }
- (id)   objectAtIndex:    (NSUI) index 	{	return self.backingstore[index]; 	}
- (void) addObject:    (id) anObject {
	[self.backingstore addObject:anObject];
}
- (void) insertObject: (id) anObject  atIndex:(NSUI)index	{
	[self.backingstore insertObject:anObject atIndex:index];
}
- (void) removeLastObject {
	[self.backingstore removeLastObject];
}
- (void) removeObjectAtIndex: (NSUI) index	{
	[self.backingstore removeObjectAtIndex:index];
}
- (void) replaceObjectAtIndex:(NSUI) index withObject: (id) anObject 	{
	(self.backingstore)[index] = anObject;
}
-(void)firstToLast{
	[self.backingstore firstToLast];
}
-(void)lastToFirst{
	[self.backingstore lastToFirst];
}

+ (id) appFolder;
{
	AZFolder *u = [AZFolder new];
	return (id)u.appFolder;
}
+ (id) samplerWithCount:(NSUInteger)items;
{
	AZFolder *u = [AZFolder new];
	return [u samplerWithCount:items];
}
- (id) samplerWithCount:(NSUInteger)items;
{
	return [AZFolder instanceWithPaths:[[self appFolderPaths] randomSubarrayWithSize:items]];
}
//+ (id) samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items;
//+ (id) instanceWithFiles:(NSArray*)files;
//+ (id) instanceWithPaths:(NSArray*)strings;
//+ (id) instanceWithPath:(NSArray*)strings;

+ (id) instanceWithFiles:(NSArray*)files {	return  [[AZFolder alloc]initWithArray:files];	}

+ (id) instanceWithPaths:(NSArray*)paths {	return [[AZFolder alloc]initWithArray:paths];	}

- (id) initWithArray:(NSArray *)array
{
	self = self ? self : [super init ];
	self.backingstore =  [array[0] isKindOfClass:[NSString class]]
					  ? [array map:^id(id obj) {	return  [AZFile instanceWithPath:obj];	}].mutableCopy
					  : array.mutableCopy;
	return  self;
}

- (NSArray *)files {	return self.backingstore;  }

- (NSArray*) appFolderPaths {
	[AZStopwatch start:@"appPaths"];
	NSMA *paths = [NSMA array];
	ApplicationsInDirectory(@"/Applications", paths);
	[AZStopwatch stop:@"appPaths"];
	return paths.copy;
}

- (id) appFolder {
	static AZFolder *_appFolderPaths = nil;
	return _appFolderPaths = _appFolderPaths ?: [AZFolder instanceWithPaths:[self appFolderPaths]];
}


/*
 Our custom accessor method for our songs synthesized property is the starting point for our application’s lazy
 loading architecture and uses key-value coding extensively. The first time we call -songs, we finds that the
 NSMutableArray of Song objects is nil and retrieve a generic representation of the songs property list. We then
 iterate through the array and initialize Song objects using key-value coding. That is, we take an NSDictionary
 object containing keys and values and map the keys to names of properties and assign the values accordingly.
 For every successive call to -songs, we simply return the array of songs we already have in memory.

- (NSMutableArray *)songs
{
    if (_songs == nil) // Check if we've already populated our array.
		{
        NSArray *songDicts = [NSArray arrayWithContentsOfFile:@"Songs.plist"]; // Retrieve the property list from the file system and store as an array.

        _songs = [[NSMutableArray alloc] initWithCapacity:[songDicts count]]; // Initialize our synthesized property.

			// Fast enumeration //
        for (NSDictionary *currDict in songDicts) // Execute the following code for each NSDictionary in the property list.
			{
            Song *song = [Song songWithDictionary:currDict]; // Use KVC to set the Song object's properties.
            [_songs addObject:song]; // Add the song to the array of songs.
			}
		}
    return _songs; // Return the array of Song objects.
}

#pragma mark - Filtering

- (NSArray *)filesMatchingFilter:(NSString *)filter;
//- (NSMutableArray *)songsMatchingFilter:(NSString *)filter
{
	return [self.files filteredArrayUsingPredicate:
			[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR artist.name CONTAINS[cd] %@", filter, filter]];
*/
/**    NSMutableArray *searchResults = [NSMutableArray array];
    if ([filter length] !=0) {
        [searchResults addObjectsFromArray:[self.files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR artist.name CONTAINS[cd] %@", filter, filter]]];
		}
    return searchResults;
}

*/
/*
 Notice that in our header we promise other classes that we're returning an immutable NSArray, however
 in our implementation we promise the method that we should be returning an NSMutableArray. Recall that
 NSMutableArray is a subclass of NSArray (you can Command-click on NSMutableArray below to check its type).
 We also made sure to use a class method on NSMutableArray that will return an autoreleasing object. This
 allows us to avoid having to call copy, a potentially expensive operation:

 return [[songsArray copy] autorelease];

 Other classes that consume our class are only privy to the information we give them in our header file,
 so those classes can continue to assume that we're returning an NSArray.
 */
/*
- (NSArray *)filesWithCategory:(AppCat)cat;
//- (NSMutableArray *)songsWithRatingGreaterThanOrEqualTo:(int)rating
{
    NSMutableArray *songsArray = [NSMutableArray array];
    for (Song *song in self.songs)
		{
        if ([song.rating intValue] >= rating)
			{
            [songsArray addObject:song];
			}
		}
    return songsArray;
}
- (NSUInteger)count{	return self.files.count; }
+ (AZFolder*) samplerWithCount:(NSUInteger)items;
{
	return [[self class]samplerWithBetween:0 andMax:items];
}
+ (AZFolder*) samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items;
{
	NSMA*applications = [NSMA array]; ApplicationsInDirectory(@"/Applications",applications);
	return [AZFolder instanceWithPaths:[applications randomSubarrayWithSize:(items - minItems)]];
}

	//+ (id) instanc:(NSArray*)items {
	//	return  [AZFolder instanceWithPaths:items];
	//	if ([items[0]  isKindOfClass:[AZFile class]])
	//		 ? [[self class]instanceWithFiles:items]
	//		 : [[self class]instanceWithPaths:items];
	//}

	//+ (NSArray *) samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items{
	//	return []
	//}

*/
	//-(id) mutableCopyWithZone: (NSZone *) zone
	//{
	//	NSLog(@"mutableCopyWithZone: has run");
	//	AZFolder *newBook = [[self class] instanceWithItems:self.items.mutableCopy];
	//	return newBook;
	//}
	//@interface  NSArray (SubscriptsAdd)
	//- (id)objectAtIndexedSubscript:(NSUInteger)index; { return [self.items normal:index]; }

	//@interface NSMutableArray (SubscriptsAdd)
	//- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;
	//{
	//	index < self.items.count   ?  object
	//	      ?  [self.items replaceObjectAtIndex:index withObject:object]
	//	      :  [self.items removeObjectAtIndex:index]
	//		  :  [self.items addObject:object];
	//}

	//- (void) addObject:(id) obj{
	//	[self.backingstore addObject:obj];
	//}
	//@interface  NSDictionary (SubscriptsAdd)
	//- (id)objectForKeyedSubscript:(id)k { return [self valueForKey:k]; }

	//@interface  NSMutableDictionary (SubscriptsAdd)
	//- (void)setObject:(id)o forKeyedSubscript:(id)k {[self setValue:o forKey:k]; }
@end

@implementation  AZDock

//- (void) setUp {		[[AZDockQuery instance] dock: self];}

	//- (NSArray*) dockSorted {		[[self.dock sortedWithKey:@"hue" ascending:YES]
	//											arrayUsingIndexedBlock:^id(AZDockItem* obj, NSUInteger idx) {
	//		obj.spotNew = idx;
	//		obj.dockPointNew = [_dock[idx][@"dockPoint"]pointValue];
	//		return obj;
	//								}];  //		if ([obj.name isEqualToString:@"Finder"]) {obj.spotNew = 999;` obj.dockPointNew =
	//}

@end
	//@implementation AZAppFolder
	//+ (instancetype) samplerWithBetween:(NSUInteger)lowItems and:(NSUInteger)hightItems{
	//
	//	return [[[[self class]sharedInstance]itemArray] randomSubarrayWithSize:(hightItems-lowItems)];
	//}

@interface AZImage :NSImage
@end

// We create an empty category to add property overrides
@interface AZImage()
// Private read/write access to the thumbnailImage
@property (readwrite, strong) NSImage *image;
@property (readwrite) BOOL loading;
@end

static NSOperationQueue *AZSharedOperationQueue() {
    static NSOperationQueue *_AZSharedOperationQueue = nil;
    return _AZSharedOperationQueue == nil ? (NSOperationQueue*) ^{		_AZSharedOperationQueue = [NSOperationQueue new];
		// 	Limit concurrency for demo. NSOperationQueueDefaultMaxConcurrentOperationCount creates more threads, as appropriate
		[_AZSharedOperationQueue setMaxConcurrentOperationCount:2];		return _AZSharedOperationQueue;
	}() : _AZSharedOperationQueue;
}

@implementation AZImage
//
//- (NSImage*)image {
//	NSSize theSize = AZSizeFromDimension(512);
//	if (_image) return _image;
//	else {
//		BOOL hasIcon = [AZWORKSPACE iconForFile:_path] ? YES : NO;
//		if (hasIcon) {
//			_image = [[AZWORKSPACE iconForFile:_path]imageScaledToFitSize:theSize];
//			_colors = self.colors;
//		} else _image = _color ? [[NSImage az_imageNamed:@"missing.png"]tintedWithColor: _color]
//			:  [NSImage az_imageNamed:@"missing.png"];
//	}
//	return  _image;
//}
//
//- (id)initWithFile:(AZFile*)file {
//    self = [self image];
//    @synchronized (self) {
//        if (self.representations[0] == nil && !self.loading) {
//            self.loading = YES;
//			// We would have to keep track of the block with an NSBlockOperation, if we wanted to later support cancelling operations that have scrolled offscreen and are no longer needed. That will be left as an exercise to the user.
//            [AZSharedOperationQueue() addOperationWithBlock:^(void) {
//                self = [[NSImage alloc] initWithContentsOfURL:self.fileURL];
//                if (image != nil) {
//                    NSImage *thumbnailImage = ATThumbnailImageFromImage(image);
//						// We synchronize access to the image/imageLoading pair of variables
//                    @synchronized (self) {
//                        self.loading = NO;
//                        self = image;
//                        self.thumbnailImage = thumbnailImage;
//                    }
//                    [image release];
//                } else {
//                    @synchronized (self) {
//                        self.image = [NSImage imageNamed:NSImageNameTrashFull];
//                    }
//                }
//            }];
//        }
//    }
//
//	// Initialize our color to specific given color for testing purposes
//	self.objectRep = file;

//	self.color = self.colors[0];
//	static NSInteger lastColorIndex = 0;
//    NSColorList *colorList = [NSColorList colorListNamed:@"Crayons"];
//    NSArray *keys = [colorList allKeys];
//    if (lastColorIndex >= keys.count) {
//        lastColorIndex = 0;
//    }
//    _fillColorName = [[keys objectAtIndex:lastColorIndex++] retain];
//    _fillColor = [[colorList colorWithKey:_fillColorName] retain];
//    self.title = [super title];
//    return self;
//}

//static NSImage *ATThumbnailImageFromImage(NSImage *image) {
//    NSSize imageSize = [image size];
//    CGFloat imageAspectRatio = imageSize.width / imageSize.height;
//		// Create a thumbnail image from this image (this part of the slow operation)
//    NSSize thumbnailSize = NSMakeSize(THUMBNAIL_HEIGHT * imageAspectRatio, THUMBNAIL_HEIGHT);
//    NSImage *thumbnailImage = [[NSImage alloc] initWithSize:thumbnailSize];
//    [thumbnailImage lockFocus];
//    [image drawInRect:NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
//    [thumbnailImage unlockFocus];

#if DEMO_MODE
		// We delay things with an explicit sleep to get things slower for the demo!
    usleep(250000);
#endif

//    return [thumbnailImage autorelease];
//}

	// Lazily load the thumbnail image when requested
//- (NSImage *)thumbnailImage {
//    if (self.image != nil && _thumbnailImage == nil) {
//			// Generate the thumbnail right now, synchronously
//        _thumbnailImage = [ATThumbnailImageFromImage(self.image) retain];
//    } else if (self.image == nil && !self.imageLoading) {
//			// Load the image lazily
//        [self loadImage];
//    }
//    return _thumbnailImage;
//}
//
//- (void)loadImage {
//    @synchronized (self) {
//        if (self.image == nil && !self.imageLoading) {
//            self.imageLoading = YES;
//				// We would have to keep track of the block with an NSBlockOperation, if we wanted to later support cancelling operations that have scrolled offscreen and are no longer needed. That will be left as an exercise to the user.
//            [ATSharedOperationQueue() addOperationWithBlock:^(void) {
//                NSImage *image = [[NSImage alloc] initWithContentsOfURL:self.fileURL];
//                if (image != nil) {
//                    NSImage *thumbnailImage = ATThumbnailImageFromImage(image);
//						// We synchronize access to the image/imageLoading pair of variables
//                    @synchronized (self) {
//                        self.imageLoading = NO;
//                        self.image = image;
//                        self.thumbnailImage = thumbnailImage;
//                    }
//                    [image release];
//                } else {
//                    @synchronized (self) {
//                        self.image = [NSImage imageNamed:NSImageNameTrashFull];
//                    }
//                }
//            }];
//        }
//    }
//}

@end

//@implementation ATDesktopFolderEntity
//
//- (void)dealloc {
//    [_children release];
//    [super dealloc];
//}
//
//@dynamic children;
//
//- (NSMutableArray *)children {
//    NSMutableArray *result = nil;
//		// This property is declared as atomic. We use @synchronized to ensure that promise is kept
//    @synchronized(self) {
//			// It would be nice if this was asycnhronous to avoid any stalls while we look at the file system. A mechanism similar to how the ATDesktopImageEntity loads images could be used here
//        if (_children == nil && self.fileURL != nil) {
//            NSError *error = nil;
//				// Grab the URLs for the folder and wrap them in our entity objects
//            NSArray *urls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.fileURL includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLLocalizedNameKey, nil] options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&error];
//            NSMutableArray *newChildren = [[NSMutableArray alloc] initWithCapacity:urls.count];
//            for (NSURL *url in urls) {
//					// We create folder items or image items, and ignore everything else; all based on the UTI we get from the URL
//                NSString *typeIdentifier;
//                if ([url getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:NULL]) {
//                    ATDesktopEntity *entity = [ATDesktopEntity entityForURL:url];
//                    if (entity) {
//                        [newChildren addObject:entity];
//                    }
//                }
//            }
//            _children = newChildren;
//        }
//        result = [[_children retain] autorelease];
//    }
//    return result;
//}
//
//- (void)setChildren:(NSMutableArray *)value {
//		// This property is declared as atomic. We use @synchronized to ensure that promise is kept
//    @synchronized(self) {
//        if (_children != value) {
//            [_children release];
//            _children = [value retain];
//        }
//    }
//}
//
//@end


@implementation AZColor
@synthesize 	brightness, 	saturation,		hue;
@synthesize 	percent = _percent, count;
@synthesize  	name, 			color;
@synthesize 	hueComponent, 	total;

+ (instancetype) instanceWithColor:(NSColor*)color count:(NSUI)c total:(NSUI) totes {
	AZColor *cc = [[self class]instance];
	cc.color = color;
	cc.count = c;
	cc.total = totes;
	return cc;
}
- (CGF) percent
{
	return _percent = count/total;
}

+ (instancetype) instanceWithObject: (NSDictionary *)dic {	if (!dic[@"color"])  return nil;
	AZColor *color = [[self class] instanceWithColor:dic[@"color"]];
	color.name 	  =  dic [@"name"]    ?  dic [@"name"]    			   : @"";
	color.count   =  dic [@"count"]   ? [dic [@"count"] intValue]      : 0;
	color.total   =  dic [@"percent"] ? ( color.count / [dic [@"percent"] floatValue] ) : 1;
		//	percent =dic [@"percent"] ? [dic [@"percent"] floatValue]  : 0;
	return color;
}
	//-(CGFloat) saturation 	{	return [_color saturationComponent]; }
	//-(CGFloat) hue 		  	{	return [_color hueComponent];		 }
	//-(CGFloat) brightness 	{	return [_color brightnessComponent]; }
	//-(CGFloat) hueComponent {	return [color_ hueComponent];		 		}

/*
-(NSArray*) colorsForImage:(NSImage*)image {

	@autoreleasepool {

		NSArray *rawArray = [image quantize];
			// put all colors in a bag
		NSBag *allBag = [NSBag bag];
		for (id thing in rawArray ) [allBag add:thing];
		NSBag *rawBag = [NSBag bag];
		int total = 0;
		for ( NSColor *aColor in rawArray ) {
				//get rid of any colors that account for less than 10% of total
			if ( ( [allBag occurrencesOf:aColor] > ( .0005 * [rawArray count]) )) {
					// test for borigness
				if ( [aColor isBoring] == NO ) {
					NSColor *close = [aColor closestNamedColor];
					total++;
					[rawBag add:close];
				}
			}
		}
		NSArray *exciting = 	[[rawBag objects] filter:^BOOL(id object) {
			NSColor *idColor = object;
			return ([idColor isBoring] ? FALSE : TRUE);
		}];

			//uh oh, too few colors
		if ( ([[rawBag objects]count] < 2) || (exciting.count < 2 )) {
			for ( NSColor *salvageColor in rawArray ) {
				NSColor *close = [salvageColor closestNamedColor];
				total++;
				[rawBag add:close];
			}
		}
		NSMutableArray *colorsUnsorted = [NSMutableArray array];

		for (NSColor *idColor in [rawBag objects] ) {

			AZColor *acolor = [AZColor instance];
			acolor.color = idColor;
			acolor.count = [rawBag occurrencesOf:idColor];
			acolor.percent = ( [rawBag occurrencesOf:idColor] / (float)total );
			[colorsUnsorted addObject:acolor];
		}
		rawBag = nil; allBag = nil;
		return [colorsUnsorted sortedWithKey:@"count" ascending:NO];
	}
}

*/
@end

//@implementation AZDockItem

//+ (instancetype)instanceWithPath:(NSString *)path {
		//	AZDockItem *k = [AZDockItem instanceWithObject:path];
		//		[k setWit]//:path];

		//	k.path = path;
		//	NSLog(@"Made dockItem for %@", k.name);
		//AZDockItem * s = [AZDockItem instance];
		//	[AZDockItem instanceWithPath::[super instanceWithPath:path]];
		//	return k;
		//	AZDockItem *u = (AZDockItem*)[super instanceWithPath:string];
		//	u.path = string;
		//	[[self super] setUp]; //WithPath:string];
		//	return u;
//}
	//@property (nonatomic, assign) 	CGPoint		dockPoint;
	//@property (nonatomic, assign) 	CGPoint		dockPointNew;
	//@property (nonatomic, assign) 	NSUInteger	spot;
	//@property (nonatomic, assign) 	NSUInteger 	spotNew;
	//@property (nonatomic, readonly)	BOOL		isRunning;
	//@property (nonatomic, assign)	BOOL		needsToMove;

//@end

	//+ (instancetype) dummy;
	//- (NSString*) itunesDescription { return self.itunesInfo.itemDescription; }
	//- (AJSiTunesResult *) itunesInfo { return  [AtoZiTunes resultsForName:self.name]; }
	//@synthesize dockPoint, dockPointNew, spot, spotNew;
	//@synthesize hue, isRunning, hasLabel, needsToMove; //labelNumber;
	//@synthesize itunesInfo, itunesDescription;
NSString *const AZFileUpdated = @"AZFileUpdated";

