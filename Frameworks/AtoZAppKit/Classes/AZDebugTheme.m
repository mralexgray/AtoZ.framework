//
//  BGGradientTheme.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/15/08.
//


#import "BGTheme.h"

#define SELF_ALPHA colorWithAlphaComponent:[self alphaValue]

#define GRADIENT_ANGLE 270

@implementation AZDebugTheme


//-(NSColor*) baseColor { _bas [self baseColor] = baseColor ?: RANDOMCOLOR; }

#pragma mark General Theme

-(CGFloat)gradientAngle { return GRADIENT_ANGLE; }

-(NSGradient *)normalGradient  //BACKGROUND OF VIEWS
{
	return [[ NSGradient alloc] initWithStartingColor: [[NSColor colorWithCalibratedWhite:.35 alpha:1]SELF_ALPHA]
										  endingColor: [[NSColor colorWithCalibratedWhite:0   alpha:1]SELF_ALPHA]];
}

-(NSColor *)strokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749f green: 0.761f blue: 0.788f alpha: 0.7f];

}

-(NSColor *)disabledStrokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749f green: 0.761f blue: 0.788f alpha: [self disabledAlphaValue]];
}

-(NSColor *)darkStrokeColor {
	
	return [NSColor colorWithDeviceRed: 0.141f green: 0.141f blue: 0.141f alpha: 0.5f];
}

-(NSColor *)textColor {
	
	return [NSColor whiteColor];
}

-(NSColor *)highlightTextColor {
	
	return [NSColor whiteColor];
}
-(NSColor *)disabledTextColor {
	
	return [NSColor colorWithDeviceRed: 1 green: 1 blue: 1 alpha: [self disabledAlphaValue]];
}

-(NSShadow *)dropShadow {
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: [NSColor blackColor]];
	[shadow setShadowBlurRadius: 2];
	[shadow setShadowOffset: NSMakeSize( 0, -1)];
	
	return shadow;
}

-(CGFloat)alphaValue {
	
	return 0.6f; //.7
}

-(CGFloat)disabledAlphaValue {
	
	return 0.2f;
}

-(NSShadow *)focusRing {
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: [NSColor whiteColor]];
	[shadow setShadowBlurRadius: 3];
	[shadow setShadowOffset: NSMakeSize( 0, 0)];
	
	return shadow;
}

-(NSGradient *)disabledNormalGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: [self disabledAlphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: [self disabledAlphaValue]]];
}

-(NSGradient *)pushedGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451f green: 0.451f blue: 0.455f alpha: [self alphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: [self alphaValue]]];
//	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524f green: 0.531f blue: 0.547f alpha: [self alphaValue]],
//	(CGFloat)0, [NSColor colorWithDeviceRed: 0.445f green: 0.453f blue: 0.469f alpha: [self alphaValue]], (CGFloat).5,
//	[NSColor colorWithDeviceRed: 0.406f green: 0.414f blue: 0.433f alpha: [self alphaValue]], (CGFloat).5,
//	[NSColor colorWithDeviceRed: 0.339f green: 0.347f blue: 0.367f alpha: [self alphaValue]], (CGFloat)1.0f, nil];

}

-(NSGradient *)highlightGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451f green: 0.451f blue: 0.455f alpha: [self alphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: [self alphaValue]]];
//		return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524f green: 0.531f blue: 0.547f alpha: [self alphaValue]],
// (CGFloat)0, [NSColor colorWithDeviceRed: 0.445f green: 0.453f blue: 0.469f alpha: [self alphaValue]], (CGFloat).5,
// [NSColor colorWithDeviceRed: 0.406f green: 0.414f blue: 0.433f alpha: [self alphaValue]], (CGFloat).5,
// [NSColor colorWithDeviceRed: 0.339f green: 0.347f blue: 0.367f alpha: [self alphaValue]], (CGFloat)1.0f, nil];

}

-(NSGradient *)normalComplexGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324f green: 0.331f blue: 0.347f alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245f green: 0.253f blue: 0.269f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.206f green: 0.214f blue: 0.233f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.139f green: 0.147f blue: 0.167f alpha: [self alphaValue]], (CGFloat)1.0f, nil];
}

-(NSGradient *)disabledNormalComplexGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324f green: 0.331f blue: 0.347f alpha: [self disabledAlphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245f green: 0.253f blue: 0.269f alpha: [self disabledAlphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.206f green: 0.214f blue: 0.233f alpha: [self disabledAlphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.139f green: 0.147f blue: 0.167f alpha: [self disabledAlphaValue]], (CGFloat)1.0f, nil];
}

