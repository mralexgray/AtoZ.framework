//
//  AZDock.m
//  AtoZ
//
//  Created by Alex Gray on 9/12/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZModels.h"
#import "AtoZFunctions.h"

//
//@dynamic  appCategories;// = _appCategories,
//@dynamic  sortOrder;// = _sortOrder,
//@dynamic  appFolderStrings;// = _appFolderStrings,
//@dynamic  _dock;// = _dock,
//@dynamic  dockSorted;// = _dockSorted,
//@dynamic  appFolder;// = _appFolder,
//@dynamic  appFolderSorted;// = _appFolderSorted;

@interface  AZFolder ()
@property (nonatomic, retain) NSMutableArray *items;
@end

@implementation AZFolder


+ (AZFolder*) samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items;
{
	NSMA*applications = [NSMA array]; ApplicationsInDirectory(@"/Applications",applications);
	return [AZFolder instanceWithPaths:[applications randomSubarrayWithSize:(items - minItems)]];
}

+ (id) instanceWithItems:(NSArray*)items {
	return [items[0]  isKindOfClass:[AZFile class]]
		 ? [[self class]instanceWithFiles:items]
		 : [[self class]instanceWithPaths:items];
}

//+ (NSArray *) samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items{
//	return []
//}


//-(id) mutableCopyWithZone: (NSZone *) zone
//{
//	NSLog(@"mutableCopyWithZone: has run");
//	AZFolder *newBook = [[self class] instanceWithItems:self.items.mutableCopy];
//	return newBook;
//}
+ (id) instanceWithFiles:(NSArray*)files {
	AZFolder *me = [[self class]array];
//	me.backingstore  = files.mutableCopy;
	return me = files.mutableCopy;
}

+ (id) instanceWithPaths:(NSArray*)paths {
	AZFolder *me. = [[self class] instance];//instancesWithArray:paths];
	return me.ba = [paths map:^id(id obj) {
		return  [AZFile instanceWithPath:obj];
	}].mutableCopy;
}

+ (instancetype) appFolder {

	[AZStopwatch start:@"appFolder"];
	NSMA *paths = [NSMA array];
	ApplicationsInDirectory(@"/Applications", paths);
	return [[self class] instanceWithPaths:paths];
	[AZStopwatch stop:@"appFolder"];

}



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

- (void) setUp {		[[AZDockQuery instance] dock: self];

}

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




@implementation AZColor
@synthesize 	brightness, 	saturation,		hue;
@synthesize 	percent, 		count;
@synthesize  	name, 			color;
@synthesize 	hueComponent;

+ (instancetype) instanceWithColor:(NSColor*)color {

}
+ (AZColor*) instanceWithObject: (NSDictionary *)dic {	if (!dic[@"color"])  return nil;
	AZColor *color = [[self class] instanceWithColor:dic[@"color"]];
	color.name 	  =  dic [@"name"]    ?  dic [@"name"]    			   : @"";
	color.count   =  dic [@"count"]   ? [dic [@"count"] intValue]      : 0;
	color.percent =	 dic [@"percent"] ? [dic [@"percent"] floatValue]  : 0;
	return color;
}
	//-(CGFloat) saturation 	{	return [_color saturationComponent]; }
	//-(CGFloat) hue 		  	{	return [_color hueComponent];		 }
	//-(CGFloat) brightness 	{	return [_color brightnessComponent]; }
	//-(CGFloat) hueComponent {	return [color_ hueComponent];		 		}


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


@end



