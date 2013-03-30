#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>


int main ()	{
@autoreleasepool {		[NSApplication sharedApplication];
							[NSApp setActivationPolicy:0];
	id menubar, appMenuItm, appMenu, appName, quitTitle, quitMenuItm, window;
	menubar 		= NSMenu.new;
	appMenu 		= NSMenu.new;
	appMenuItm 	= NSMenuItem.new;
	appName 		= [NSProcessInfo.processInfo processName];
	quitTitle 	= [@"Quit " withString:appName];
	quitMenuItm = [NSMenuItem.alloc initWithTitle:quitTitle 				                          action:@selector(terminate:) 										keyEquivalent:@"q"];
	window = [NSWindow.alloc initWithContentRect:NSMakeRect(0, 0, 200, 200)
												styleMask:1|8 backing:0 defer:NO];
												
	[menubar	addItem:appMenuItm];	
	[NSApp setMainMenu:menubar];
	[appMenu 	addItem:quitMenuItm];
//	[window  setBackgroundColor:RANDOMCOLOR];
	[appMenuItm setSubmenu:appMenu];
	[NSApp 	activateIgnoringOtherApps:YES];
	[window 	makeKeyAndOrderFront:nil];
	
	
	
	
//	NSC *u = GREEN;
//	NSC *i = u.copy;
//	AZLOG(AZString(cgGREEN));
//	AZLOG($(@"%s",@encode(  CGCR)));
//	AZLOG($(@"%s",@encode(  CGF)));
	
//	AZLOG(AZString(NSResizableWindowMask));
	
//	CAL*l = [CAL layer];
//	l.bgC = cgRED;
//	AddShadow(l);
//	[NSEVENTLOCALMASK:NSLeftMouseDownMask handler:^(NSE*e){  static BOOL yea = NO;
//		[l flipForward: yea  atPosition:RAND_INT_VAL(0,3)];
//		yea =! yea;
//	return e;
//}];

//	NSA* limitedD 	  = [[l.class uncodableKeys] filter:^BOOL(id object) { 
//		return [l canSetValueForKey:object];
//	}];
//	NSView *v = [NSV.alloc initWithFrame:AZRectFromDim(60)];
//	AZLOG([l propertiesPlease]);
//	AZLOG([[l.class uncodableKeys]arrayWithoutArray: limitedD]);

NSR winR = [[window contentView] frame];

static NSA* a = nil;
a = NSC.randomPalette;



BNRBlockView* b = [BNRBlockView viewWithFrame:winR opaque:YES drawnUsingBlock:^(BNRBlockView* view, NSR dirtyRect) {
		
		NSRectFillWithColor(dirtyRect,BLACK);
		AZSizer *sizer = [AZSizer forObjects:a withFrame:dirtyRect arranged:AZOrientPerimeter];
//		AZSizer *sizer	= [AZSizer forQuantity:RAND_INT_VAL(44,99) 						inRect:dirtyRect];
		[sizer.rects eachWithIndex:^(id obj, NSI idx) {
					
		NSRectFillWithColor([obj rectValue], [a normal:idx]);
		}];
	}];
	
b.arMASK = NSSIZEABLE;
[b observeFrameChangeUsingBlock:^{ [b setNeedsDisplay:YES]; }];
[[window contentView] addSubview:b];
	
//	setLayer: l];
//
//	AZLOG(AZString(l.frameMidY));
//
//	[[window contentView] setWantsLayer:YES];
//	
//	CAL*m = [CAL layerWithFrame: quadrant ([window frame],1)];
//	m.bgC = cgGREEN;
//	
//	CAL* n = [m copyLayer];
//	AZLOG(n.bgC);
//	n.frameMidX = quadrant([window frame], 3).origin.x;
//	n.bgC = cgPURPLE;
//	
//	LOG_EXPR((@[AZString(m.frame), AZString(n.frame)]));
//	l.sublayers = @[m, n];
		
	
	
	
	
	
	
	
	[NSApp run];
	}
return 0;
}