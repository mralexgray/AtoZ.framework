//
//  PPNavigationController.m
//  PushPopTest
//
//  Created by Josh Abernathy on 7/3/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "AtoZ.h"
#import "AZProportionalSegmentController.h"
static NSI 	masterCt = 0;
static id 	drawer = nil;

@implementation AZProportionalSegmentController
/*
- (NSM*) menuForEvent:(NSEvent *)event {  [super menuForEvent:event];
	NSLog(@"event type:  %@", event);
	if ([event type] == NSRightMouseDown && [self.datasource respondsToSelector:@selector(menuForRightClick)])
	return [self.datasource menuForRightClick];
}
*/
- (void) loadView 				{	[super loadView];
	self.view 						= [TUIView.alloc initWithFrame:CGRectZero];
	self.view.autoresizingMask = TUIViewAutoresizingFlexibleSize;
	self.view.backgroundColor 	= NSColor.blackColor;
}
- (void) mouseUp:    (NSE*)e 	{		[super mouseUp:e];
	NSLog(@"MouseUp in proportioanl controller!");
}
- (void) keyDown:    (NSE*)e	{

	[super keyDown:e];
	id last = self.controllers.lastObject;
	NSLog(@"last: %@ event: %@", last, e);
	[(NSV*)last mouseDown:e];

}
- (void) eventHandlers 			{

	[NSEVENTLOCALMASK: NSLeftMouseUpMask handler:^NSEvent *(NSEvent *e) {
		if ([e clickCount] == 2) 	[self insertVC];
		if ([e clickCount] == 3) {  self.maxVisible--;	[self popViewControllerAnimated:YES];		}
		return e;
	}];						//		rootVC.view.frame = self.view.bounds;

}
-   (id) initInView: (NSV*)view withDataSource:(id<AZProportionalSegmentViewDatasource>)ds {

	if (!(self = super.init)) return nil;

	 _datasource = ds;	_controllers = NSMA.new; _cache = NSMA.new;	_maxVisible = 3;
			drawer = ds;

	TUINSView *tuiHost; [view addSubview: tuiHost 			 = [TUINSView.alloc initWithFrame:view.frame]];	tuiHost.arMASK = NSSIZEABLE;
													  tuiHost.rootView = self.view;

	[[view window] makeFirstResponder:view];	[self eventHandlers];	return self;
}

- (id)insertVC 															{

	AZPSV *rootVC = AZPSV.new;	rootVC.color = BLACK;
	rootVC.parentViewController = self;	rootVC.view.tag = masterCt;	masterCt++;
	[self pushViewController:rootVC animated:YES];
	return rootVC;
}
- (void) pushViewController:(TUIVC*)vC animated:(BOOL)ani 	{

	BOOL willPurge = _controllers.count > self.maxVisible;  TUIVC *oldTopVC;

	if (willPurge) {		[self.cache addObject:oldTopVC = self.controllers.pull];	[oldTopVC viewWillDisappear:ani];	}

	[vC viewWillAppear:ani];				[self.controllers addObject:vC];
	vC.parentViewController = self;		[self.view 	addSubview:vC.view];

	AZTUICompletionBlock done = ^(BOOL finished) {

		if (willPurge) {	[oldTopVC.view removeFromSuperview];	[oldTopVC viewDidDisappear:ani];	}
//	if (willPurge)  { [oldTopVC.view.layer animateToColor:WHITE];							[vC viewDidAppear:ani];
								[AZTalker say:$(@"Controllers:%ld Cache: %ld", _controllers.count, _cache.count)];
	};
	if(!ani) { done(YES); return; }
// We need to force a flush so that the view's frame is set to the far right before we animate.
//	Otherwise CA will put this off until the end of the runloop and won't bother animating.
	[CATransaction flushBlock:^{			NSR newframe = [self frameAtIndex:_maxVisible];
													newframe.origin.x = self.view.size.width;
													vC.view.frame =   newframe;
	}];
	[TUIView animateWithDuration:0.27f animations:^{	[self.controllers eachWithIndex:^(AZPSV* obj, NSI idx) {

			[obj setDatasource: self.datasource];
			obj.index = idx-1; 									NSR newframe;
			obj.view.frame = newframe = [self frameAtIndex:obj.index];
			NSLog(@"deleagte here?: %@   object at index : %ld, frame: %@",self.datasource, idx, AZStringFromRect(newframe));
		}];
	} completion:done];
//	 }//	oldTopVC.view.alpha = 0.0f; 	}
//			[vC.view.layer setValue:@(DEG2RAD(360)) forKey:@"transform.rotation.y"];	vC.view.frame = self.view.bounds;
}

