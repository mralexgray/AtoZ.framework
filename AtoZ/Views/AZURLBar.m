
#import <WebKit/WebKit.h>
#import "AtoZ.h"
#import "AZLogConsole.h"
#import "AZURLBar.h"

//#import <AceView/AceView.h>

#define kAZURLBarGradientColorTop [NSColor colorWithCalibratedRed:0.9f green:0.9f blue:0.9f alpha:1.0f]
#define kAZURLBarGradientColorBottom [NSColor colorWithCalibratedRed:0.700f green:0.700f blue:0.700f alpha:1.0f]
#define kAZURLBarBorderColorTop [NSColor colorWithDeviceWhite:0.6 alpha:1.0f]
#define kAZURLBarBorderColorBottom [NSColor colorWithDeviceWhite:0.2 alpha:1.0f]





//@implementation AZWebView { NSInteger resourceCount, resourceFailedCount, resourceCompletedCount;}
@implementation AZWebView { NSInteger resourceCount, resourceFailedCount, resourceCompletedCount;}

- (void)reloadURL:(id)s	{    [self.mainFrame reload];}
- (void)showAlert:(id)x {
	NSBeginAlertSheet (@"WebKit Objective-C Programming Guide",
							 @"OK",
							 nil,
							 @"Cancel",
							 [self window],
							 self,
							 nil,
							 nil,
							 nil,
							 @"As the user navigates from page to page in your embedded browser, you may want to display the current URL, load status, and error messages. For example, in a web browser application, you might want to display the current URL in a text field that the user can edit.", nil);
}
- (void)updateProgress  {
	static float progress;
	self.urlBar.progressPhase = KFProgPending;
	progress += .005;
	self.urlBar.progress = progress;
	progress < 1 ?
	[self performSelector:@selector(updateProgress) withObject:nil afterDelay:.02f] :
	[self.urlBar setProgressPhase:KFProgNone];
}
//- (AZURLBar *) urlBar { return [self associatedValueForKey:_cmd]; }
- (void) awakeFromNib {


	//	if (urlBar && ![urlBar isEqual:self.urlBar]) {

	//	[self associateValue:urlBar forKey:@"urlBar" policy:OBJC_ASSOCIATION_ASSIGN];
	if (_urlBar) {

		self.frameLoadDelegate = self;
		self.UIDelegate = self;
		self.policyDelegate = self;
		self.downloadDelegate = self;
		self.resourceLoadDelegate = self;
		_urlBar.webView = self;


		[self.superview addSubview:self.split = [AGNSSplitView.alloc initWithFrame:self.superview.bounds]];
		_split.arMASK = NSSIZEABLE;
		[_split setVertical:NO];
		_split.subviews = @[_urlBar,self];
		[self.superview addSubview:self.consoleSplit = [AGNSSplitView.alloc initWithFrame:self.bounds]];
		_consoleSplit.arMASK = NSSIZEABLE;
		[_consoleSplit setVertical:YES];
		_consoleSplit.subviews = @[self,_console = [AZLogConsoleView.alloc initWithFrame:self.bounds]];
		_console.arMASK = NSSIZEABLE;
		[_consoleSplit setPosition:_consoleSplit.width -50 ofDividerAtIndex:0];
		[_console logString:NSS.dicksonBible file:NULL lineNumber:1];

		[_split setPosition:100 ofDividerAtIndex:0 animated:YES]	;
		__block id bSplit = _split; 			static NSA *pal = nil;;
		[_split setDividerDrawingHandler:^(NSRect r) {
  			if (!pal) pal = [NSC gradientPalletteLooping:RANDOMPAL steps:100]; static int idx;
			NSRectFillWithColor(r,[pal normal:idx]); idx++;
			[NSThread performBlock:^{	[bSplit setNeedsDisplayInRect:r]; } afterDelay:.3];
		}];
		//		self.urlBar.addressString = @"https://pods.AZ-interactive.com";
		//	self.urlBar.frame = AZUpperEdge(self.window.contentRect, 100);
		NSButton *reloadButton = NSButton.new;
		[reloadButton setTranslatesAutoresizingMaskIntoConstraints:NO];
		[reloadButton setBezelStyle:NSInlineBezelStyle];
		[reloadButton setImage:[NSImage imageNamed:@"NSRefreshTemplate"]];
		[reloadButton setTarget:self];
		[reloadButton setAction:@selector(reloadURL:)];
		_urlBar.leftItems = @[reloadButton];
		NSButton *alertButton = NSButton.new;
		[alertButton setTranslatesAutoresizingMaskIntoConstraints:NO];
		[alertButton setBezelStyle:NSInlineBezelStyle];
		[alertButton setTitle:@"Alert"];
		[alertButton setTarget:self];
		[alertButton setAction:@selector(showAlert:)];
		[[alertButton cell] setBackgroundStyle:NSBackgroundStyleRaised];
		_urlBar.rightItems = @[alertButton];
	}
}



