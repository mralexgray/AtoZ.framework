#import "Transition.h"

#import <QuartzCore/QuartzCore.h>
#import <Carbon/Carbon.h>

// Create a subclass of NSAnimation that we'll use to drive the transition.
@interface TransitionAnimation : NSAnimation
@end

@implementation Transition
@synthesize delegate, initialImage, inputShadingImage, animation, finalImage, transitionDuration, transitionFilter, transitionFilter2;

- (id)initWithDelegate:(id)object shadingImage:(CIImage*)aInputShadingImage {
	if(self=[super init]) {
		delegate = object;
		inputShadingImage = aInputShadingImage;
		animation = nil;
		initialImage = nil;
		finalImage = nil;
		transitionDuration = 0.35;
		transitionFilter = nil;
		transitionFilter2 = nil;
	}
	return self;
}

// Flush any temporary images and filters
- (void)reset {
	[initialImage release];
	[finalImage release];
	[transitionFilter release];
	[transitionFilter2 release];
	[animation release];
	initialImage = nil;
	finalImage = nil;
	transitionFilter = nil;
	transitionFilter2 = nil;
	animation = nil;
}

- (void)dealloc {
	[self reset];
	[inputShadingImage release];
//	[super dealloc];
}

- (void)setStyle:(int)aStyle direction:(float)aDirection {
	self.style 		= aStyle;
	self.direction 	= aDirection;
}


- (NSTimeInterval)transitionDuration
{
    return transitionDuration;
}
- (void)setTransitionDuration:(NSTimeInterval)aTransitionDuration
{
    transitionDuration = aTransitionDuration;
}


/* Utility:
 * Capture a view into a CoreImage of rect size
 *   I know it's horrible, but at least it is only called twice when starting the transition
 */
- (CIImage *)createCoreImage:(NSView *)view {
	NSRect rect = [delegate bounds];

	NSBitmapImageRep * bitmap = [view bitmapImageRepForCachingDisplayInRect:[view bounds]];
	[view cacheDisplayInRect:[view bounds] toBitmapImageRep:bitmap];
	//need to place it into an image so we can composite it
	NSImage * image = [[NSImage alloc] init];
	[image addRepresentation:bitmap];
	
	// Build our offscreen CGContext
	int bytesPerRow = rect.size.width*4;			//bytes per row - one byte each for argb
	bytesPerRow += (16 - bytesPerRow%16)%16;		// ensure it is a multiple of 16 - WARNING: artifacts and/or bugs occur if not	
	size_t byteSize = bytesPerRow * rect.size.height;

	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB); 
    void * bitmapData = malloc(byteSize); 
	//bzero(bitmapData, byteSize); //only necessary if drawBackground doesn't cover entire image
	
	CGContextRef cg = CGBitmapContextCreate(bitmapData,
		rect.size.width,
		rect.size.height,
		8, // bits per component
		bytesPerRow,
		colorSpace,
		kCGImageAlphaPremultipliedFirst); //want kCIFormatARGB8 in CIImage
		//http://developer.apple.com/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_context/chapter_3_section_4.html#//apple_ref/doc/uid/TP30001066-CH203-//apple_ref/doc/uid/TP30001066-CH203-CJBHBFFE
	
	// Ensure the y-axis is flipped
	CGContextTranslateCTM(cg, 0, rect.size.height);	
	CGContextScaleCTM(cg, 1.0, -1.0 );
	
	// Not entirely sure why the pattern is out of phase, but...
	CGContextSetPatternPhase(cg, CGSizeMake(0,rect.size.height)); 
	
	// Draw into the offscreen CGContext
	[NSGraphicsContext saveGraphicsState];
	NSGraphicsContext * nscg = [NSGraphicsContext graphicsContextWithGraphicsPort:cg flipped:NO];
	[NSGraphicsContext setCurrentContext:nscg];
		[delegate drawBackground:[view frame]];
		[image compositeToPoint:NSMakePoint([view frame].origin.x, [view frame].origin.y+[view bounds].size.height) operation:NSCompositeSourceOver];
	[NSGraphicsContext restoreGraphicsState];
	CGContextRelease(cg);

	// Extract the CIImage from the raw bitmap data that was used in the offscreen CGContext
	CIImage * coreimage = [[CIImage alloc] 
		initWithBitmapData:[NSData dataWithBytesNoCopy:bitmapData length:byteSize] 
		bytesPerRow:bytesPerRow 
		size:CGSizeMake(rect.size.width, rect.size.height) 
		format:kCIFormatARGB8
		colorSpace:colorSpace];
	
	// Housekeeping
	[image release];
	CGColorSpaceRelease(colorSpace); 
	//free(bitmapData);
	
	return coreimage;
}

