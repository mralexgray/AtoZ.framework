//
//  NSTreeController-DMExtensions.h
//  Library
//
//  Created by William Shipley on 3/10/06.
//  Copyright 2006 Delicious Monster Software, LLC. Some rights reserved,
//    see Creative Commons license on wilshipley.com

#import <Cocoa/Cocoa.h>

@interface NSTreeController (AFAdditions)

/*!
	@brief
	This method takes an array of your model objects, and selects the nodes in the tree representing them.
 */
- (void)setSelectedObjects:(NSArray *)newSelectedObjects;

/*!
	@result
	The controller index path to your model object.
 */
- (NSIndexPath *)indexPathToObject:(id)object;

/**
 
 \brief     Returns the object at the specified index path.
 
 */
- (id) objectAtIndexPath:(NSIndexPath*)indexPath;


@end