#pragma mark - AZURLBarDelegate Methods


- (void)urlBar:(AZURLBar *)urlBar didRequestURL:(NSURL *)url
{
	[[self mainFrame] loadRequest:[NSURLRequest.alloc initWithURL:url]];
	self.urlBar.progressPhase = KFProgPending;
}


- (BOOL)urlBar:(AZURLBar *)urlBar isValidRequestStringValue:(NSString *)requestString
{
	NSString *urlRegEx = @"(ftp|http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
	NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
	return [urlTest evaluateWithObject:requestString];
}


#pragma mark - NSWindowDelegate Methods


- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect
{
	rect.origin.y -= NSHeight(self.urlBar.frame);
	return rect;
}


#pragma mark WebKitProgressDelegate Methods


- (void)webKitProgressDidChangeFinishedCount:(NSInteger)finishedCount ofTotalCount:(NSInteger)totalCount
{
	self.urlBar.progressPhase = KFProgDownloading;
	self.urlBar.progress = (float)finishedCount / (float)totalCount;
	if (totalCount == finishedCount)
	{
		double delayInSeconds = 1.0;
    AZBlockSelf(weakSelf);
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
							{
								weakSelf.urlBar.progressPhase = KFProgNone;
							});
	}
}

- (void)updateResourceStatus
{
	[self respondsToSelector:@selector(webKitProgressDidChangeFinishedCount:ofTotalCount:)] ?
	[self webKitProgressDidChangeFinishedCount:(resourceCompletedCount + resourceFailedCount) ofTotalCount:resourceCount]:
	NSLog(@"progress: %lu of %lu", (resourceCompletedCount + resourceFailedCount), resourceCount);
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
	if (frame == [self mainFrame])     [[sender window] setTitle:title];
}


