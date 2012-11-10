//
//  ContentsView.h
//  CoreAnimationToggleLayer
//
//  Created by Tomaz Kragelj on 8.12.09.
//  Copyright (C) 2009 Gentle Bytes. All rights reserved.

/** The view that serves as Core Animation host.
 	The user interface is composed using Core Animation layers using the following structure:
 
	@verbatim
	CALayer (root)
	|
	+--> CALayer (container)
		|
		+--> CALayer ("item name")
			|
			+--> CATextLayer (name)
			+--> ToggleLayer (toggle)
	@endverbatim
 
	The view also responds to user's interaction (only mouse is handled in this example) and updates the toggle status when the layer is clicked.

*/
/*
USAGE;
-(NSDictionary*) toggleForView:(AZToggleArrayView*)view atIndex:(NSUInteger)index;
{
	return 	index == 0 ? @{ AZToggleLabel : @"Grid"}    :
	index == 1 ? @{ AZToggleLabel : @"Fiesta", AZToggleOn : @"FoN", AZToggleOff : @"FoFF"}  :
	index == 2 ? @{ AZToggleLabel : @"Fiesta"}  :
	@{ AZToggleLabel : @"Fiesta"}	;
}

-(NSUInteger) toggleCountforView:(AZToggleArrayView*) view	{	return 4;	}

 - (NSA*)itemsForToggleView:(AZToggleArrayView *)view {
 //	return 	@[///	[view itemTextLayerWithName:@"Sort:" ],
 //	[view itemLayerWithName:	@"Orient" relativeTo:@"superlayer" index:0],
 //	[view itemLayerWithName:	@"Top" relativeTo:@"Orient" 	index:1]	];
 }

- (void)toggleStateDidChangeTo:(BOOL)state InToggleViewArray:(AZToggleArrayView *) view WithName:(NSString *)name{
	NSDictionary *action = @{

	@"toggle0" : ^{	self.orient = _orient == AZOrientGrid ? AZOrientPerimeter : AZOrientGrid; [_content shuffle]; 			},
	@"toggle1" : ^{	[_content do:^(AZGridTransformCell* obj) {	state ? [obj.front fadeOut] : [obj.front fadeIn]; 	}];		},
	@"toggle2" : ^{	[_content do:^(AZGridTransformCell* obj) { 	state ? [obj.back fadeOut] : [obj.back fadeIn];  	}];		},
	@"toggle4" : ^{	[_content do:^(AZGridTransformCell* obj) {	obj.hidden = obj.hidden ? NO : YES;					}]; 	} 	};
	((void (^)()) [action objectForKey:name] )();		[_root setNeedsLayout];
}

*/

extern NSString *const AZToggleLabel;
extern NSString *const AZToggleRel;
extern NSString *const AZToggleOff;
extern NSString *const AZToggleOn;
extern NSString *const AZToggleState;
@class  	AZToggleControlLayer;//, AZToggle;
@protocol 	AZToggleArrayViewDelegate;
@interface 	AZToggleArrayView : NSView
//	@private
//	id<AZToggleArrayViewDelegate> __ah_weak _delegate;
- (CALayer*) 				itemLayerWithName:(NSString*)name		relativeTo:(NSString*)relative
									   onText:(NSString*)onText	   	   offText:(NSString*)offText
										state:(BOOL)state				 index:(NSUInteger)index
							  labelPositioned:(AZWindowPosition)position;
- (CALayer*) 				  itemLayerWithName:(NSString*)name 	relativeTo:(NSString*)relative
							  			 onText:(NSString*)onText      offText:(NSString*)offText
							   			  state:(BOOL)state 			 index:(NSUInteger)index;
- (AZToggleControlLayer*) toggleLayerWithOnText:(NSString*)onText		offText:(NSString*)offText
																   initialState:(BOOL)state;

- (CATextLayer*) 		  itemTextLayerWithName:(NSString*)name;

- (CALayer*) 				  itemLayerWithName:(NSString*)name		 relativeTo:(NSString*)relative
							   											  index:(NSUInteger)index;

