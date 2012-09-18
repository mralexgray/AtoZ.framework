
	//  AZDockQuery.m
	//  AtoZ

	//  Created by Alex Gray on 7/5/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import "AtoZ.h"
#import "AZDockQuery.h"

@implementation AZDockQuery
//@synthesize dock;


+ (NSArray*) dock {
	return [AZDockQuery sharedInstance].dock;
}

- (NSArray *) dock {

	if (!_dock)  {
		__block NSMutableArray *dockItems = [NSMutableArray array];

		[AZStopwatch start:@"makeDock"];  NSLog(@"A dock is born!");
		AXUIElementRef appElement = NULL;
		appElement = AXUIElementCreateApplication(
												  [[[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.dock"] lastObject] processIdentifier]);
		if (appElement == NULL) return nil;
		AXUIElementRef firstChild 	=
		(AXUIElementRef) [[self subelementsFromElement:appElement forAttribute:@"AXChildren"]objectAtIndex:0];
		NSArray *children 	= [self subelementsFromElement:firstChild forAttribute:@"AXChildren"];


		[children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

			AXUIElementRef axElement =  (AXUIElementRef)obj;
			CFTypeRef role;
			id preferredrole;
			AXError resultRole = AXUIElementCopyAttributeValue(axElement, kAXSubroleAttribute,&role);
			if (resultRole == kAXErrorSuccess) {
				if (AXValueGetType(role) != kAXValueIllegalType) preferredrole = [NSValue valueWithPointer:role];
				else preferredrole = (id)role;
				if ([preferredrole isEqualToString:@"AXApplicationDockItem"]) {

					CFTypeRef name;
					AXError resultName = AXUIElementCopyAttributeValue(axElement, kAXTitleAttribute, &name);
					if (resultName == kAXErrorSuccess) {
							// 	id titleValue; if (AXValueGetType(name) != kAXValueIllegalType) titleValue = [NSValue valueWithPointer:name]; } else  titleValue = (id)name;
						CFTypeRef path;
						id URLvalue = nil;
						id convertedURL = nil;
						AXError resultPath = AXUIElementCopyAttributeValue(axElement, kAXURLAttribute, &path);
						if (resultPath == kAXErrorSuccess) {
							if 		(AXValueGetType(path) != kAXValueIllegalType)
								URLvalue = [NSValue valueWithPointer:path];
							else	URLvalue = (id)path;
						}

						if (URLvalue) convertedURL = (NSString*)[(NSURL *)URLvalue path];
							//	NSURL *convertedURL = (__bridge CFURLRef)&URLvalue;
						CFTypeRef position;
						CGPoint coordinates = NSPointToCGPoint(NSZeroPoint);
						AXError resultPosition = AXUIElementCopyAttributeValue(axElement, kAXPositionAttribute, &position);
						if (resultPosition == kAXErrorSuccess)	{
							if (AXValueGetValue(position, kAXValueCGPointType, &coordinates)) {
									//								//	NSLog(@"position: (%f, %f)", coordinates.x, coordinates.y);
							}
						}

						if ( convertedURL != nil) {
							AZDockItem *d =  [AZDockItem instanceWithPath:convertedURL];
							d.spot = idx;
							d.dockPoint = coordinates;

							[dockItems addObject:d];		//stepper++;
						}
					} //if error success
				} // if preferreed role
			}
				//			return;
		}];//dock enumerator
		   //	NSLog(@"** GetDockDone: Aquired from AX. **\n Sendinging notofcation \"setStartupStepStatus\"= ** 1 **. \n  Also, will send setNumberOfDBXObjects: ** %ld **.", theApps.count); //[self.delegate setStartupStepStatus:1];
		   //	if ([self.delegate respondsToSelector:@selector(setStartupStepStatus:)])   [[self delegate] didFinishDBXInit];

			//	return theApps;//.mutableCopy;
		_dock = dockItems.copy;
		[AZStopwatch stop:@"makeDock"];

	} //if _dock noexista
	return _dock;
}


- (CGPoint) locationNowForAppWithPath:(NSString*)aPath {
	[AZStopwatch start:@"getPoint"];
	__block CGPoint thePoint = CGPointMake(0,0);	AXUIElementRef appElement = NULL;
	appElement = AXUIElementCreateApplication(	[[[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.dock"]
												  lastObject] processIdentifier]);
	if (appElement == NULL) return thePoint;
	AXUIElementRef firstChild 	= (AXUIElementRef)
	[[self subelementsFromElement:appElement forAttribute:@"AXChildren"]objectAtIndex:0];
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
								*stop = YES;
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