- (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource
{
	return @(resourceCount++);
}


-(NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
{
	[self updateResourceStatus];
	return request;
}


-(void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource
{
	resourceFailedCount++;
	[self updateResourceStatus];
}


-(void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource
{
	resourceCompletedCount++;
	[self updateResourceStatus];
}
@end



@interface AZURLBar ()
//@property (nonatomic) KFProgPhase progressPhase;
@property (nonatomic) BOOL drawBackground;
@property (nonatomic) NSColor *currentBarColorTop, *currentBarColorBottom;
@property (nonatomic) NSTextField *urlTextField;
@property (nonatomic) NSButton *loadButton;
@property (nonatomic) NSArray *fieldConstraints;

@end

@implementation AZURLBar
- (id)initWithCoder:(NSCoder*)c	{ return self = [super initWithCoder:c] ? [self initializeDefaults], self : nil; }
- (id)initWithFrame:(NSRect)f		{ return self = [super initWithFrame:f] ? [self initializeDefaults], self : nil; }

- (void)viewWillMoveToSuperview:(NSView*)s	{
	self.drawBackground = ![s.className isEqualToString:@"NSToolbarFullScreenContentView"];
}

//- (instancetype)initWithDelegate:(id<AZURLBarDelegate>)delegate
//{
//	return self = super.init ? self.delegate = delegate,  [self initializeDefaults], self : nil;
//}

- (void) awakeFromNib { [self initializeDefaults]; [super awakeFromNib]; }

- (void)initializeDefaults
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{

		_progress						= .0f;
		_cornerRadius 					= 2.5f;
		_progressPhase 				= KFProgNone;
		self.gradientColorTop 		= kAZURLBarGradientColorTop;
		self.gradientColorBottom 	= kAZURLBarGradientColorBottom;
		self.borderColorTop 			= kAZURLBarBorderColorTop;
		self.borderColorBottom 		= kAZURLBarBorderColorBottom;
		self.urlTextField 			= NSTextField.new;
		self.urlTextField.translatesAutoresizingMaskIntoConstraints = NO;
		self.urlTextField.bezeled = NO;
		self.urlTextField.stringValue = @"http://";
		if (self.webView) {
			[self.urlTextField bind:@"stringValue" toObject:self.webView withKeyPath:@"mainFrameURL" options:nil];
//			[self.webView bind:@"mainFrameURL" toObject:self.urlTextField withKeyPath:@"stringValue" options:nil];
		}
		self.urlTextField.focusRingType 		= NSFocusRingTypeNone;
		self.urlTextField.drawsBackground 	= NO;
		self.urlTextField.textColor 			= [NSColor blackColor];
		[(NSTextFieldCell*)self.urlTextField.cell setLineBreakMode:NSLineBreakByTruncatingTail];
		self.urlTextField.formatter 			= AZURLFormatter.new;
		self.urlTextField.action 				= @selector(didPressEnter:);
		self.urlTextField.target 				= self;
		[self addSubview:self.urlTextField];

		self.loadButton = NSButton.new;
		self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.loadButton.bezelStyle 			= NSTexturedRoundedBezelStyle;
		self.loadButton.target 					= self;
		self.loadButton.action 					= @selector(didPressEnter:);
		self.loadButton.title					 = @"Load";
		[self addSubview:self.loadButton];

		[self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.urlTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];
		[self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.loadButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];

		[self updateFieldConstraints];
	});
}

- (void)updateFieldConstraints
{
	NSView *urlTextField 			= self.urlTextField;
	NSView *loadButton 				= self.loadButton;
	NSDictionary *views 				= NSDictionaryOfVariableBindings(urlTextField, loadButton);
	NSMutableDictionary *allViews = [views mutableCopy];
	NSUInteger leftItemsCount = self.leftItems == nil ? 0 : [self.leftItems count];
	leftItemsCount ?
	[allViews addEntriesFromDictionary:[self viewsFromArray:self.leftItems withBaseName:@"leftItem"]] : nil;
	NSUInteger rightItemsCount = self.rightItems == nil ? 0 : self.rightItems.count;
	rightItemsCount ?
	[allViews addEntriesFromDictionary:[self viewsFromArray:self.rightItems withBaseName:@"rightItem"]] :nil;
	views = [allViews copy];
	NSString *leftItemsVisualFormat 		= [self visualFormatFromArray:self.leftItems withBaseName:@"leftItem"];
	NSString *rightItemsVisualFormat 	= [self visualFormatFromArray:self.rightItems withBaseName:@"rightItem"];

	if (self.fieldConstraints != nil)   [self removeConstraints:self.fieldConstraints];
	NSString *visualFormat = $(@"|-(12)%@[urlTextField]%@(20)-[loadButton]-(8)-|", leftItemsVisualFormat, rightItemsVisualFormat);
	self.fieldConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:views];
	[self addConstraints:self.fieldConstraints];
	[self setNeedsDisplay:YES];
}

- (NSDictionary *)viewsFromArray:(NSArray *)views withBaseName:(NSString *)baseName
{
	__block NSMutableDictionary *result = NSMutableDictionary.new;
	[views enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL *stop) {
		result[[NSString stringWithFormat:@"%@%lu", baseName, idx]] = view;
	}];
	return [result copy];
}

