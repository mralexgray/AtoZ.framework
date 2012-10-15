//
//  VageenFactory.m
//  VageenFactory
//
//  Created by Alex Gray on 10/14/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import "VageenFactory.h"

@implementation VageenFactory




+(NSBezierPath*) vageen {

	NSBezierPath *u = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0,0,500, 500)];
	[u setLineWidth:33];
	return u;
}
@end
