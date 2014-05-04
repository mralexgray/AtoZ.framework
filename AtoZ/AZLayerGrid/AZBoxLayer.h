//
//  AZBoxLayer.h
//  AtoZ
//
//  Created by Alex Gray on 7/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface AZBoxLayer : CALayer {
//	NSString *imagePath;
	NSString *title;
	CALayer *closeLayer;
	CATextLayer *text;
	CALayer *imageLayer;
}

@property(retain)NSImage *image;
@property(retain)NSString *title;
- (id)initWithImage:(NSImage*)image title:(NSString*)iconTitle;
//- (id)initWithImagePath:(NSString*)path title:(NSString*)iconTitle;
- (CAAnimation*)shakeAnimation;
- (void) startShake;
- (void) topShake;
- (BOOL)isRunning;
- (void) oggleShake;
-(CALayer*)closeBoxLayer;

@end