- (NSString *)visualFormatFromArray:(NSArray *)views withBaseName:(NSString *)baseName
{
	__block NSMutableArray *items = NSMutableArray.new;
	[views enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL *stop) {
		[items addObject:[NSString stringWithFormat:@"[%@%lu]", baseName, idx]];
	}];
	NSString *result = [items componentsJoinedByString:@"-"];
	return  result.length ? [NSString stringWithFormat:@"-%@-", result] : @"-";
}

- (void)didPressEnter:(id)sender
{
	if (self.webView && [self validateUrl:self.urlTextField.stringValue])
	{
		[self.webView urlBar:self didRequestURL:[NSURL URLWithString:self.urlTextField.stringValue]];

		double delayInSeconds = .0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			NSText *fieldEditor = [self.urlTextField.window fieldEditor:YES forObject:self.urlTextField];
			fieldEditor.selectedRange = NSMakeRange(0, 0);
			[self.urlTextField.window makeFirstResponder:nil];
		});
	}
}

- (BOOL)validateUrl:(NSString *)candidate
{
	return YES;
}

- (CGFloat)barWidthForProtocol
{
	NSInteger protocolIndex = [self.urlTextField.stringValue rangeOfString:@"://"].location;
	if (protocolIndex == NSNotFound)
	{
		return 0;
	}
	NSString *measureString = [self.urlTextField.stringValue substringToIndex:protocolIndex + 3];
	CGFloat measuredSize = [measureString sizeWithAttributes:@{NSFontAttributeName:self.urlTextField.font}].width;
	return NSMinX([self.urlTextField frame]) + measuredSize;
}

