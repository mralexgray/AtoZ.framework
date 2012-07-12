//  AZSimpleView.m

#import "AZSimpleView.h"

#define AZSTRINGFROMBOOL(b) 	((b) ? @"YES" : @"NO")
#define AZRANDHEX 			(rand() % 255) / 255
#define AZRANDOMCOLOR		[NSColor colorWithCalibratedRed:AZRANDHEX green:AZRANDHEX blue:AZRANDHEX alpha:1.0];

@implementation NSColor (ContrastingComplementary)
- (NSColor *)contrastingForegroundColor {
	NSColor *c = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat r, g, b, a;
	[c getRed:&r green:&g blue:&b alpha:&a];
	CGFloat brite = sqrt((r * r * 0.241) + (g * g * 0.691) + (b * b * 0.068));
	if (brite > 0.57) return NSColor.blackColor; else return NSColor.whiteColor;
}
- (NSColor *)complement {
	NSColor *c = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat h,s,b,a;
	[c getHue:&h saturation:&s brightness:&b alpha:&a];
	h += 0.5;	if (h > 1) h -= 1.0;
	return [NSColor colorWithDeviceHue:h saturation:s brightness:b alpha:a];
}
@end

@implementation NSString (UniqueID)
+ (NSString *)newUniqueIdentifier {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid); 	return CFBridgingRelease(identifier);
}
@end

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
@synthesize backgroundColor, selected, string, atv, uniqueID;

- (id)initWithFrame:(NSRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		backgroundColor = AZRANDOMCOLOR;
		self.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
		uniqueID = [NSString newUniqueIdentifier];
		NSMutableParagraphStyle *theStyle =[[NSMutableParagraphStyle alloc] init];
		[theStyle setLineSpacing:12];
		atv = [[AZTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
		[atv setSelectable:NO];
		[atv setDefaultParagraphStyle:theStyle];
		[atv setBackgroundColor:[NSColor clearColor]];
		[[atv textStorage] setForegroundColor:[NSColor blackColor]];
		[self addSubview: atv];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super initWithCoder:coder])) {
	
		backgroundColor = [coder decodeObjectForKey: @"backgroundColor"];
		if	(!backgroundColor) backgroundColor = [NSColor redColor];
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
		[NSString stringWithFormat:@"UNIQUE:%@ F:%@\nB:%@\nSV:%@\nC:%@  SEL:%@ ", uniqueID,	NSStringFromRect(self.frame),
										NSStringFromRect(self.bounds),
										self.superview, 
										backgroundColor,
										AZSTRINGFROMBOOL(selected)]
		attributes:[NSDictionary dictionaryWithObjectsAndKeys:	
				[NSFont fontWithName:@"Ubuntu Mono Bold" size:15],
				NSFontAttributeName, backgroundColor.contrastingForegroundColor, NSForegroundColorAttributeName,nil]];
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
