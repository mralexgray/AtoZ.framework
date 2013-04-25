//
//  AZCLICategories.m
//  AtoZ
//
//  Created by Alex Gray on 4/22/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZCLICategories.h"
#import "AtoZ.h"

//@implementation NSArray (AZCLI)
//- (NSS*) cliMenuFromContentsStarting:(NSUI)idx inPalette:(NSA*)pal {

//@interface AZPalette ()
//
//@property (ASS) 	 NSUI index;
//@end
//static NSMD *cls = nil;

@implementation AZCLI (Categories)

//- (id) objectAtIndexedSubscript:(NSUInteger)idx { return [self.colors normal:idx]; }
//
//+ (void) load { cls = NSMD.new; }

+ (NSS*) cliMenuFor:(NSA*)items starting:(NSUI)idx palette:(id)p {

	NSUI maxlen = ceil([items lengthOfLongestMemberString] * 1);	// deduce longest string
	NSUI cols = floor(120.f/(float) maxlen);								// accomodate appropriate number of cols.
	NSUI maxIndex = $(@"%lu: ", idx + items.count).length;  			// make sure numbers fit nice
	__block NSUI i = idx -1;													// start at an index
	return  [items reduce:@"\n" withBlock:^id(id sum, id obj) {		i++; // Allow goruped indexes.

		NSS* paddedIndex = [ $(@"%lu: ", i) paddedTo:maxIndex];
		NSS* 	outP = (i % cols) == 0 ? @"\n" : @"";
				outP = [outP withString:paddedIndex];
//				NSC* c = [p ISKINDA:NSCL.class] ?[[p colors] normal: i] : [p normal:1];
				outP = [outP withString:colorizeStringWithColor([$(@"%@",obj) paddedTo:maxlen], [p  normal:i]).colorLogString];
		return [sum withString:outP];
	}];		  /* Find the longest string and base our columns on that. */
}

//+ (instancetype) instanceWithListNamed:(NSS*)listName {
//
//	NSA* lists = [NSC colorLists];
//	return [self instanceWithColorList:[lists filterOne:^BOOL(id object) {
//		return SameString([object vFk:@"name"], listName);
//	}]];
//}
//+ (instancetype) instanceWithNames:(NSA*)names {
//
//	NSA* colors = [names cw_mapArray:^id(id object) {
//		NSC* c = [NSC colorWithName:object] ?: [NSC colorWithHTMLString:object] ?: [NSC colorWithHexString:object];
//		if (c) c.name = object;		return c ?: nil;
//	}];
//	return [self instanceWithColorList:[NSC createColorlistWithColors:colors andNames:[colors valueForKeyPath:@"name"] named:[[(NSC*)colors[0] name] withString:@"List"]]];
//}
//+ (instancetype) instanceWithColors:(NSA*)names;
//+ (instancetype) instanceWithColorList:(NSCL*)list {
//
//	AZPalette *p = [self.alloc init];
//	p.index = 0;
//	p.name = list.name;
//	cls[list.name] = [list colors];
//
//	return p;
//}
//- (NSA*) names  {	return [cls[_name] valueForKeyPath:@"name"];	}
//- (NSA*) colors {	return cls[_name];	}
//- (NSC*) next  { _index++; return self.colors[_index]; }


//// Subclass specific KVO Compliant "items" accessors to trigger NSArrayController updates on inserts / removals.
////Synthesize array accessors
//#define CAP(x) [[x firstLetter]capitalize]
//#define SynthesizeMutableAccessors(__COLLECTION_NAME__, __INTERNAL_KEYPATH__, __INSERTABLE_CLASS__)\
//- (NSUI)countOfCAP {	return [[self valueForKeyPath:__INTERNAL_KEYPATH__] count]; }\
//- (__INSERTABLE_CLASS__*)  objectIn__CAPPED_KEY__At:(NSUI)i	{	return [self __INTERNAL_KEYPATH__][i];  }\
//- (void)removeObjectFrom__CAPPED_KEY__AtIndex:(NSUI)i { 	[[self __INTERNAL_KEYPATH__] removeObjectAtIndex:i];  };\
//- (void)insertObject:(__INSERTABLE_CLASS__*)o in__CAPPED_KEY__AtIndex:(NSUI)i {	[[self __INTERNAL_KEYPATH__] insertObject:o atIndex:i]; }\
//
//SynthesizeMutableAccessors(@"colors",cls[name],NSC);
//
@end
