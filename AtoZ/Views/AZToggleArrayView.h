

//  ContentsView.h
//  CoreAnimationToggleLayer
//  Created by Tomaz Kragelj on 8.12.09.
//  Copyright (C) 2009 Gentle Bytes. All rights reserved.

/*	Implements iPhone-like Core Animation toggle layer.
	The client can change the texts and toggle state. There's also a helper method that reverses the state that can be handy in certain situations.		The layer uses the following layout:
	
	@verbatim
	CALayer (root)
	|
	+--> CALayer (onback)
	|	|
	|	+--> CATextLayer (text)
	|
	+--> CALayer (thumb)
	|
	+--> CALayer (offback)
	|
	+--> CATextLayer (text)
	@endverbatim																		*/

@interface AZToggleControlLayer : CALayer
@property (NATOM,STRNG)	NSG		*onBackGradient, 	*offBackGradient;
@property (CP) 			NSS		*onStateText, 		*offStateText;
@property (NATOM,ASS)		BOOL 		toggleState;

+ (AZToggleControlLayer*)toggleWithOn:(NSS*)on off:(NSS*)off;

/** Toggles the state from on to off or vice versa.		 @see toggleState;			*/
- (void) reverseToggleState;
@end


/** The view that serves as Core Animation host.  The user interface is composed using Core Animation layers using the following structure:
 
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

USAGE;

-(NSD*) toggleForView:(AZToggleArrayView*)view atIndex:(NSUInteger)index;
{
	return 	index == 0 ? @{ AZToggleLabel : @"Grid"}	:
				index == 1 ? @{ AZToggleLabel : @"Fiesta", AZToggleOn : @"FoN", AZToggleOff : @"FoFF"}  :
				index == 2 ? @{ AZToggleLabel : @"Fiesta"}  :	@{ AZToggleLabel : @"Fiesta"}	;
}

-(NSUInteger) toggleCountforView:(AZToggleArrayView*) view	{	return 4;	}

 - (NSA*)itemsForToggleView:(AZToggleArrayView *)view {
 //	return 	@[///	[view itemTextLayerWithName:@"Sort:" ],
 //	[view itemLayerWithName:	@"Orient" relativeTo:@"superlayer" index:0],
 //	[view itemLayerWithName:	@"Top" relativeTo:@"Orient" 	index:1]	];
 }

- (void)toggleStateDidChangeTo:(BOOL)state InToggleViewArray:(AZToggleArrayView *) view WithName:(NSString *)name{
	NSDictionary *action = @{

	@"toggle0" : ^{		self.orient = _orient == AZOrientGrid ? AZOrientPerimeter : AZOrientGrid; [_content shuffle]; 			   	   },
	@"toggle1" : ^{		[_content do:^(AZGridTransformCell* obj) { state ? [obj.front fadeOut] : [obj.front fadeIn]; }];			   },
	@"toggle2" : ^{		[_content do:^(AZGridTransformCell* obj) { state ? [obj.back fadeOut] : [obj.back fadeIn];  	}];			  },
	@"toggle4" : ^{	[_content do:^(AZGridTransformCell* obj) {	obj.hidden = obj.hidden ? NO : YES;					}]; 	} 	};
	((void (^)()) [action objectForKey:name] )();		[_root setNeedsLayout];
}
*/

#define AZTCL  AZToggleControlLayer
#define AZTCVD AZToggleArrayViewDelegate
#define AZTCV  AZToggleArrayView

extern NSS *const AZToggleLabel;
extern NSS *const AZToggleRel;
extern NSS *const AZToggleOff;
extern NSS *const AZToggleOn;
extern NSS *const AZToggleState;

@class AZToggleArrayView;
@protocol AZToggleArrayViewDatasource <NSObject>
@required
- (NSUI)  				toggleCountForView:(AZToggleArrayView*)view;
- (AZOrient)		toggleOrientationForView:(AZToggleArrayView*)view;
- (AZToggleControlLayer*) toggleForView:(AZToggleArrayView*)view atIndex:(NSUI)index;
@optional
- (NSS*) 					toggleLabelForView:(AZToggleArrayView*)view atIndex:(NSUI)index;
@end
@class AZToggleArrayView;
@protocol AZToggleArrayViewDelegate <NSObject>
@optional
- (void)toggleStateDidChangeTo: (BOOL) state inToggleViewArray:(AZToggleArrayView*)view withName:(NSString *)name;
@end

@interface 	AZToggleArrayView : NSView

//- (CAL*)	itemLayerWithName:(NSS*)name relativeTo:(NSS*)r onText:(NSS*)on  offText:(NSS*)off 
//							state:(BOOL)state		index:(NSUI)index	  labelPositioned:(AZPOS)pos;

//- (CAL*) itemLayerWithName:(NSS*)name 	relativeTo:(NSS*)r onText:(NSS*)on  offText:(NSS*)off
//							state:(BOOL)state 		 index:(NSUI)index;

//- (AZTCL*) toggleLayerWithOnText:(NSS*)on offText:(NSS*)off initialState:(BOOL)state;
- (AZTCL*) toggleLayerWithOnText:(NSS*)on offText:(NSS*)off initialState:(BOOL)state
														  title:(NSS*)title		index:(NSUI)index;

- (CATXTL*) itemTextLayerWithName:(NSS*)name;
//- (CAL*)		itemLayerWithName:	 (NSS*)name	relativeTo:(NSS*)relative index:(NSUI)index;

@property (NATOM,STRNG) NSA *questions;
@property (NATOM,ASS)				AZOrient orientation;
@property (UNSFE) IBOutlet id<AZToggleArrayViewDelegate> delegate;
@property (UNSFE) IBOutlet id<AZToggleArrayViewDatasource> datasource;
//- (void)  setTogglesAndStatesWithArrayOfDictionaries (AZToggleArrayView *) view;

@end

//- (NSS*) toggleView: (AZToggleArrayView*) toggleView questionAtIndex: (NSUI) index;
/*	return  index == 1 ? @"What?" : @"How?";		*/
//- (NSUI) numberOfTogglesInView: (AZToggleArrayView*)view;
/*	return  _questions.count; etc		*/

/*	return 	@[ @"Sort Alphabetically?", @"Sort By Color?" , 
 @"Sort like Dock", 		 @"Sort by \"Category\"?", @"Show extra app info?" ]; */
//- (AZPOS) positionForQuestion: (NSS*) question;
//- (AZWindowPosition) defaultLabelPosition;

//- (NSA*) itemsForToggleView: (AZToggleArrayView*) view;

/*	return 	@[	[view itemTextLayerWithName:@"Sort:" ],
 [view itemLayerWithName:	@"Color" relativeTo:@"superlayer" index:0],
 [view itemLayerWithName:	@"A-Z" relativeTo:@"Color" 	index:1]	]; 		*/

//- (NSA*) itemsForToggleView: (AZToggleArrayView*) view positioned: (AZWindowPosition) position;


/*  return @[[ itemLayerWithName:@"Item 2" relativeTo:index:1]];
	[containerLayer addSublayer:[self itemLayerWithName:@"Click these 'buttons' to change state ->"
											 relativeTo:@"Item 2"
												 onText:@"1"
												offText:@"0"
												  state:YES
												  index:1]];

*/

	//@interface AZToggle : BaseModel
	//@property (nonatomic, retain) NSString *name;
	//@property (nonatomic, retain) NSString *relative;
	//@property (nonatomic, retain) NSString *onText;
	//@property (nonatomic, retain) NSString *offText;
	//@property (nonatomic, assign) BOOL toggleState;
	//+ (AZToggle*) instanceWithObject:(id)object;
	//@end;

