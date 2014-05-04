
#import "TUIVVC.h"

@interface TUIVVC ()
@property TUIButton 		*button, *removeButton;
@property BOOL 			collapsed;
@property (NATOM) NSMA 	*vertObjects,  *horizObjects;
@end

@implementation TUIVVC
@synthesize button, removeButton, collapsed, containerView;

- (id)initWithNibName:(NSS*)name bundle:(NSB*)nib	{	return self = self = [super initWithNibName:name bundle:nib];	 }

- (void) wakeFromNib										 	{

//	[self clearFaviconCache:nil];
	CGRect b 						= containerView.frame;
	containerView.rootView  	= self.rootView = [TUIView.alloc initWithFrame:b];
	_rootView.backgroundColor 	= LINEN;
	b.origin.y 	  					= b.size.height - 40;
	b.size.height 					= 40;
	_horizontalLayout				= [AHLayout.alloc initWithFrame:b];
	_rootView.subviews 					= @[_horizontalLayout];
	_horizontalLayout.bgC				= LINEN;
	_horizontalLayout.typeOfLayout 	= AZOrientHorizontal;
	_horizontalLayout.arMASK 		 	= TUIViewAutoresizingFlexibleBottomMargin | 
												  TUIViewAutoresizingFlexibleWidth;
	_horizontalLayout.dataSource 		  = self;
	_horizontalLayout.clipsToBounds	 = YES;
	_horizontalLayout.spaceBetweenViews = 0;
	_horizontalLayout.viewClass 			= AZExpandableView.class;
//	_horizontalLayout.reloadHandler 		= self.reloadHandler;

	_horizObjects = [NSS.testDomains  cw_mapArray:^id(NSS* obj) {	return @{	
								@"name" : obj,
								@"color": RANDOMGRAY,
								@"url": [obj urlified] }.mutableCopy;
						}].mutableCopy;

	[_horizontalLayout reloadData];
}

//	[NSEVENTLOCALMASK: NSLeftMouseDownMask handler:^NSEvent *(NSEvent *e){
//		NSLog(@"visible that need help %@", [[
//		[self.visibleViews filter:^BOOL(AZExpandableView* o ){if (!o.faviconOK) { o.favicon = nil;  return  YES; } return NO;	}] valueForKeyPath:@"dictionary"]valueForKeyPath:@"name"]);
//		return e;
//	}];
//			[self willChangeValueForKey:@"visibleViews"];
//			[self didChangeValueForKey:@"visibleViews"];
//		return e;
//	}];
//	[_horizontalLayout addObserverForKeyPath:@"visibleViews" task:^(id obj, NSDictionary *change) {
//		NSLog(@"Poop %@", [obj visibleViews]);	
//	}];
//	[_horizontalLayout observeName:@"visibleViews" usingBlock:^(NSNotification *n) {
//		NSLog(@"They changed!");
//	}];

- (NSA*) visibleViews {  return _horizontalLayout.visibleViews; }

- (AHLayoutHandler) reloadHandler 
{
	return ^(AHLayout* a) {	NSLog(@"rezhuzhingReload:%@",	
										[a.visibleViews cw_mapArray:^id(AZExpandableView *x) {// = (AZExpandableView*)[a viewForIndex:];
											NSMD* d = x.dictionary;
											BOOL isOk = [[(NSIMG*)d[@"favicon"] name]endsWith:d[@"name"]];
											if (!isOk) 
												[AZFavIconManager iconForURL:d[@"url"] downloadHandler:^(NSImage *icon) {
														d[@"favicon"] = icon;   if ( [_horizontalLayout.visibleViews containsObject:x] ) [x redraw]; 
												}];
											return isOk ? nil : d[@"name"];
										}]);
	};
}											

#pragma mark - AHLayoutDataSource methods
- (TUIV*) layout:(AHLayout *)layout objectAtIndex:(NSInteger)index {
	AZExpandableView *v;
	v = [v = (AZExpandableView*) _horizontalLayout.dequeueReusableView initWithFrame:NSZeroRect];
	v.dictionary =  [_horizObjects normal:index];
	return v;  // I just cloned this from below to shutup compiler
}
- (TUIV*) layout:(AHLayout*)l viewForIndex:(NSI)index			{
	AZExpandableView *v = (AZExpandableView*) _horizontalLayout.dequeueReusableView;
	v = [v initWithFrame:NSZeroRect];
	v.dictionary =  [_horizObjects normal:index];
	return v;
}
- (NSUI)numberOfViewsInLayout:(AHLayout*)l 						{ 	return _horizObjects.count;	}
- (CGS) layout:(AHLayout*)l sizeOfViewAtIndex:(NSUI)index 	{	
	NSAS* vString 	= [(AZExpandableView*)[_horizontalLayout viewForIndex:index]attrString];
	CGF wideness 	= [vString widthForHeight:40];
	return (CGS) { wideness * 1.6, 40 };//l == _verticalLayout ? CGSizeMake(_window.width, 100) : CGSizeMake(100, 100);
}

- (IBAction)clearFaviconCache:(id)s { 

	[AZFavIconManager.sharedInstance clearCache];
	if (_horizObjects.count) [_horizObjects each:^(NSMD* ds) { [ds removeObjectForKey:@"favicon"]; }];
}

@end
	