//
//  TUIV.m
//  AtoZ
//
//  Created by Alex Gray on 4/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "TUIVVC.h"
#import <AtoZ/AtoZ.h>
#import <AtoZ/AZExpandableView.h>
#import <AtoZ/AHLayout.h>

@interface TUIVVC ()

@property TUIButton *button, *removeButton;
@property BOOL collapsed;
@property (NATOM) NSMA *vertObjects,  *horizObjects;
@end

@implementation TUIVVC
@synthesize button, removeButton, collapsed, containerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return self = self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)awakeFromNib
{
	CGRect b = containerView.frame;
	containerView.rootView  		= self.rootView = [TUIView.alloc initWithFrame:b];
	_rootView.backgroundColor 	= LINEN;
	b.origin.y 	  					= b.size.height - 100;
	b.size.height 					= 100;
	_horizontalLayout				= [AHLayout.alloc initWithFrame:b];
	_rootView.subviews 			= @[_horizontalLayout];
	_horizontalLayout.typeOfLayout 		= AHLayoutHorizontal;
	_horizontalLayout.bgC				 		= LINEN;
	_horizontalLayout.arMASK 		 		= TUIViewAutoresizingFlexibleBottomMargin | 
													  TUIViewAutoresizingFlexibleWidth;
	_horizontalLayout.dataSource 	      = self;
	_horizontalLayout.clipsToBounds     = YES;
	_horizontalLayout.spaceBetweenViews = 0;
	_horizontalLayout.viewClass 			= AZExpandableView.class;

	[_horizontalLayout reloadData];
//	[NSEVENTLOCALMASK: NSScrollWheelMask handler:^NSEvent *(NSEvent *e){
////		NSLog(@"visible %@", self.visibleViews);#import <AtoZ/AtoZ.h>
//			[self willChangeValueForKey:@"visibleViews"];
//			[self didChangeValueForKey:@"visibleViews"];
//		return e;
//	}];
//	[_horizontalLayout addObserverForKeyPath:@"visibleViews" task:^(id obj, NSDictionary *change) {
//		NSLog(@"Poop %@", [obj visibleViews]);	
//	}];
//	
//	[_horizontalLayout observeName:@"visibleViews" usingBlock:^(NSNotification *n) {
//		NSLog(@"They changed!");
//	}];
}

- (NSA*) visibleViews { 
	
	NSA* vs = _horizontalLayout.visibleViews; 
								LOGWARN(@"%@", vs);
								return vs;
}

- (NSA*) horizObjects {
	return _horizObjects = _horizObjects ?: [[NSC.randomPalette withMinItems:199] map:^id(id obj) {		
		return @{@"color": @{ 	@"name" : [obj nameOfColor], 
										@"color": obj, 
										@"url": NSS.testDomains.randomElement } }; }].mutableCopy;
}

#pragma mark - AHLayoutDataSource methods

- (TUIV*) layout:(AHLayout*)l viewForIndex:(NSI)index	
{
	AZExpandableView *v = (AZExpandableView*) _horizontalLayout.dequeueReusableView;
	v.dictionary = _horizObjects[index];
	return v;
}
- (NSUI)numberOfViewsInLayout:(AHLayout*)l 
{ 	
	return self.horizObjects.count;
	// l == _verticalLayout ? _vertObjects.count	: _horizObjects.count;
}
- (CGS) layout:(AHLayout*)l sizeOfViewAtIndex:(NSUI)index 
{	
	return  CGSizeMake(100, 100);//l == _verticalLayout ? CGSizeMake(_window.width, 100) : CGSizeMake(100, 100);
}

@end
