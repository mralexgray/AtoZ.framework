//
//  BGGradientTheme.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/15/08.
//


#import "BGTheme.h"


@implementation BGGradientTheme

-(NSGradient *)normalGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324f green: 0.331f blue: 0.347f alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245f green: 0.253f blue: 0.269f alpha: [self alphaValue]], .5f,
			 [NSColor colorWithDeviceRed: 0.206f green: 0.214f blue: 0.233f alpha: [self alphaValue]], .5f,
			 [NSColor colorWithDeviceRed: 0.139f green: 0.147f blue: 0.167f alpha: [self alphaValue]], 1.0f, nil];
}

-(NSGradient *)pushedGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524f green: 0.531f blue: 0.547f alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445f green: 0.453f blue: 0.469f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406f green: 0.414f blue: 0.433f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339f green: 0.347f blue: 0.367f alpha: [self alphaValue]], (CGFloat)1.0f, nil];
}

-(NSGradient *)highlightGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524f green: 0.531f blue: 0.547f alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445f green: 0.453f blue: 0.469f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406f green: 0.414f blue: 0.433f alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339f green: 0.347f blue: 0.367f alpha: [self alphaValue]], (CGFloat)1.0f, nil];
}

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
}

-(NSGradient *)disabledKnobColor {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324f green: 0.331f blue: 0.347f alpha: 1.0f],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245f green: 0.253f blue: 0.269f alpha: 1.0f], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.206f green: 0.214f blue: 0.233f alpha: 1.0f], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.139f green: 0.147f blue: 0.167f alpha: 1.0f], (CGFloat)1.0f, nil];
}

-(NSColor *)strokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749f green: 0.761f blue: 0.788f alpha: 0.7f];
}

-(CGFloat)alphaValue {
	
	return 0.7f;
}

@end
