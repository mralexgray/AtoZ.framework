	//
	//  CalcButton.h
	//  Calc
	//
	//  Created by Tom Gallacher on 15/11/2010.
	//  Copyright 2010 __MyCompanyName__. All rights reserved.
	//

#import <Cocoa/Cocoa.h>

typedef enum _arithmeticOperator {
	noFish = 0,
	devideOperator = 1, 
	multiplyOperator = 2, 
	addOperator = 3, 
	subtractOperator = 4,
	clearOperator = 5
} arithmeticOperator;

@interface 	CalcModel : NSObject {
	
	double accumulatorValue;
	double transientValue;
	BOOL restartText;
	arithmeticOperator currentOperation;
}

- (void)numberInput:(NSString*)buttonNumber;
-(void)doArithmetic;
-(void)operatorAction:(arithmeticOperator)type;
@property double accumulatorValue;
@property double transientValue;
@property BOOL restartText;

@end