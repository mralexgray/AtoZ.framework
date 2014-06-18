	//  CalcButton.h
	//  Calc
	//  Created by Tom Gallacher on 15/11/2010.

#import <Foundation/Foundation.h>

typedef enum _arithmeticOperator {
	noFish = 0,
	devideOperator = 1, 
	multiplyOperator = 2, 
	addOperator = 3, 
	subtractOperator = 4,
	clearOperator = 5
} arithmeticOperator;

@interface 	CalcModel : NSObject

@property (nonatomic, assign) arithmeticOperator currentOperation;

- (void) numberInput:(NSString*)buttonNumber;
- (void) doArithmetic;
- (void) operatorAction:(arithmeticOperator)type;
@property (nonatomic) NSInteger accumulatorValue,transientValue;
@property (nonatomic) BOOL restartText;

@end

//{
//	double accumulatorValue;
//	double transientValue;
//	BOOL restartText;
//}
