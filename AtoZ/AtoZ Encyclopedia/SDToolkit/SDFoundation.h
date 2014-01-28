//
//  SDFoundation.h
//  Aloha
//
//  Created by Steven Degutis on 6/14/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NSString* NSStringFromCGRect(CGRect rect);
NSString* NSStringFromCGPoint(CGPoint p);

void SDDivideRect(NSRect inRect, NSRect* slice, NSRect* rem, CGFloat amount, NSRectEdge edge);
NSRange SDFullRange(NSString *string);
