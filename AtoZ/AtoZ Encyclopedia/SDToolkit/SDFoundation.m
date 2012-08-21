//
//  SDFoundation.m
//  Aloha
//
//  Created by Steven Degutis on 6/14/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDFoundation.h"


NSString* NSStringFromCGRect(CGRect rect) {
	return NSStringFromRect(NSRectFromCGRect(rect));
}

NSString* NSStringFromCGPoint(CGPoint p) {
	return NSStringFromPoint(NSPointFromCGPoint(p));
}

void SDDivideRect(NSRect inRect, NSRect* slice, NSRect* rem, CGFloat amount, NSRectEdge edge) {
	NSRect temp;
	NSRect* slice2 = (slice ? slice : &temp);
	NSRect* rem2 = (rem ? rem : &temp);
	NSDivideRect(inRect, slice2, rem2, amount, edge);
}

NSRange SDFullRange(NSString *string) {
	return NSMakeRange(0, [string length]);
}
