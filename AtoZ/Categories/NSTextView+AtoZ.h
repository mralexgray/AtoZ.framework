//
//  NSTextView+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/16/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface AZTextViewResponder : NSTextView
@end

@interface NSTextView (AtoZ)

- (void) autoScrollText:(id) text;
- (void) autoScrollAndStyleText:(NSString*) text;

+ (AZTextViewResponder*)  textViewForFrame:(NSRect)frame withString:(NSAttributedString*)s;

- (IBAction) decrementFontSize: (id) sender;
- (IBAction) incrementFontSize: (id) sender;
- (IBAction) increaseFontSize:  (id) sender;
- (void)	 changeFontSize:	 	(CGFloat) delta;

@end



@interface NSSegmentedControl (FitTextNice)

- (void)fitTextNice ;

@end
