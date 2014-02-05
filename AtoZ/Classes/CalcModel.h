	//  CalcButton.h
	//  Calc
	//  Created by Tom Gallacher on 15/11/2010.


typedef enum _arithmeticOperator {
	noFish = 0,
	devideOperator = 1, 
	multiplyOperator = 2, 
	addOperator = 3, 
	subtractOperator = 4,
	clearOperator = 5
} arithmeticOperator;

@interface 	CalcModel : NSObject
//{
//	double accumulatorValue;
//	double transientValue;
//	BOOL restartText;
@property (nonatomic, assign) arithmeticOperator currentOperation;
//}

- (void) numberInput:(NSString*)buttonNumber;
- (void) doArithmetic;
- (void) operatorAction:(arithmeticOperator)type;
@property (nonatomic, assign) NSInteger accumulatorValue;
@property (nonatomic, assign) NSInteger transientValue;
@property (nonatomic, assign) BOOL restartText;

@end
