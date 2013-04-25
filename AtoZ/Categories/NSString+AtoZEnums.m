//
//  NSString+AtoZEnums.m
//  AtoZ
//
//  Created by Alex Gray on 4/16/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "NSString+AtoZEnums.h"

@implementation NSString (AtoZEnums)


+ (NSD*) enumDictionary;
{

	return @{@"AZWindowPosition":
				@[@"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic"]};

}

+ (NSS*) eType:(NSS*)type v:(int)value {
	

}
- (int) enumValue { return  9; }

@end
