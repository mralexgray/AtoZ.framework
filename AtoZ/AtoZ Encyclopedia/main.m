//
//  main.m
//  AtoZ Encyclopedia
//
//  Created by Alex Gray on 8/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>


@interface AtoZCLI : NSObject
@end

@implementation AtoZCLI
- (void) testMethods {
		//	NSLog(@"%@", [NSColor fengshui]);
		//	NSArray *h = [AtoZ dock];
		//	[AZStopwatch stop:@"b"];
		//	NSLog(@"They are the same %i", ([[AtoZ dock] isEqual: [AtoZ sharedInstance].dock]));
}

- (void) enumerateDockColors {
	[[[AtoZ dockSorted] valueForKeyPath:@"color"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSColor *c = obj;
		NSLog(@"Color:%@     \t \t Hue: %f\t  Sat: %f\t Lum: %f\t  Brt: %f",
			  c.nameOfColor,
			  c.hueComponent,
			  c.saturationComponent,
			  c.luminance,
			  c.brightnessComponent);
	}];
}

- (void) sizer {
	
	AZSizer *r = [AZSizer forQuantity:12 inRect:NSMakeRect(0,0,24,24)];
	NSLog   (@"%@", r.propertiesPlease);
}

- (void) listAppsPrivately {
	
	NSLog(@"%@", [AZApplePrivate registeredApps]);
}
@end


int main(int argc, const char * argv[])
{
	
	@autoreleasepool {
			//		[AZStopwatch start:@"eval"];
			//		AtoZCLI *c = [AtoZCLI new];
			//		NSArray *a = [[NSNumber numberWithInt:9] to:[NSNumber numberWithInt: 33]];
			//		NSLog(@"%@", a);
			//		NSLog(@"%@", @(ceil(103.0/10.0)));
			//		[c sizer];
			//		[c listAppsPrivately];
			//		AZSimpleView *u = [[AZSimpleView alloc]initWithFrame:NSZeroRect];
			//		[AZStopwatch stop:@"eval"];
			//		MoveTo(NSMakePoint(12,12));
			//		DragTo(NSMakePoint(12,60));
			//		__block NSArray *verts = [@1 to:@22];
			//		NSArray *hors = [@1 to:@600];
			//		[hors each:^(id obj, NSUInteger index, BOOL *stop) {
			//			float vert = [[verts objectAtNormalizedIndex:index]floatValue];
			//			NSLog(@"Dragpoint: %@", NSStringFromPoint(CGPointMake([obj floatValue],vert)));
			//			DragTo(CGPointMake([obj floatValue],vert));
		
		
		CGPoint A, B;
		A = CGPointMake(12,12);
		B = CGPointMake(500,12);
		
			//		mouseMoveTo(12,12, 10);
			//		mouseDrag(1, (int)B.x, (int)B.y);
		
		NSLog(@"%@ DISTANCE: %f",		NSStringFromPoint(MousePoint()),
			  distanceFromPoint(A, B) );
		
		
		AZFile *dic = [[[AtoZ dock] valueForKeyPath:@"name"]  filterOne:^BOOL(id object) {
			return ([object isEqualTo:@"Dictionary"] ? YES : NO);
		}];
		
		AZFile *it = [AZFile forAppNamed:@"iTunes"];
		
		NSLog(@"it: %@   dic: %@", it, dic);
		
			//		DragBetwixt(A, B);
			//		DragBetwixt(B, A);
			//		DragBetwixt(A, B);
			//			[obj floatValue]-1,vert),CGPointMake([obj floatValue],vert));
			//		}];
	}

	return NSApplicationMain(argc, (const char **)argv);

}


	//int main(int argc, char *argv[])
	//{
	//	return NSApplicationMain(argc, (const char **)argv);
	//}


	//
	//  AZAppDelegate.h
	//  AZLayerTest
	//
	//  Created by Alex Gray on 7/10/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//
