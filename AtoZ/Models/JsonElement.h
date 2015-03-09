//
//  JsonElement.h
//  VisualJSON
//
//  Created by youknowone on 11. 12. 12..
//  Copyright (c) 2011 youknowone.org. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class JSONDocument;
//@protocol JSONDocumentDelegate <NSObject>
//- (NSUInteger)document:(VJDocument *)document outlineChildrenCountForItem:(id)item;
//- (BOOL)document:(VJDocument *)document outlineIsItemExpandable:(id)item;
//- (NSString *)document:(VJDocument *)document outlineTitleForItem:(id)item;
//- (NSString *)document:(VJDocument *)document outlineDescriptionForItem:(id)item;
//- (id)document:(VJDocument *)document outlineChild:(NSInteger)index ofItem:(id)item;
//
//@end

/*!
	@brief  JSON data to representation converter
	
	JsonElement get parsed NSArray or NSDictionary data as JSON data.
	JsonElement provides representation for data for each view type.
 */

@interface JsonElement : NSObject

@property (weak)  id parent;
@property (STR) id object;
@property (STR) NSString *key;
@property (STR) NSArray *keys;
@property (STR) NSMutableDictionary *children;

- (id)initWithObject:(id)object;
+ elementWithObject:(id)object;

- (id)childAtIndex:(NSInteger)index;
- (NSString *)outlineDescription;


@end

