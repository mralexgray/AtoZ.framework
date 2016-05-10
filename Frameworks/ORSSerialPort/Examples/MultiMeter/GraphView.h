//
//  GraphView.h
//  MacduinoScope
//
//  Created by Gabe Ghearing on 4/22/09.
//  Copyright 2009 Gabe Ghearing. All rights reserved.
//

@import AppKit;


// the maximum number of points in the graph buffer
#define MAX_GRAPH_BUFFER_SIZE 2000

@interface GraphView : NSView {
@public
	IBOutlet NSPopUpButton *divisionPullDown, *sampleTypePullDown;
	IBOutlet NSColorWell *graphColorWell;

@private
	float mouseSelection[2]; // the mouse selection
}

@property float * dataBuffer;		// the data to chart
@property int			dataLength;		// the amount of data to chart
@property float		samplePeriod,	// the length of time of the sample
																// the calculated stuff
									selectedMin, selectedMax, selectedRMS, selectedTime;
@property BOOL		hasSelection;

@end