@property (RONLY) CALayer* containerLayer;
@property (RONLY) CALayer* rootLayer;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, ah_weak) IBOutlet id<AZToggleArrayViewDelegate> delegate;
@end

@protocol AZToggleArrayViewDelegate <NSObject>
@required

- (NSA*)  questionsForToggleView: (AZToggleArrayView *) view;
/* 	return 	@[@"Sort Alphabetically?", @"Sort By Color?" , @"Sort like Dock", @"Sort by \"Category\"?", @"Show extra app info?" ]; */

@optional

- (NSString*) toggleView: (AZToggleArrayView*) toggleView questionAtIndex: (NSUInteger) index;
/*	return  index == 1 ? @"What?" : @"How?";		*/

- (NSInteger) numberOfTogglesInView: (AZToggleArrayView*)view;
/*	return  _questions.count; etc		*/

@optional

-(NSDictionary*)toggleForView:(AZToggleArrayView*)view atIndex:(NSUInteger)index;
-(NSUInteger) toggleCountforView:(AZToggleArrayView*) view;
- (AZWindowPosition) positionForQuestion: (NSString*) question;
//- (AZWindowPosition) defaultLabelPosition;

- (NSA*) itemsForToggleView: (AZToggleArrayView*) view;

/*	return 	@[	[view itemTextLayerWithName:@"Sort:" ],
				[view itemLayerWithName:	@"Color" relativeTo:@"superlayer" index:0],
 				[view itemLayerWithName:	@"A-Z" relativeTo:@"Color" 	index:1]	]; 		*/


//- (NSA*) itemsForToggleView: (AZToggleArrayView*) view positioned: (AZWindowPosition) position;
- (void)toggleStateDidChangeTo: (BOOL) state InToggleViewArray: (AZToggleArrayView*) view WithName:(NSString *)name;

@end

/*  return @[[ itemLayerWithName:@"Item 2" relativeTo:index:1]];
	[containerLayer addSublayer:[self itemLayerWithName:@"Click these 'buttons' to change state ->"
											 relativeTo:@"Item 2"
												 onText:@"1"
												offText:@"0"
												  state:YES
												  index:1]];
*/

/**	Implements iPhone-like Core Animation toggle layer.

	The client can change the texts and toggle state. There's also a helper method that reverses the state that can be handy in certain situations.		The layer uses the following layout:

	@verbatim
	CALayer (root)
	|
	+--> CALayer (onback)
	|    |
	|    +--> CATextLayer (text)
	|
	+--> CALayer (thumb)
	|
	+--> CALayer (offback)
	|
	+--> CATextLayer (text)
	@endverbatim																		*/

@interface AZToggleControlLayer : CALayer
{
	CALayer* thumbLayer;
	CALayer* onBackLayer;
	CALayer* offBackLayer;
	CATextLayer* onTextLayer;
	CATextLayer* offTextLayer;
	NSGradient* onBackGradient;
	NSGradient* offBackGradient;
	BOOL toggleState;
}

//////////////////////////////////////////////////////////////////////////////////////////
/// @name State handling
//////////////////////////////////////////////////////////////////////////////////////////

/** Toggles the state from on to off or vice versa.		 @see toggleState;			*/
- (void) reverseToggleState;

/** Sets the toggle state.	 							@see reverseToggleState;	*/
@property (assign) BOOL toggleState;

/** On state text.										@see offStateText;			*/
@property (copy) NSString* onStateText;

/** Off state text.									 	@see onStateText;			*/
@property (copy) NSString* offStateText;
@end

	//@interface AZToggle : BaseModel
	//@property (nonatomic, retain) NSString *name;
	//@property (nonatomic, retain) NSString *relative;
	//@property (nonatomic, retain) NSString *onText;
	//@property (nonatomic, retain) NSString *offText;
	//@property (nonatomic, assign) BOOL toggleState;
	//+ (AZToggle*) instanceWithObject:(id)object;
	//@end;