- (void) popViewControllerAnimated:					(BOOL)ani	{	NSAssert(self.controllers.count > 1, @"Trying to pop the root view controller. Ain't gonna happen.");

	// we'll release him later on in the completion block
	__weak __block TUIViewController *oldTopVC = _controllers.pull;
	TUIViewController *__unused newTopVC = self.controllers.last;
	[oldTopVC viewWillDisappear:ani];
//	[_controllers removeLastObject];	newTopVC.view.frame = self.view.bounds;[newTopVC viewWillAppear:ani];[self.view insertSubview:newTopVC.view belowSubview:oldTopVC.view];

	AZTUICompletionBlock __unused done = ^(BOOL finished) {
																[oldTopVC.view removeFromSuperview];
																[oldTopVC     viewDidDisappear:ani];
//																[newTopVC        viewDidAppear:ani];
//																[oldTopVC release],  oldTopVC = nil;
	};
//	if(ani) {	//newTopVC.view.alpha = 0.0f;
//					[TUIView animateWithDuration:0.2f animations:^{
//					oldTopVC.view.frame = CGRectMake(self.view.width, 0.0f, oldTopVC.view.width, oldTopVC.view.height);
//					newTopVC.view.alpha = 1.0f;
//	} completion:done];									} else done(YES);
}
- (void) toggleBannerWithText:(NSS*)string; 						{   static  BOOL bannerIsShowing;

	if (!_banner) {			bannerIsShowing = NO;
		_banner = AZPSV.new;
		_banner.view.frame = (NSR){0,0,((NSView*)self.view).width, self.bannerHeight};
	}
}

-  (NSR) frameAtIndex:		 (NSI)index 							{	CGF offsetter = ((NSView*)self.view).width/MIN(self.controllers.count,_maxVisible);
	NSR ther = (NSR){offsetter * index,0,offsetter, self.view.height};
	if (_controllers.count <= _maxVisible ) ther.origin.x += offsetter;  return ther;
}

@end
@implementation AZProportionalSegmentView
- (void) loadView 										{	[super loadView];
	self.view = [TUIView.alloc initWithFrame:CGRectZero];
	self.view.autoresizingMask = TUIViewAutoresizingFlexibleBottomMargin;	//	TUIViewAutoresizingFlexibleSize;
}
- (void) viewDidLoad 									{	[super viewDidLoad];		/*	self.uid = [[NSS newUniqueIdentifier] substringFromIndex:0 length:3];
	self.textRenderer = TUITextRenderer.new;
	self.view.textRenderers = @[self.textRenderer];
	NSLog(@"selfparent: %@  selfnavig:%@", self.parentViewController, self.navigationController);
	AZProportionalSegmentController *p = (AZProportionalSegmentController*)self.parentViewController;
	BOOL doesit = [p.datasource respondsToSelector:@selector(drawBlockForView:)];
*/

	BOOL doesit = [drawer respondsToSelector: @selector( drawBlockForView:)];
	COLORLOG(PURPLE, @"drawer:%@...  tag:%ld, responds to: %@", drawer, self.view.tag, StringFromBOOL(doesit));
 	if (doesit) self.view.drawRect  = [drawer drawBlockForView:self];
	else {
		__weak AZProportionalSegmentView *blockSelf = self;
		self.view.drawRect  =		^(TUIView *blockView, CGRect dirtyRect) {
			NSRectFillWithColor(blockView.bounds, WHITE);
			NSRectFillWithColor(NSInsetRect(blockView.bounds, 5.0f, 5.0f), blockSelf.color);
			blockSelf.textRenderer.frame = blockView.bounds;  //NSMakeRect(20.0f, 50.0f, blockView.bounds.size.width, 30.0f);
			/* NSStringFromPoint([blockSelf.view localPointForLocationInWindow: blockSelf.view.frame.origin])()];*/
			blockSelf.textRenderer.attributedString = [blockSelf attributed:$(@"%ld\n%@", blockSelf.index, blockSelf.uid)];
			[blockSelf.textRenderer draw];
		};
	}
}
- (void) setIndex: (NSI)index 						{ _index = index;	[self.view setNeedsDisplay];	}
- (void) mouseDown:(NSE*)e 							{

	AZProportionalSegmentController *navigationController = (AZProportionalSegmentController *) self.parentViewController;
	AZProportionalSegmentView *n = self.class.new;		n.color = RANDOMCOLOR;	masterCt++;
	[navigationController pushViewController:n animated:YES];  // this all seems important.

//	AZSegment *i = AZSegment.new;	n.view = i;
//	[navigationController popViewControllerAnimated:YES];
}
- (TUIAttributedString*) attributed:(NSS*)s 		{	TUIAttributedString *as = [TUIAttributedString stringWithString:s];
	[as setFont:[AtoZ.controlFont fontWithSize:66]];
	[as setColor:self.color.contrastingForegroundColor];		return as;
}
@end

@implementation  AZSegment
- (NSM*) menuForEvent:(NSEvent *)event {

	__block NSM *menu = NSMenu.new;	[@{	@"Insert Above" : @"insertObject", @"Insert Below":@"insertObjectBelow",
												 @"Insert at top": @"prepend",		  		 @"Remove" : @"remove:",
												 @"Toggle Expand To Fill" : @"toggleExpanded" } each:^(id k, id v)  {
													 NSMI *i = [NSMI.alloc initWithTitle:NSLocalizedString(k, nil)
																							action:NSSelectorFromString(v)
																				  keyEquivalent:@""];  i.target = self;  [menu addItem:i];	 }]; return menu;
}
@end

//-   (id)  initInView:  		 (NSV*)view  							{ return  [self initInView:view withDataSource:nil]; }
/*	[self.controllers each:^(id obj) { [[(AZPSV*)obj view] setNeedsDisplay]; }];
 NSRightMouseDown && [self.datasource respondsToSelector:@selector(menuForRightClick)]) {	[self.view setMenu: [self.datasource menuForRightClick]];	}
 NSLog(@"trying with handler"); [self keyDown:e];
 */
