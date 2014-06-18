	//
	//  CalcButton.m
	//  Calc
	//
	//  Created by Tom Gallacher on 15/11/2010.
	//  Copyright 2010 __MyCompanyName__. All rights reserved.
	//

#import "CalcModel.h"
#import "AtoZ.h"

@implementation CalcModel

@synthesize accumulatorValue;
@synthesize transientValue;
@synthesize restartText, currentOperation;

- (id)init {
	accumulatorValue = transientValue = 0.0;
	restartText = false;
	return self;
}

- (void) numberInput:(NSString*)buttonNumber {
	
	double number = [buttonNumber doubleValue];
	
	if (restartText) {		
		accumulatorValue = number;
		restartText = !restartText;
	} else {
		accumulatorValue = accumulatorValue * 10 + number;
	}
}

-(void)doArithmetic {
	switch (currentOperation) {
		case noFish:
			break;
		case devideOperator:
			if (accumulatorValue != 0.0) {
				accumulatorValue = transientValue / accumulatorValue;
			}
			break;
		case multiplyOperator:
			accumulatorValue = transientValue * accumulatorValue;
			break;
		case addOperator:
			accumulatorValue = transientValue + accumulatorValue;
			break;
		case subtractOperator:
			accumulatorValue = transientValue - accumulatorValue;
			break;
		case clearOperator:
		break;
	}
	restartText = !restartText;
	transientValue = 0.0;
	currentOperation = noFish;
}

-(void)operatorAction:(arithmeticOperator)type {
	if (type == clearOperator) {
		accumulatorValue = 0.0;
	} else if (currentOperation == noFish) {
		transientValue = accumulatorValue;
		currentOperation = type;
		restartText = !restartText;
	}
}

@end