- (void)drawRect:(NSRect)dirtyRect
{
	//// Color Declarations
	NSColor* fillColor = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
	NSColor* strokeColor = [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 0.2];
	NSColor* color = [NSColor colorWithCalibratedRed: 0.57 green: 0.57 blue: 0.57 alpha: 1];

	NSColor *color4;
	NSColor *color5;

	switch (self.progressPhase)
	{
		case KFProgPending:
			color4 = [NSColor colorWithCalibratedWhite:.8f alpha:.8f];
			color5 = [NSColor colorWithCalibratedWhite:.8f alpha:.4f];
			break;
		case KFProgDownloading:
			color4 = [NSColor colorForControlTint:[NSColor currentControlTint]];
			color5 = [[NSColor colorForControlTint:[NSColor currentControlTint]] colorWithAlphaComponent:.6f];
			color = [NSColor colorWithCalibratedRed: 0.45 green: 0.45 blue: 0.45 alpha: 1];
		default:
			break;
	}

	NSColor* color6 = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 0];

	NSGradient* progressGradient = [NSGradient.alloc initWithStartingColor: color5 endingColor: color4];

	//// Shadow Declarations
	NSShadow* shadow = NSShadow.new;
	[shadow setShadowColor: strokeColor];
	[shadow setShadowOffset: NSMakeSize(0.1, -1.1)];
	[shadow setShadowBlurRadius: 3];

	//// Frames
	NSRect frame = self.bounds;
	CGFloat barEnd = NSMaxX(self.urlTextField.frame);

	if ([self.rightItems count] > 0)
	{
		barEnd = NSMaxX([[self.rightItems lastObject] frame]) - 4;
	}


	if (self.drawBackground)
	{
		//// Background Drawing
		if (self.gradientColorTop && self.gradientColorBottom)
		{
			[[NSGradient.alloc initWithStartingColor:self.gradientColorTop endingColor:self.gradientColorBottom] drawInRect:self.bounds angle:-90.0];
		}

		[NSBezierPath setDefaultLineWidth:0.0f];

		if (self.borderColorTop)
		{
			[self.borderColorTop setStroke];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds)) toPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds))];
		}
	}

	if (self.borderColorBottom)
	{
		[self.borderColorBottom setStroke];

		[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds)) toPoint:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds))];
	}


	//// AddressBar Background Drawing
	NSBezierPath* addressBarBackgroundPath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(NSMinX(frame) + 8.5, NSMinY(frame) + 5.5, barEnd, NSHeight(frame) - 10) xRadius: self.cornerRadius yRadius: self.cornerRadius];
	[fillColor setFill];
	[addressBarBackgroundPath fill];
	[color setStroke];
	[addressBarBackgroundPath setLineWidth: 1];
	[addressBarBackgroundPath stroke];


	//// AddressBar Progress Drawing

	CGFloat barWidth = 0;
	switch (self.progressPhase)
	{
		case KFProgNone:
			barWidth = 0;
			break;
		case KFProgPending:
			barWidth = [self barWidthForProtocol];
			break;
		default:
			barWidth = MAX(barEnd * self.progress, [self barWidthForProtocol]);
			break;
	}

	if (barWidth > 0)
	{
		CGFloat addressBarProgressCornerRadius = self.cornerRadius;
		NSRect addressBarProgressRect = NSMakeRect(NSMinX(frame) + 8.5, NSMinY(frame) + 5.5, barWidth, NSHeight(frame) - 10);
		NSRect addressBarProgressInnerRect = NSInsetRect(addressBarProgressRect, addressBarProgressCornerRadius, addressBarProgressCornerRadius);
		NSBezierPath* addressBarProgressPath = [NSBezierPath bezierPath];
		[addressBarProgressPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(addressBarProgressInnerRect), NSMinY(addressBarProgressInnerRect)) radius: addressBarProgressCornerRadius startAngle: 180 endAngle: 270];
		[addressBarProgressPath lineToPoint: NSMakePoint(NSMaxX(addressBarProgressRect), NSMinY(addressBarProgressRect))];
		[addressBarProgressPath lineToPoint: NSMakePoint(NSMaxX(addressBarProgressRect), NSMaxY(addressBarProgressRect))];
		[addressBarProgressPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(addressBarProgressInnerRect), NSMaxY(addressBarProgressInnerRect)) radius: addressBarProgressCornerRadius startAngle: 90 endAngle: 180];
		[addressBarProgressPath closePath];
		[progressGradient drawInBezierPath: addressBarProgressPath angle: -90];
	}

	//// AddressBar Drawing


	NSBezierPath* addressBarPath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(NSMinX(frame) + 8.5, NSMinY(frame) + 5.5, barEnd, NSHeight(frame) - 10) xRadius: self.cornerRadius yRadius: self.cornerRadius];
	[color6 setFill];
	[addressBarPath fill];

	if (!addressBarPath.isEmpty)
	{
		////// AddressBar Inner Shadow
		NSRect addressBarBorderRect = NSInsetRect([addressBarPath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
		addressBarBorderRect = NSOffsetRect(addressBarBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
		addressBarBorderRect = NSInsetRect(NSUnionRect(addressBarBorderRect, [addressBarPath bounds]), -1, -3);

		NSBezierPath* addressBarNegativePath = [NSBezierPath bezierPathWithRect: addressBarBorderRect];
		[addressBarNegativePath appendBezierPath: addressBarPath];
		[addressBarNegativePath setWindingRule: NSEvenOddWindingRule];

		[NSGraphicsContext saveGraphicsState];
		{
			NSShadow* shadowWithOffset = [shadow copy];
			CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(addressBarBorderRect.size.width);
			CGFloat yOffset = shadowWithOffset.shadowOffset.height;
			shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
			[shadowWithOffset set];
			[[NSColor lightGrayColor] setFill];
			[addressBarPath addClip];
			NSAffineTransform* transform = [NSAffineTransform transform];
			[transform translateXBy: -round(addressBarBorderRect.size.width) yBy: 0];
			[[transform transformBezierPath: addressBarNegativePath] fill];
		}
		[NSGraphicsContext restoreGraphicsState];
	}

	[color setStroke];
	[addressBarPath setLineWidth: .5f];
	[addressBarPath stroke];
}


- (void)setProgress:(double)progress	{ if (progress == _progress) return;
	_progress = progress;	[self setNeedsDisplay:YES];
}

- (void)setProgressPhase:(KFProgPhase)progressPhase
{
	if (progressPhase != _progressPhase)
	{
		if (_progressPhase == KFProgDownloading && progressPhase == KFProgNone)
		{
			_progress = 1.0f;
			[self setNeedsDisplay:YES];
			double delayInSeconds = .2f;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
								{
									_progress = 0;
									_progressPhase = progressPhase;
									[self setNeedsDisplay:YES];
								});
		}
		else
		{
			_progressPhase = progressPhase;
			[self setNeedsDisplay:YES];
		}
	}
}

- (NSString *)addressString
{
	return self.urlTextField.stringValue;
}

- (void)setAddressString:(NSString *)addressString
{
	self.urlTextField.stringValue = addressString;
}

- (void)setLeftItems:(NSArray *)leftItems
{
	if (_leftItems != nil)
	{
		for (NSView *view in _leftItems)
		{
			if ([[view superview] isEqualTo:self])
			{
				[view removeFromSuperview];
			}
		}
	}
	_leftItems = leftItems;
	for (NSView *view in _leftItems)
	{
		[self addSubview:view];
		[self addConstraints:@[[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];
	}
	[self updateFieldConstraints];
}

- (void)setRightItems:(NSArray *)rightItems
{
	if (_rightItems != nil)
	{
		for (NSView *view in _rightItems)
		{
			if ([[view superview] isEqualTo:self])
			{
				[view removeFromSuperview];
			}
		}
	}
	_rightItems = rightItems;
	for (NSView *view in _rightItems)
	{
		[self addSubview:view];
		[self addConstraints:@[[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];
	}
	[self updateFieldConstraints];
}

@end

@interface AZURLFormatter ()
@property (nonatomic, strong) NSCharacterSet *urlCharacterSet;
@end

@implementation AZURLFormatter

- (id)init
{
	self = [super init];
	if (self)
	{
		NSMutableCharacterSet *urlCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"-._~:/?#[]@!$&'()*+,;="];
		[urlCharacterSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
		self.urlCharacterSet = urlCharacterSet;
	}
	return self;
}

- (BOOL)isPartialStringValid:(NSString *__autoreleasing *)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString *__autoreleasing *)error
{
	NSString *partial = (NSString *)*partialStringPtr;
	if (origString.length > partial.length)
	{
		return YES;
	}
	NSRange newPartRange = NSMakeRange(origString.length, partial.length - origString.length);
	NSString *newString = [partial substringWithRange:newPartRange];

	NSCharacterSet *inverted = [self.urlCharacterSet invertedSet];
	return [newString rangeOfCharacterFromSet:inverted].location == NSNotFound;
}


- (NSString *)stringForObjectValue:(id)object
{
	if (![object isKindOfClass:[NSString class]])
	{
		return nil;
	}
	return (NSString *)object;
}
- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error
{
	*object = string;
	return YES;
}

@end

//@interface AZWebKitProgressController ()
//@property (nonatomic) NSInteger resourceCount, resourceFailedCount, resourceCompletedCount;
//@end

/*
 @implementation AZWebKitProgressController
 - (id)init
 {
 self = [super init];
 if (self)
 {
 _resourceCount = 0;
 _resourceCompletedCount = 0;
 _resourceFailedCount = 0;
 }
 return self;
 }


 - (void)updateResourceStatus
 {
 if ([self.delegate respondsToSelector:@selector(webKitProgressDidChangeFinishedCount:ofTotalCount:)])
 {
 [self.delegate webKitProgressDidChangeFinishedCount:(self.resourceCompletedCount + self.resourceFailedCount) ofTotalCount:self.resourceCount];
 }
 else
 {
 NSLog(@"progress: %lu of %lu", (self.resourceCompletedCount + self.resourceFailedCount), self.resourceCount);
 }
 }


 - (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
 {
 if (frame == [sender mainFrame])
 {
 [[sender window] setTitle:title];
 }
 }


 - (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource
 {
 return @(self.resourceCount++);
 }


 -(NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
 {
 [self updateResourceStatus];
 return request;
 }


 -(void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource
 {
 self.resourceFailedCount++;
 [self updateResourceStatus];
 }


 -(void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource
 {
 self.resourceCompletedCount++;
 [self updateResourceStatus];
 }

 @end
 */
