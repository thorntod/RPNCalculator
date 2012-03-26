//
//  RPNCalculatorBrain.h
//  RPNCalculator
//
//  Created by David Thornton on 27/02/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPNCalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;


+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

// a readonly (Immutable) array that is a copy of the internal programStack
@property (readonly) id program;

@end
