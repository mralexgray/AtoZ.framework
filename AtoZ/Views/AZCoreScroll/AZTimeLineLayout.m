
#import "AZTimeLineLayout.h"
#import <Foundation/Foundation.h>


NSString *selectedSnapShot = @"selectedSnapShot";

@implementation AZTimeLineLayout

static AZTimeLineLayout *sharedLayoutManager;

+ (id)layoutManager {	if (sharedLayoutManager == nil)	sharedLayoutManager = [[self alloc] init];
						return sharedLayoutManager;
}

//- (SFTimeLineLayout *)init {	if ([super init]) {	}	return self;}

- (CGPoint)scrollPointForSelected: (CALayer*)layer {
 	NSNumber *number 	= 	[layer valueForKey:selectedSnapShot];
	int selectedIndex 	= ( number != nil ? [number intValue] : 0 );
		NSInteger totalSnapShots = [ [layer sublayers] count];
	
	CALayer* snapShot 	= [ [layer sublayers] objectAtIndex:selectedIndex];
	CALayer* lastShot 	= [ [layer sublayers] objectAtIndex:totalSnapShots - 1];
	CALayer* firstShot 	= [ [layer sublayers] objectAtIndex:0];
		
	// What will the visible rect be if we center the selected snapshot? 
	CGRect selectedRect 	= [snapShot frame];
	CGFloat newXOrigin	= ( selectedRect.origin.x	+ selectedRect.size.width * 0.5) - [layer visibleRect].size.width * 0.5;
	CGRect newVisRect = CGRectMake(newXOrigin, 0, [layer visibleRect].size.width, [layer visibleRect].size.height);
		
	// If the first snapshot is in the new visible rect, anchor to the beginning. 
	if ( CGRectIntersectsRect([firstShot frame], newVisRect )	) {
		return CGPointMake(0, 0);	 
	}
		
	// If the last snapshot is in the new visiblerect, anchor to the end.
	if ( CGRectIntersectsRect([lastShot frame], newVisRect ) ) {
		CGFloat newOrigin = ([lastShot frame].origin.x + [lastShot frame].size.width + XMARGIN) - newVisRect.size.width;					 
		return CGPointMake(newOrigin, 0);	 
	}
	// otherwise center the offscreen selected item
	return newVisRect.origin;	
}

- (CGSize)preferredSizeOfLayer:(CALayer *)layer {
	NSInteger i = [layer.sublayers count];
	CGFloat currentSnapshotDim = layer.bounds.size.height - YMARGIN * 2;
	return CGSizeMake(XMARGIN*(i+1) +currentSnapshotDim*i, layer.frame.size.height);
}


- (void)layoutSublayersOfLayer:(CALayer *)layer {
	//NSLog(@"layoutSublayersOfLayer called "	);
	NSArray* array = [layer sublayers];
	NSInteger count = [array count];
	CGFloat currentSnapshotDim = layer.bounds.size.height - YMARGIN * 2;
	
	NSInteger i;
	CALayer* subLayer;

	for ( i = 0; i < count; i++ ) {
		subLayer = [array objectAtIndex:i]; 
		subLayer.frame = CGRectMake(XMARGIN*(i+1) +currentSnapshotDim*i, YMARGIN, 
																currentSnapshotDim, currentSnapshotDim);
	}
		
}

@end
