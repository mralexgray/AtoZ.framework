//
//  SimpleView.m
//  NSViewAnimation Test
//
//  Created by Matt Gemmell on 08/11/2006.
//  Copyright 2006 Magic Aubergine. All rights reserved.
//

#import "AZSimpleView.h"


@interface AZTextView : NSTextView
@end
@implementation AZTextView
- (void) mouseDown:(NSEvent *)theEvent {
   [[self nextResponder] mouseDown:theEvent];
}
@end

@interface AZSimpleView ()
@property (nonatomic, retain) NSAttributedString *string;
@property (nonatomic, retain) AZTextView *atv;
@end

@implementation AZSimpleView
@synthesize backgroundColor, tag, selected, string, atv, uniqueID;

- (id)initWithFrame:(NSRect)frame
{
	if (self = [super initWithFrame:frame]) {
//		tag = nil;
		
		backgroundColor = RANDOMCOLOR;
		self.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
		uniqueID = [NSString newUniqueIdentifier];
		NSMutableParagraphStyle *theStyle =[[NSMutableParagraphStyle alloc] init];
		[theStyle setLineSpacing:12];
		atv = [[AZTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
		[atv setSelectable:NO];
		[atv setDefaultParagraphStyle:theStyle];
		[atv setBackgroundColor:CLEAR];
		[[atv textStorage] setForegroundColor:BLACK];
		[self addSubview: atv];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super initWithCoder:coder])) {
	
		backgroundColor = [coder decodeObjectForKey: @"backgroundColor"];
		if	(!backgroundColor) backgroundColor = RED;
		uniqueID = [coder decodeObjectForKey: @"uniqueID"];
		atv = [coder decodeObjectForKey:@"atv"];
		[self addSubview:atv];
	
	}
	return self;
}


- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:backgroundColor forKey:@"backgroundColor"];
    [aCoder encodeObject:uniqueID forKey:@"uniqueID"];
    [aCoder encodeObject:atv forKey:@"atv"];
}

- (NSAttributedString *) string {
	string = nil;
	string = [[NSAttributedString alloc] initWithString:
		$(@"UNIQUE:%@ F:%@\nB:%@\nSV:%@\nC:%@  SEL:%@ ", uniqueID,	NSStringFromRect(self.frame),
										NSStringFromRect(self.bounds),
										self.superview, 
										backgroundColor.nameOfColor,
										StringFromBOOL(selected))
		attributes:$map(	
				[NSFont fontWithName:@"Ubuntu Mono Bold" size:15],
				NSFontAttributeName, backgroundColor.contrastingForegroundColor, NSForegroundColorAttributeName)];
	return string;
}


- (void)drawRect:(NSRect)rect {
	[backgroundColor set];
    NSRectFill(rect);
	[[atv textStorage] setAttributedString:self.string];

}

- (void) setSelected:(BOOL)isselected {
	selected = isselected;
	self.backgroundColor = backgroundColor.complement;
	[self setNeedsDisplay:YES];


}

- (void) mouseDown:(NSEvent *)theEvent {
	self.selected =! selected;
}

- (void)scrollWheel:(NSEvent *)event
{
//	NSLog(@"SCROLLTIME");
   	[[self nextResponder] scrollWheel:event];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"scrollRequested" object:self];
}

@end
