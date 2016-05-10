//
//  GraphView.m
//  MacduinoScope
//
//  Created by Gabe Ghearing on 4/22/09.
//  Copyright 2009 Gabe Ghearing. All rights reserved.
//

#import "GraphView.h"


@implementation GraphView

@synthesize dataLength, dataBuffer, samplePeriod;

@synthesize selectedMin, selectedMax, selectedRMS, selectedTime, hasSelection;


- (BOOL)acceptsFirstResponder { return YES; }

- (void)drawRect:(NSRect)rect {
	NSBezierPath *path;
	NSRect bounds = [self bounds];
	NSColor *backgroundBarColor = [NSColor colorWithCalibratedWhite:0.5 alpha:0.15];
	NSColor *backgroundBarColorMain = [NSColor colorWithCalibratedWhite:0.5 alpha:0.35];
	float width, height;
	int divUnits;
	int divBound;
	
	width = NSMaxX(bounds);
	height = NSMaxY(bounds);
	
	// draw a box around the graph
	path = [NSBezierPath bezierPath];	
	[path moveToPoint: NSMakePoint ( 0, height )];
	[path lineToPoint: NSMakePoint ( width, height )];
	[path lineToPoint: NSMakePoint ( width, 0 )];
	[path lineToPoint: NSMakePoint ( 0, 0 )];
	[path lineToPoint: NSMakePoint ( 0, height )];	
	[backgroundBarColor set];
	[path stroke];
	
	switch ([divisionPullDown indexOfSelectedItem]) {
		case 0: // 2
			divUnits = 2;
			divBound = 3;
			break;
		case 1: // 3
			divUnits = 3;
			divBound = 1;
			break;
		case 2: // 8
			divUnits = 2;
			divBound = 9;
			break;
		case 3: // 10
			divUnits = 10;
			divBound = 1;
			break;
		case 4: // 12
			divUnits = 3;
			divBound = 5;
			break;
		case 5: // 16
			divUnits = 2;
			divBound = 17;
			break;
		case 6: // 32
			divUnits = 2;
			divBound = 33;
			break;
		case 7: // 64
			divUnits = 2;
			divBound = 65;
			break;
		default: // 100
			divUnits = 10;
			divBound = 11;
			break;
	}
	
	if(divUnits==10) {
		// divide the screen in 10ths or 100ths
		path = [NSBezierPath bezierPath];
		[path moveToPoint: NSMakePoint ( 0, (height/2) )];
		[path lineToPoint: NSMakePoint ( width, (height/2) )];
		[backgroundBarColorMain set];
		[path setLineWidth:2];
		[path stroke];
		
		path = [NSBezierPath bezierPath];
		[path moveToPoint: NSMakePoint ( (width/2), 0 )];
		[path lineToPoint: NSMakePoint ( (width/2), height )];
		[backgroundBarColorMain set];
		[path setLineWidth:2];
		[path stroke];
		for(int i=0;i<11;i++) {
			path = [NSBezierPath bezierPath];
			[path moveToPoint: NSMakePoint ( 0, ((height/10)*i))];
			[path lineToPoint: NSMakePoint ( width, ((height/10)*i) )];
			[backgroundBarColor set];
			[path setLineWidth:1];
			[path stroke];
			
			path = [NSBezierPath bezierPath];
			[path moveToPoint: NSMakePoint ( ((width/10)*i), 0 )];
			[path lineToPoint: NSMakePoint ( ((width/10)*i), height )];
			[backgroundBarColor set];
			[path setLineWidth:1];
			[path stroke];
			for(int j=0;j<divBound;j++) {
				path = [NSBezierPath bezierPath];
				[path moveToPoint: NSMakePoint ( 0, ((height/10)*i) + ((height/100)*j) )];
				[path lineToPoint: NSMakePoint ( width, ((height/10)*i) + ((height/100)*j) )];
				[backgroundBarColor set];
				[path setLineWidth:0.5];
				[path stroke];
				
				path = [NSBezierPath bezierPath];
				[path moveToPoint: NSMakePoint ( ((width/10)*i) + ((width/100)*j), 0 )];
				[path lineToPoint: NSMakePoint ( ((width/10)*i) + ((width/100)*j), height )];
				[backgroundBarColor set];
				[path setLineWidth:0.5];
				[path stroke];
			}
		}
	} else if(divUnits==2) {
		// divide the screen by 2,4,8,16, or 32
		for(int i=2;i<divBound;i+=i) { // 9=8divisions, 17=16divisions, etc
			for(int j=1;j<i;j++) {
				path = [NSBezierPath bezierPath];
				[path moveToPoint: NSMakePoint ( 0, (height/i)*j )];
				[path lineToPoint: NSMakePoint ( width, (height/i)*j )];
				[backgroundBarColor set];
				[path stroke];
				
				path = [NSBezierPath bezierPath];
				[path moveToPoint: NSMakePoint ( (width/i)*j, 0 )];
				[path lineToPoint: NSMakePoint ( (width/i)*j, height )];
				[backgroundBarColor set];
				[path stroke];
			}
		}
	} else if(divUnits==3) {
		// divide the screen in 3rds or 9ths
		for(int i=0;i<4;i++) {
			path = [NSBezierPath bezierPath];
			[path moveToPoint: NSMakePoint ( 0, ((height/3)*i))];
			[path lineToPoint: NSMakePoint ( width, ((height/3)*i) )];
			[backgroundBarColor set];
			[path setLineWidth:1];
			[path stroke];
			
			path = [NSBezierPath bezierPath];
			[path moveToPoint: NSMakePoint ( ((width/3)*i), 0 )];
			[path lineToPoint: NSMakePoint ( ((width/3)*i), height )];
			[backgroundBarColor set];
			[path setLineWidth:1];
			[path stroke];
			for(int j=0;j<divBound;j++) {
				path = [NSBezierPath bezierPath];
				[path moveToPoint: NSMakePoint ( 0, ((height/3)*i) + ((height/12)*j) )];
				[path lineToPoint: NSMakePoint ( width, ((height/3)*i) + ((height/12)*j) )];
				[backgroundBarColor set];
				[path setLineWidth:0.5];
				[path stroke];
				
				path = [NSBezierPath bezierPath];
				[path moveToPoint: NSMakePoint ( ((width/3)*i) + ((width/12)*j), 0 )];
				[path lineToPoint: NSMakePoint ( ((width/3)*i) + ((width/12)*j), height )];
				[backgroundBarColor set];
				[path setLineWidth:0.5];
				[path stroke];
			}
		}
	}
	
	/*
	// draw a sign wave
	path = [NSBezierPath bezierPath];
	[path moveToPoint: NSMakePoint ( 0, sin(1)*height )];
	for(int i=0;i<1000;i++) {
		[path lineToPoint: NSMakePoint ( i*(width/1000.0), ((cos(i/500.0*3.14)*height)/2)+(height/2) )];
	}
	[[NSColor colorWithDeviceRed:0.2 green:0.1 blue:0.1 alpha:0.3] set];
	[path stroke];
	*/
	
	if((fabs(mouseSelection[0]-mouseSelection[1])*NSMaxX([self bounds]))>3){
		hasSelection = TRUE;
	} else {
		hasSelection = FALSE;
	}
	
	if(dataLength>0) {
		if([sampleTypePullDown indexOfSelectedItem]==0) {
			// plot everything
			path = [NSBezierPath bezierPath];
			[path moveToPoint: NSMakePoint ( -100, sin(1)*height )];
			for(int i=0;i<dataLength;i++) {
				[path lineToPoint: NSMakePoint ( i*(width/(dataLength-1)), (dataBuffer[i]*height) )];
			}
			[[graphColorWell color] set];
			[path setLineWidth:1];
			[path stroke];
		} else {
			// average the sample out
			path = [NSBezierPath bezierPath];
			[path moveToPoint: NSMakePoint ( -100, sin(1)*height )];
			float avgVal;
			float avgValNum;
			for(int i=0;i<width;i++) {
				avgVal = dataBuffer[(int)(i*(dataLength/width))];
				avgValNum = 1;
				for(int j=1;j<(dataLength/width);j++) {
					avgVal += dataBuffer[j+(int)(i*(dataLength/width))];
					avgValNum++;
				}
				avgVal = avgVal/avgValNum;
				[path lineToPoint: NSMakePoint ( i, (avgVal*height) )];
			}
			[[graphColorWell color] set];
			[path setLineWidth:1];
			[path stroke];
		}
		
		
		if(hasSelection) {
			// draw the selection box
			path = [NSBezierPath bezierPath];
			[path moveToPoint: NSMakePoint ( (mouseSelection[0]*width), -10)];
			[path lineToPoint: NSMakePoint ( (mouseSelection[0]*width), height)];
			[path lineToPoint: NSMakePoint ( (mouseSelection[1]*width), height)];
			[path lineToPoint: NSMakePoint ( (mouseSelection[1]*width), -10)];
			[path lineToPoint: NSMakePoint ( (mouseSelection[0]*width), -10)];
			[[NSColor colorWithDeviceRed:0.2 green:0.1 blue:0.1 alpha:0.3] set];
			[[NSColor colorWithDeviceRed:0.2 green:0.3 blue:0.3 alpha:0.15] setFill];
			[path fill];
			[path stroke];
			
			
			//calculate the selection values
			
			float low, high;
			if(mouseSelection[0]<mouseSelection[1]) {
				low = mouseSelection[0];
				high = mouseSelection[1];
			} else {
				low = mouseSelection[1];
				high = mouseSelection[0];
			}
			selectedRMS=0;
			selectedMin=1;
			selectedMax=0;
			for(int i=dataLength*low;i<dataLength*high;i++) {
				if(selectedMin>dataBuffer[i]) selectedMin = dataBuffer[i];
				if(selectedMax<dataBuffer[i]) selectedMax = dataBuffer[i];
				selectedRMS += dataBuffer[i];
			}
			selectedRMS = selectedRMS/(dataLength*fabs(mouseSelection[0]-mouseSelection[1]));
			selectedTime = samplePeriod * fabs(mouseSelection[0]-mouseSelection[1]);
		}
	}
	
}

- (float) getMouseX:(NSEvent*)theEvent {
	float l = ([theEvent locationInWindow].x-[self frame].origin.x) / NSMaxX([self bounds]);
	if(l<0)l=0;
	if(l>1)l=1;
	return l;
}

- (void)mouseDown:(NSEvent*)theEvent {
	float l = [self getMouseX:theEvent];
	mouseSelection[0] = l;
	mouseSelection[1] = l;
}

- (void) mouseDragged:(NSEvent *)theEvent {
	mouseSelection[1] = [self getMouseX:theEvent];
}

- (void) mouseUp:(NSEvent *)theEvent {
	mouseSelection[1] = [self getMouseX:theEvent];
}

- (void) rightMouseDown:(NSEvent *)theEvent {
	
}

@end