-(NSGradient *)pushedComplexGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524f green: 0.531f blue: 0.547f alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445f green: 0.453f blue: 0.469f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406f green: 0.414f blue: 0.433f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339f green: 0.347f blue: 0.367f alpha: [self alphaValue]], (CGFloat)1.0f, nil];
}

-(NSGradient *)highlightComplexGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524f green: 0.531f blue: 0.547f alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445f green: 0.453f blue: 0.469f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406f green: 0.414f blue: 0.433f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339f green: 0.347f blue: 0.367f alpha: [self alphaValue]], (CGFloat)1.0f, nil];
}

-(NSColor *)normalSolidFill {
	
	return [NSColor colorWithDeviceRed: 0.141f green: 0.141f blue: 0.141f alpha: [self alphaValue]];
}

-(NSColor *)disabledNormalSolidFill {
	
	return [NSColor colorWithDeviceRed: 0.141f green: 0.141f blue: 0.141f alpha: [self disabledAlphaValue]];
}

-(NSColor *)pushedSolidFill {
	
	return [NSColor colorWithDeviceRed: 0.941f green: 0.941f blue: 0.941f alpha: [self alphaValue]];
}

-(NSColor *)highlightSolidFill {
	
	return [NSColor colorWithDeviceRed: 0.941f green: 0.941f blue: 0.941f alpha: [self alphaValue]];
}





-(NSColor *)scrollerStroke {
	
	return [NSColor colorWithDeviceRed: 0.749f green: 0.761f blue: 0.788f alpha: 1.0f];
}

-(NSGradient *)scrollerKnobGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.631f green: 0.639f blue: 0.655f alpha: 1.0f]
										  endingColor: [NSColor colorWithDeviceRed: 0.439f green: 0.447f blue: 0.471f alpha: 1.0f]];
}

-(NSGradient *)scrollerTrackGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.137f green: 0.137f blue: 0.137f alpha: .75f]
										  endingColor: [NSColor colorWithDeviceRed: 0.278f green: 0.278f blue: 0.278f alpha: .75f]];
}

-(NSGradient *)scrollerArrowNormalGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: [self scrollerAlphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: [self scrollerAlphaValue]]];
}

-(NSGradient *)scrollerArrowPushedGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451f green: 0.451f blue: 0.455f alpha: [self scrollerAlphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: [self scrollerAlphaValue]]];
}

-(CGFloat)scrollerAlphaValue {
	
	return 0.5f;
}

#pragma mark Slider Theme

-(NSGradient *)knobColor {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324f green: 0.331f blue: 0.347f alpha: 1.0f],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245f green: 0.253f blue: 0.269f alpha: 1.0f], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.206f green: 0.214f blue: 0.233f alpha: 1.0f], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.139f green: 0.147f blue: 0.167f alpha: 1.0f], (CGFloat)1.0f, nil];
}

-(NSGradient *)highlightKnobColor {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524f green: 0.531f blue: 0.547f alpha: 1.0f],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445f green: 0.453f blue: 0.469f alpha: 1.0f], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406f green: 0.414f blue: 0.433f alpha: 1.0f], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339f green: 0.347f blue: 0.367f alpha: 1.0f], (CGFloat)1.0f, nil];

			 
//	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451f green: 0.451f blue: 0.455f alpha: 1.0f]
//										  endingColor: [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: 1.0f]];
}

-(NSGradient *)disabledKnobColor {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324f green: 0.331f blue: 0.347f alpha: 1.0f],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245f green: 0.253f blue: 0.269f alpha: 1.0f], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.206f green: 0.214f blue: 0.233f alpha: 1.0f], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.139f green: 0.147f blue: 0.167f alpha: 1.0f], (CGFloat)1.0f, nil];
//	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
//										  endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]];
}



-(NSColor *)sliderTrackColor {
	
	return [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: [self alphaValue]];
}

-(NSColor *)disabledSliderTrackColor {
	
	return [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: [self disabledAlphaValue]];
}


#pragma mark Text Based Theme

-(BOOL)isOverrideFillColor {
	return YES;
}
-(NSColor *)textFillColor {
	
	return [NSColor colorWithDeviceRed: .224f green: .224f blue: .224f alpha: .95f];
}

-(NSColor *)selectionHighlightActiveColor {
	
	return [NSColor darkGrayColor];
}

-(NSColor *)selectionHighlightInActiveColor {
	
	return [NSColor darkGrayColor];
}

