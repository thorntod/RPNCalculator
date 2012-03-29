//
//  RPNCalculatorBrain.m
//  RPNCalculator
//
//  Created by David Thornton on 27/02/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import "RPNCalculatorBrain.h"

//========================= INTERFACE ========================= 
@interface RPNCalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;

@end



//========================= IMPLEMENTATION =========================
@implementation RPNCalculatorBrain

static NSSet *_singleOperatorSet;
static NSSet *_twoOperatorSet;
static NSSet *_noOperatorSet;
static NSSet *_allOperations;
static NSArray *_operatorsInOrder = nil;


@synthesize programStack = _programStack;


//-------------------------------------------------
+ (NSSet *)singleOperatorSet 
{
    if (! _singleOperatorSet) {
        _singleOperatorSet = [NSSet setWithObjects:@"sqrt",@"sin",@"cos", nil];
    }
    return _singleOperatorSet;
}

+ (NSSet *)twoOperatorSet 
{
    if (! _twoOperatorSet) {
        _twoOperatorSet = [NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    }
    return _twoOperatorSet;
}

+ (NSSet *)noOperatorSet 
{
    if (! _noOperatorSet) {
        _noOperatorSet = [NSSet setWithObjects:@"PI", nil];
    }
    return _noOperatorSet;
}

+ (NSSet *)allOperations
{
    if ( ! _allOperations) {
        _allOperations = [NSSet setWithSet:self.singleOperatorSet];
        _allOperations = [_allOperations setByAddingObjectsFromSet:self.twoOperatorSet];
        _allOperations = [_allOperations setByAddingObjectsFromSet:self.noOperatorSet];
    }
    return _allOperations;
}

//-------------------------------------------------
+ (NSArray *)operatorsInOrder
{
    if (! _operatorsInOrder) {
        _operatorsInOrder = [NSArray arrayWithObjects: @"sin", @"cos", @"sqrt", @"-", @"+", @"/", @"*", nil];
    }
    return _operatorsInOrder;
}


//-------------------------------------------------
- (NSMutableArray *)programStack {
    
    if (! _programStack) _programStack = [[NSMutableArray alloc] init ];
    return _programStack;
}

//-------------------------------------------------
- (id)program {

    return [self.programStack copy];
}


//--------------===========================------------------
- (void)pushOperand:(id)operand {
    // add the current operand to the top of the stack
    
    [self.programStack addObject:operand];
    NSLog(@"pushOperand: after - stack: %@", self.programStack);
    
}

//-------------------------------------------------
- (double)popOperand {
    NSLog(@"start: popOperand");
    
    NSNumber *operandObject = [self.programStack lastObject];
    if (operandObject) [self.programStack removeLastObject];
    NSLog(@"stack: %@", self.programStack);
    return [operandObject doubleValue];
}

//-------------------------------------------------
- (double)performOperation:(NSString *)operation {
    
    [self.programStack addObject:operation];
    return [RPNCalculatorBrain runProgram:self.program];
}

//-------------------------------------------------
+ (NSString *)descriptionOfProgram:(id)program {
    
    NSString *result = @"";
    if ( [ program isKindOfClass:[NSArray class]] ) {
        NSMutableArray *copy = [program mutableCopy];
        result = [ RPNCalculatorBrain describeOperandOffStack:copy parentPrecedence:-1];
    }
    
    return result;
}

//-------------------------------------------------
+ (NSString *)describeOperandOffStack:(NSMutableArray *)stack parentPrecedence:(int)parentPrecedence
{
    NSString *result = nil;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    // if the top of stack is a regular old number, then just retrieve it and we're finished...
    // ---------------------------------------------------------------------------------------
    if ( [topOfStack isKindOfClass:[NSNumber class]] ) {
        NSNumber *number = (NSNumber *)topOfStack;
        result = [number stringValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        
        // is it a variable or an operation??
        // -----------------------------------
        if ( ! [ [RPNCalculatorBrain allOperations] containsObject:topOfStack ] )
        {
            // variable
            // -----------
            result = topOfStack;
            
        } else {
            // it's an operation....
            // ------------------------
            NSString *operation = topOfStack;
            
            int precedence = ( [[RPNCalculatorBrain operatorsInOrder]containsObject:operation]) ? [[RPNCalculatorBrain operatorsInOrder] indexOfObject:operation] : 0;
            
            if ( [ [RPNCalculatorBrain noOperatorSet] containsObject:operation ] ) result = operation;
            
            if ( [ [RPNCalculatorBrain singleOperatorSet] containsObject:operation ] ) {
                result = [[operation stringByAppendingString:@"(" ] stringByAppendingString:[RPNCalculatorBrain describeOperandOffStack:stack parentPrecedence:precedence] ];
                result = [result stringByAppendingString:@")" ];
            }
            
            if ( [ [RPNCalculatorBrain twoOperatorSet] containsObject:operation ] ) {
                NSString *rightOperandText = ( [ stack count ] > 1 ) ? [RPNCalculatorBrain describeOperandOffStack:stack parentPrecedence:precedence] : nil;
                NSString *leftOperandText = ( [ stack count ] > 0 ) ? [RPNCalculatorBrain describeOperandOffStack:stack parentPrecedence:precedence] : nil;
                result = ( parentPrecedence > precedence ) ? @"(" : @"";
                result = [result stringByAppendingString:( leftOperandText ? leftOperandText : @"0" )];
                result = [result stringByAppendingString:operation];
                result = [result stringByAppendingString:( rightOperandText ? rightOperandText : @"0" ) ];
                if ( parentPrecedence > precedence ) result = [result stringByAppendingString:@")"];
            }
        }
    }
    return result;
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    return [self popOperandOffStack:stack usingVariableValues:nil];
}

#pragma mark DT as here
- (id)popOffStack {
    
    id topOfStack = [self.programStack lastObject];
    if (topOfStack) [self.programStack removeLastObject];
    return topOfStack;
}

//-------------------------------------------------
+ (double)popOperandOffStack:(NSMutableArray *)stack usingVariableValues:(NSDictionary *)variableValues  {
 
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack usingVariableValues:variableValues] + [self popOperandOffStack:stack usingVariableValues:variableValues];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack usingVariableValues:variableValues] * [self popOperandOffStack:stack usingVariableValues:variableValues];
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack usingVariableValues:variableValues];
            if (divisor) result = [self popOperandOffStack:stack usingVariableValues:variableValues] / divisor;
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack usingVariableValues:variableValues];
            result = [self popOperandOffStack:stack usingVariableValues:variableValues] - subtrahend;
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack usingVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack usingVariableValues:variableValues]* M_PI/180);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack usingVariableValues:variableValues]* M_PI/180);
        } else if ([operation isEqualToString:@"PI"]) {
            result = M_PI;
        } else if ([variableValues objectForKey:operation]) {
            result = [[variableValues objectForKey:operation] doubleValue];
        }
    }
    return result;
}

//-------------------------------------------------
+ (double)runProgram:(id)program {
    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

//-------------------------------------------------
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    NSLog(@"runProgramwith %@", variableValues);
    return [self popOperandOffStack:stack usingVariableValues:variableValues];
}


//-------------------------------------------------
+ (NSSet *)variablesUsedInProgram:(id)program{
    
    NSSet *variableSet = [[NSSet alloc] initWithObjects:@"x",@"y",@"z", nil];
    return variableSet;
    
}


@end