- (void)setInitialView:(NSView*)view {
	CIImage * image = [self createCoreImage:view];
	[initialImage release];
	initialImage = image;
}

- (void)setFinalView:(NSView*)view {
	CIImage * image = [self createCoreImage:view];
	[finalImage release];
	finalImage = image;

}

- (BOOL)isAnimating {	return (animation!=nil); }

- (void)start {
	[transitionFilter release];
	[transitionFilter2 release];
	self.transitionFilter = nil;
	self.transitionFilter2 = nil;
	self.chaining = NO;
	NSRect rect = [delegate bounds];
	switch (self.style) {
        case AnimatingTabViewCopyMachineTransitionStyle:
            transitionFilter = [CIFilter filterWithName:@"CICopyMachineTransition"];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            [transitionFilter setValue:initialImage forKey:@"inputImage"];
			[transitionFilter setValue:finalImage forKey:@"inputTargetImage"];
            break;

       case AnimatingTabViewDissolveTransitionStyle:
            transitionFilter = [CIFilter filterWithName:@"CIDissolveTransition"];
            [transitionFilter setDefaults];
            [transitionFilter setValue:initialImage forKey:@"inputImage"];
			[transitionFilter setValue:finalImage forKey:@"inputTargetImage"];
            break;

        case AnimatingTabViewFlashTransitionStyle:
            transitionFilter = [CIFilter filterWithName:@"CIFlashTransition"];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            [transitionFilter setValue:initialImage forKey:@"inputImage"];
			[transitionFilter setValue:finalImage forKey:@"inputTargetImage"];
            break;

        case AnimatingTabViewModTransitionStyle:
            transitionFilter = [CIFilter filterWithName:@"CIModTransition"];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
            [transitionFilter setValue:initialImage forKey:@"inputImage"];
			[transitionFilter setValue:finalImage forKey:@"inputTargetImage"];
            break;

        case AnimatingTabViewPageCurlTransitionStyle:
            transitionFilter = [CIFilter filterWithName:@"CIPageCurlTransition"];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[NSNumber numberWithFloat:-M_PI_4] forKey:@"inputAngle"];
            [transitionFilter setValue:initialImage forKey:@"inputBacksideImage"];
            [transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
			[transitionFilter setValue:initialImage forKey:@"inputImage"];
			[transitionFilter setValue:finalImage forKey:@"inputTargetImage"];
            break;

        case AnimatingTabViewSwipeTransitionStyle:
            transitionFilter = [CIFilter filterWithName:@"CISwipeTransition"];
            [transitionFilter setDefaults];
			[transitionFilter setValue:initialImage forKey:@"inputImage"];
			[transitionFilter setValue:finalImage forKey:@"inputTargetImage"];
			break;

		case AnimatingTabViewFlipTransitionStyle:
			transitionFilter = [CIFilter filterWithName:@"CIPerspectiveTransform"];
            [transitionFilter setDefaults];
			[transitionFilter setValue:initialImage forKey:@"inputImage"];
			break;
			
		case AnimatingTabViewCubeTransitionStyle:
			transitionFilter = [CIFilter filterWithName:@"CIPerspectiveTransform"];
            [transitionFilter setDefaults];
			[transitionFilter setValue:initialImage forKey:@"inputImage"];
			
			transitionFilter2 = [CIFilter filterWithName:@"CIPerspectiveTransform"];
            [transitionFilter2 setDefaults];
			[transitionFilter2 setValue:finalImage forKey:@"inputImage"];
			break;
			
		case AnimatingTabViewZoomDissolveTransitionStyle:
			transitionFilter = [CIFilter filterWithName:@"CIZoomBlur"];
            [transitionFilter setDefaults];
			[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
			[transitionFilter setValue:initialImage forKey:@"inputImage"];
			
			transitionFilter2 = [CIFilter filterWithName:@"CIDissolveTransition"];
            [transitionFilter2 setDefaults];
			[transitionFilter2 setValue:finalImage forKey:@"inputTargetImage"];
			self.chaining = YES;
			break;
			
        case AnimatingTabViewRippleTransitionStyle:
            transitionFilter = [CIFilter filterWithName:@"CIRippleTransition"];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            [transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
			[transitionFilter setValue:initialImage forKey:@"inputImage"];
			[transitionFilter setValue:finalImage forKey:@"inputTargetImage"];
            break;		
    }
	
	if(transitionFilter!=nil) 
	{
		
		NSTimeInterval theTransitionDuration = [self transitionDuration];
		
		if(GetCurrentEventKeyModifiers() & shiftKey) //Adam Leonard - 9/17/07 - slow-mo animation when shift key is down
			theTransitionDuration *= 5; //5 times slower
		
		animation = [[TransitionAnimation alloc] initWithDuration:theTransitionDuration animationCurve:NSAnimationEaseInOut];
		[animation setDelegate:delegate];
		// Run the animation synchronously.
		
		self.frames = 0;
		[animation startAnimation];
		
		//and then chuck away the images and filters
		[self reset];
		//NSLog(@"%d frames", frames);
	}
}

/*
 * Utility:
 * Using a CIPerspectiveTransform filter
 *   Render a billboard bounded by (+/- width, +/- height)
 *   At 3D coordinates (px1,pz1, +/- height) (px2,pz2, +/- height) 
 *   On a visual plane at distance dist
 */
+ (void)updatePerspectiveFilter:(CIFilter*)filter
	px1:(float)px1 pz1:(float)pz1 
	px2:(float)px2 pz2:(float)pz2
	dist:(float)dist
	width:(float)width height:(float)height {
	// Convert to coordinates on the visual plane
	float sx1 = dist * px1 / pz1;
	float sy1 = dist * height / pz1;
	float sx2 = dist * px2 / pz2;
	float sy2 = dist * height / pz2;
	[filter setValue:[CIVector vectorWithX:width+sx1 Y:height+sy1] forKey:@"inputTopRight"];
	[filter setValue:[CIVector vectorWithX:width+sx2 Y:height+sy2] forKey:@"inputTopLeft" ];
	[filter setValue:[CIVector vectorWithX:width+sx1 Y:height-sy1] forKey:@"inputBottomRight"];
	[filter setValue:[CIVector vectorWithX:width+sx2 Y:height-sy2] forKey:@"inputBottomLeft"];
}

- (void)draw:(NSRect)viewRect {
	_frames++;
	
	NSRect rect = [delegate bounds];
	float time = [animation currentValue];
	
	if(self.style==AnimatingTabViewCubeTransitionStyle) {
			float vWidth = viewRect.size.width / 2; //damn, we need to compensate for the fact we have a gutter (hence angle2)
		
			float width = rect.size.width / 2;
			float height = rect.size.height / 2;
			float radius = sqrt(width*width+vWidth*vWidth);
		float angle = - self.direction * M_PI_2 * time + asin(vWidth/radius);
			float angle2 = -self.direction * M_PI_2 * time + acos(vWidth/radius)+M_PI_2;
			float dist = width * 5; //set a the visual plane a reasonable distance away
		
			// Calculate 3D position (note that we intially lie on the visual plane)
			float px1 = radius * cos(angle);
			float pz1 = dist + vWidth - radius * sin(angle);
			float px2 = radius * cos(angle2);
			float pz2 = dist + vWidth - radius * sin(angle2);
			
			[Transition updatePerspectiveFilter:transitionFilter
				px1:px1 pz1:pz1
				px2:px2 pz2:pz2
				dist:dist
				width:width height:height];
				
			// Now repeat for second face, rotated 90 degrees
			angle += _direction*M_PI_2;
			angle2 += _direction*M_PI_2;
			
			px1 = radius * cos(angle);
			pz1 = dist + vWidth - radius * sin(angle);
			px2 = radius * cos(angle2);
			pz2 = dist + vWidth - radius * sin(angle2);
			
			[Transition updatePerspectiveFilter:transitionFilter2
				px1:px1 pz1:pz1
				px2:px2 pz2:pz2
				dist:dist
				width:width height:height];			
			
	} else if(self.style==AnimatingTabViewFlipTransitionStyle) {
			float radius = rect.size.width / 2;
			float height = rect.size.height / 2;
			float angle = self.direction*M_PI * time;
			float dist = radius * 5; //set a the visual plane a reasonable distance away
			
			// Calculate 3D position (note that we intially lie on the visual plane)
			float px1 = radius * cos(angle);
			float pz1 = dist + radius * sin(angle);
			float px2 = -radius * cos(angle);
			float pz2 = dist - radius * sin(angle);
			
			if(time>0.5) {
				if(finalImage) {
					// Swap images at half-way point
					[transitionFilter setValue:finalImage forKey:@"inputImage"];
					[finalImage release];
					finalImage = nil;	
				}
				//swap the coordinates so we can actually see the other size
				float ss;
				ss = px1; px1 = px2; px2 = ss;
				ss = pz1; pz1 = pz2; pz2 = ss;
			}	
					
			[Transition updatePerspectiveFilter:transitionFilter
				px1:px1 pz1:pz1
				px2:px2 pz2:pz2
				dist:dist
				width:radius height:height];	
						
	} else if(self.style==AnimatingTabViewZoomDissolveTransitionStyle) {
			[transitionFilter setValue:[NSNumber numberWithFloat:(20*time)] forKey:@"inputAmount"];
			[transitionFilter2 setValue:[NSNumber numberWithFloat:time] forKey:@"inputTime"];
		self.chaining = YES;
		} else {
			//standard transistion
			[transitionFilter setValue:[NSNumber numberWithFloat:time] forKey:@"inputTime"];
		}


	// Draw the output, or pass on to second filter
	CIImage * outputCIImage = [transitionFilter valueForKey:@"outputImage"];
	if(self.chaining) {
		[transitionFilter2 setValue:outputCIImage forKey:@"inputImage"];
	} else {
		[outputCIImage drawInRect:rect fromRect:NSMakeRect(0, rect.size.height, rect.size.width, -rect.size.height) operation:NSCompositeSourceOver fraction:1.0];
	}
		
	/*	
		// They advise this rather than simply [outputCIImage drawInRect... - I can't see any performance difference
		CGRect  cg = CGRectMake(NSMinX(rect), NSMinY(rect),NSWidth(rect), NSHeight(rect));
		if(!context) {
			context = [CIContext contextWithCGContext:[[NSGraphicsContext currentContext] graphicsPort] options: nil];
			[context retain];
		}
		[context drawImage:outputCIImage inRect:cg fromRect:CGRectMake(0, cg.size.height, cg.size.width, -cg.size.height)];
	*/	
		
		
	// Handle the second filter it exists
	if(transitionFilter2) {
		outputCIImage = [transitionFilter2 valueForKey:@"outputImage"];
		[outputCIImage drawInRect:rect fromRect:NSMakeRect(0, rect.size.height, rect.size.width, -rect.size.height) operation:NSCompositeSourceOver fraction:1.0];
	}
}
@end

@implementation TransitionAnimation

	// Override NSAnimation's -setCurrentProgress: method, and use it as our point to hook in and advance our Core Image transition effect to the next time slice.
- (void)setCurrentProgress:(NSAnimationProgress)progress {
    // First, invoke super's implementation, so that the NSAnimation will remember the proposed progress value and hand it back to us when we ask for it in AnimatingTabView's -drawRect: method.
    [super setCurrentProgress:progress];

    // Now ask the AnimatingTabView (which set itself as our delegate) to display.  Sending a -display message differs from sending -setNeedsDisplay: or -setNeedsDisplayInRect: in that it demands an immediate, syncrhonous redraw of the view.  Most of the time, it's preferrable to send a -setNeedsDisplay... message, which gives AppKit the opportunity to coalesce potentially numerous display requests and update the window efficiently when it's convenient.  But for a syncrhonously executing animation, it's appropriate to use -display.
	[(NSView*)self.delegate display];
}


@end
