//
//  AZCLICategories.h
//  AtoZ
//
//  Created by Alex Gray on 4/22/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"

@interface AZCLI (Categories)

//@property (RONLY) NSA 	*names, *colors;
//@property (RONLY) NSC 	*next;
//@property (STRNG) NSS	*name;
//
//- (id) objectAtIndexedSubscript:(NSUI)idx;
//
//+ (instancetype) instanceWithListNamed:(NSS*)listName;
//+ (instancetype) instanceWithColorList:(NSCL*)list;
//+ (instancetype) instanceWithNames:(NSA*)names;
//+ (instancetype) instanceWithColors:(NSA*)names;
- (NSS*) cliMenuFor:(NSA*)items starting:(NSUI)idx palette:(NSA*)p;



@end
