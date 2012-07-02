//
//  NSObject+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AtoZ)

/*	Now every instance (of every class) has a dictionary, where you can store your custom attributes. With Key-Value Coding you can set a value like this:

//[myObject setValue:attributeValue forKeyPath:@"dictionary.attributeName"]

	And you can get the value like this:
//[myObject valueForKeyPath:@"dictionary.attributeName"]

	That even works great with the Interface Builder and User Defined Runtime Attributes.

	Key Path                   Type                     Value
	dictionary.attributeName   String(or other Type)    attributeValue
*/
- (NSMutableDictionary*) getDictionary;

@end