-(NSColor *)selectionTextActiveColor {
	
	return [NSColor whiteColor];
}

-(NSColor *)selectionTextInActiveColor {
	
	return [NSColor whiteColor];
}

-(NSColor *)placeholderTextColor {

	return [NSColor grayColor];
}

#pragma mark Progress Theme

-(NSGradient *)progressTrackGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed: 0.125f green: 0.125f blue: 0.125f alpha: 1.0f]
										  endingColor: [NSColor colorWithCalibratedRed: 0.208f green: 0.208f blue: 0.208f alpha: 1.0f]];
}

#pragma mark Token Theme

-(NSColor *)tokenFillNormal {
	
	return [NSColor colorWithDeviceRed: 0.249f green: 0.261f blue: 0.288f alpha: 1.0f];
}

-(NSColor *)tokenFillHighlight {
	
	return [NSColor colorWithDeviceRed: 0.449f green: 0.461f blue: 0.488f alpha: 1.0f];
}

-(NSColor *)tokenBorder {
	
	return [NSColor whiteColor];
}

-(NSColor *)tokenTextColor {
	
	return [NSColor whiteColor];
}

#pragma mark Table Theme

-(NSColor *)cellHighlightColor {
	
	return [NSColor colorWithDeviceRed: 0.549f green: 0.561f blue: 0.588f alpha: 1];
}

-(NSArray *)cellAlternatingRowColors {
	
	return [NSArray arrayWithObjects:
			[NSColor colorWithCalibratedWhite: 0.16f alpha: 0.86f], 
			[NSColor colorWithCalibratedWhite: 0.15f alpha: 0.8f], 
			nil];
}

-(NSColor *)cellSelectedTextColor {
	
	return [NSColor blackColor];
}

-(NSColor *)cellEditingFillColor {
	
	return [NSColor colorWithDeviceRed: 0.141f green: 0.141f blue: 0.141f alpha: [self alphaValue]];
}

-(NSColor *)tableBackgroundColor {
	
	return [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 0];
}

-(NSColor *)tableHeaderCellBorderColor {
	
	return [NSColor colorWithDeviceRed: 0.349f green: 0.361f blue: 0.388f alpha: 1.0f];
}

-(NSGradient *)tableHeaderCellNormalFill {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: 1.0f]
										  endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: 1.0f]];
}

-(NSGradient *)tableHeaderCellPushedFill {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451f green: 0.451f blue: 0.455f alpha: 1.0f]
										  endingColor: [NSColor colorWithDeviceRed: 0.318f green: 0.318f blue: 0.318f alpha: 1.0f]];
}

-(NSGradient *)tableHeaderCellSelectedFill {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.651f green: 0.651f blue: 0.655f alpha: 1.0f]
										  endingColor: [NSColor colorWithDeviceRed: 0.518f green: 0.518f blue: 0.518f alpha: 1.0f]];
}


@end


//	return [[NSGradient alloc] initWithStartingColor: [NSColor redColor] endingColor:[NSColor blackColor]];//[NSColor colorWithDeviceRed: 0.251f green: 0.251f blue: 0.255f alpha: [self alphaValue]]
//										  endingColor: [NSColor colorWithDeviceRed: 0.118f green: 0.118f blue: 0.118f alpha: ]];
//	NSLog(@"azbasicgrad");
//	return [[NSGradient alloc] initWithColorsAndLocations:	[NSColor colorWithDeviceWhite:0.15f alpha:1.0f],  0,
//															[NSColor colorWithDeviceWhite:0.19f alpha:1.0f], .5,
//															[NSColor colorWithDeviceWhite:0.20f alpha:1.0f], .5,
//							  								[NSColor colorWithDeviceRed:0.973 green:0.191 blue:0.191 alpha:1.000],  1, nil];
//							  								[NSColor colorWithDeviceWhite:0.25f alpha:1.0f],  1, nil];
//	NSArray *locations = $array($float(0),$float(.5), $float(.5), $float(1));
//
// [NSColor colorWithDeviceRed: 0.324f green: 0.331f blue: 0.347f alpha: [self alphaValue]],
//			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245f green: 0.253f blue: 0.269f alpha: [self alphaValue]], .5f,
//			 [NSColor colorWithDeviceRed: 0.206f green: 0.214f blue: 0.233f alpha: [self alphaValue]], .5f,
//			 [NSColor colorWithDeviceRed: 0.139f green: 0.147f blue: 0.167f alpha: [self alphaValue]], 1.0f, nil];
