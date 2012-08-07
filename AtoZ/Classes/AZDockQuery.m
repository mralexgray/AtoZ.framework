//
//  AZDockQuery.m
//  AtoZ
//
//  Created by Alex Gray on 7/5/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZDockQuery.h"
#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@implementation AZDockQuery

//@synthesize dock;

-(void) setUp{
	_dock = [self getDock];
}

+(NSArray*) dock {
	return [AZDockQuery instance].dock;
}



- (NSArray *) getDock {	
	[AZStopwatch start:@"makeDock"];
	NSLog(@"A dock is born!"); AXUIElementRef appElement = NULL;
	appElement = AXUIElementCreateApplication(
		[[[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.dock"] lastObject] processIdentifier]);
	if (appElement == NULL) return nil;
	AXUIElementRef firstChild 	= (AXUIElementRef)
	[[self subelementsFromElement:appElement forAttribute:@"AXChildren"] objectAtIndex:0];
	NSArray *children 	= [self subelementsFromElement:firstChild forAttribute:@"AXChildren"];
	__block NSNumber *counter = [NSNumber numberWithInt:0];
	return [children arrayUsingBlock:^id(id obj) {
		AXUIElementRef axElement =  (AXUIElementRef)obj;		CFTypeRef role; 	id preferredrole;
		AXError result4 = AXUIElementCopyAttributeValue(axElement, kAXSubroleAttribute,&role);
		if (result4 == kAXErrorSuccess) {	
			if (AXValueGetType(role) != kAXValueIllegalType) preferredrole = [NSValue valueWithPointer:role];
			else preferredrole = (id)role; 
			if ([preferredrole isEqualToString:@"AXApplicationDockItem"]) {
				CFTypeRef name;
				AXError result = AXUIElementCopyAttributeValue(axElement, kAXTitleAttribute, &name);
				if (result == kAXErrorSuccess) {
					// 	id titleValue; if (AXValueGetType(name) != kAXValueIllegalType) titleValue = [NSValue valueWithPointer:name]; } else  titleValue = (id)name;
					CFTypeRef path;		id URLvalue; id convertedURL;
					AXError result2 = AXUIElementCopyAttributeValue(axElement, kAXURLAttribute, &path);
					if (result2 == kAXErrorSuccess) {
						if 		(AXValueGetType(path) != kAXValueIllegalType) URLvalue = [NSValue valueWithPointer:path];
						else	URLvalue = (id)path;
					}
					convertedURL = (NSString*)[(NSURL *)URLvalue path];	//	NSURL *convertedURL = (__bridge CFURLRef)&URLvalue;
					CFTypeRef position;	CGPoint coordinates;
					AXError result3 = AXUIElementCopyAttributeValue(axElement, kAXPositionAttribute, &position);
					if (result3 == kAXErrorSuccess)	{
						if (AXValueGetValue(position, kAXValueCGPointType, &coordinates)) {
							//	NSLog(@"position: (%f, %f)", coordinates.x, coordinates.y);
//							XYZ = [NSValue valueWithPoint:NSPointFromCGPoint(coordinates)]; 
//							posX = [NSString stringWithFormat:@"%.f", coordinates.x];  
//							posY = [NSString stringWithFormat:@"%.f", coordinates.y];
						}
					}
//					AZFile *app = [AZFile instanceWithPath:convertedURL];
					NSString *app = convertedURL;
					NSDictionary *d = @{	@"path" : app,
											@"spot" : counter,
									   @"dockPoint" : [NSValue valueWithPoint:coordinates]};
//					app.spot = counter.intValue;
//					app.dockPoint = coordinates;
//					app.dockPoint = (__bridge_transfer CGPoint)coordinates;
//					app.x 	 = $float(posX.floatValue);
//					app.y	 = $float(posY.floatValue);
					//					if ([delegate respondsToSelector:@selector(setStartupStepStatus:)]) {
					//						[delegate setNumberOfDBXObjects:[app.spot intValue]];
					//						NSLog(@"CurrentCount: %i.  Delegate message sent",[app.spot intValue]);
					//						[self.delegate madeDBXApp:app];	}	else NSLog(@"Couldnt update count with delegate");
					counter = [counter increment];
					return d;		//stepper++;
				} //if error success
			} // if preferreed role
		}
		return nil;
		[AZStopwatch stop:@"makeDock"];
	}];//dock enumerator
//	NSLog(@"** GetDockDone: Aquired from AX. **\n Sendinging notofcation \"setStartupStepStatus\"= ** 1 **. \n  Also, will send setNumberOfDBXObjects: ** %ld **.", theApps.count); //[self.delegate setStartupStepStatus:1];
//	if ([self.delegate respondsToSelector:@selector(setStartupStepStatus:)])   [[self delegate] didFinishDBXInit];

//	return theApps;//.mutableCopy;
}


- (CGPoint) locationNowForAppWithPath:(NSString*)aPath {
	[AZStopwatch start:@"getPoint"];
	__block CGPoint thePoint = CGPointMake(0,0);	AXUIElementRef appElement = NULL;
	appElement = AXUIElementCreateApplication(	[[[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.dock"]
													lastObject] processIdentifier]);
	if (appElement == NULL) return thePoint;
	AXUIElementRef firstChild 	= (AXUIElementRef)
	[[self subelementsFromElement:appElement forAttribute:@"AXChildren"] objectAtIndex:0];
	NSArray *children 	= [self subelementsFromElement:firstChild forAttribute:@"AXChildren"];
	[children enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		AXUIElementRef axElement =  (AXUIElementRef)obj;		CFTypeRef role; 	id preferredrole;
		AXError result4 = AXUIElementCopyAttributeValue(axElement, kAXSubroleAttribute,&role);
		if (result4 == kAXErrorSuccess) {
			if (AXValueGetType(role) != kAXValueIllegalType) preferredrole = [NSValue valueWithPointer:role];
			else preferredrole = (id)role;
			if ([preferredrole isEqualToString:@"AXApplicationDockItem"]) {
				CFTypeRef name;
				AXError result = AXUIElementCopyAttributeValue(axElement, kAXTitleAttribute, &name);
				if (result == kAXErrorSuccess) {
					// 	id titleValue; if (AXValueGetType(name) != kAXValueIllegalType) titleValue = [NSValue valueWithPointer:name]; } else  titleValue = (id)name;
					CFTypeRef path;		id URLvalue; id convertedURL;
					AXError result2 = AXUIElementCopyAttributeValue(axElement, kAXURLAttribute, &path);
					if (result2 == kAXErrorSuccess) {
						if 		(AXValueGetType(path) != kAXValueIllegalType) URLvalue = [NSValue valueWithPointer:path];
						else	URLvalue = (id)path;
					}
					convertedURL = (NSString*)[(NSURL *)URLvalue path];
					if ([convertedURL isEqualToString:aPath]) {
						//qit matched, make point, return yes
						CFTypeRef position;	CGPoint coordinates;
						AXError result3 = AXUIElementCopyAttributeValue(axElement, kAXPositionAttribute, &position);
						if (result3 == kAXErrorSuccess)	{
							if (AXValueGetValue(position, kAXValueCGPointType, &coordinates)) {
							thePoint = coordinates;
							stop = YES;
							}
						}
					}
				}
			}
		}
	}];
	[AZStopwatch stop:@"getPoint"];
	return thePoint;
}

- (NSArray *)subelementsFromElement:(AXUIElementRef)element forAttribute:(NSString *)attribute {
	NSArray *subElements = nil;	CFIndex count = 0;	AXError result;
	result = AXUIElementGetAttributeValueCount(element, (__bridge CFStringRef)attribute, &count);
	if (result != kAXErrorSuccess) return nil;
	result = AXUIElementCopyAttributeValues(element, (__bridge CFStringRef)attribute, 0, count, (CFArrayRef *)&subElements);
	if (result != kAXErrorSuccess) return nil;
	return subElements;	// autorelease];	
}



@end
