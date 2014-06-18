//
//  AZXMLWriter.h
//  AtoZ
//
//  Created by Alex Gray on 4/14/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

@import Foundation;

//@class NSMutableData, NSData;
@interface AZXMLWriter : NSObject

{
 NSMutableData *_data;
}

-(id)init;

-(void)encodePropertyList:(id)object indent:(NSInteger)indent;

-(NSData *)dataForRootObject:(id)object;

+(NSData *)dataWithPropertyList:(id)plist;

@end
