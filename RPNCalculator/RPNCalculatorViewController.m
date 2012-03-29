//
//  RPNCalculatorViewController.m
//  RPNCalculator
//
//  Created by David Thornton on 27/02/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "RPNCalculatorBrain.h"

@interface RPNCalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) RPNCalculatorBrain *brain;

@property (nonatomic, strong) NSMutableDictionary *variablesDict;

@end

//--------------------------------------------------

@implementation RPNCalculatorViewController

@synthesize display = _display;
@synthesize infixDisplay = _infixDisplay;
@synthesize xLabel = _xLabel;
@synthesize yLabel = _yLabel;
@synthesize zLabel = _zLabel;

@synthesize variablesDict = _variablesDict;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTHeMiddleOfEnteringANumber;
@synthesize brain = _brain;


//--------------------------------------------------
//Override the getter to ensure a brain has been initialised before trying to return it
- (RPNCalculatorBrain *)brain {
    if (! _brain) _brain = [[RPNCalculatorBrain alloc] init];
    return _brain;
}

- (NSDictionary *)variablesDict {
    if (! _variablesDict) _variablesDict = [[NSMutableDictionary alloc] init];
    return _variablesDict;
}

//--------------------------------------------------
- (IBAction)testButtonPressed:(UIButton *)sender {
    
    NSString *currentTitle = sender.currentTitle;
    NSInteger xValue;
    NSInteger yValue;
    NSInteger zValue;
    
    if ([currentTitle isEqualToString:@"Test 1"]) {
        xValue = 3;
        yValue = 6;
        zValue = 9;
    } else if ([currentTitle isEqualToString:@"Test 2"]) {
        xValue = 1;
        yValue = 2;
        zValue = 3;
    } else if ([currentTitle isEqualToString:@"Test 3"]) {
        xValue = 4;
        yValue = 12;
        zValue = 26;
    }
    
    [self.variablesDict setValue:[NSNumber numberWithInt:xValue] forKey:@"x"];
    [self.variablesDict setValue:[NSNumber numberWithInt:yValue] forKey:@"y"];
    [self.variablesDict setValue:[NSNumber numberWithInt:zValue] forKey:@"z"];
    
    self.xLabel.text = [NSString stringWithFormat:@"x = %i", xValue];
    self.yLabel.text = [NSString stringWithFormat:@"y = %i", yValue];
    self.zLabel.text = [NSString stringWithFormat:@"z = %i", zValue];
    
    double result = [RPNCalculatorBrain runProgram:self.brain.program usingVariableValues:self.variablesDict];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.infixDisplay.text = [RPNCalculatorBrain descriptionOfProgram:self.brain.program];

}
//--------------------------------------------------
- (NSInteger)xValue {    
    return [[self.variablesDict objectForKey:@"x"] intValue];
}

//--------------------------------------------------
- (NSInteger)yValue {    
    return [[self.variablesDict objectForKey:@"y"] intValue];
}

//--------------------------------------------------
- (NSInteger)zValue {    
    return [[self.variablesDict objectForKey:@"z"] intValue];
}



//--------------------------------------------------
- (IBAction)digitPressed:(UIButton *)sender 
{
    // use the title of the UIButton as the digital value
    NSString *digit = sender.currentTitle;
    //NSLog(@"digit pressed = %@", digit);
    
    // Check if this is not the initial number entered
    if (self.userIsInTheMiddleOfEnteringANumber) {

        //check for a valid floating point number
        // if there is already a . in the number ignore any subsequent . key presses
        if ([digit isEqualToString:@"."]) {
            NSNumberFormatter *NF = [[NSNumberFormatter alloc] init];
            [NF setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *testNumber = [NF numberFromString:[self.display.text stringByAppendingString:digit]];
            
            // if there is already a valid float in the display a second one will invalidate it so ignore it
            if (![testNumber floatValue]) {
                digit = @"";
            }
        }

        // append the entered digital to the number in the display
        self.display.text = [self.display.text stringByAppendingString:digit];

    } else {
        // This is the first digit entered so display it and set the entering flag to true
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = TRUE;
    }

}

//--------------------------------------------------
- (IBAction)operationPressed:(UIButton *)sender {

    NSString *operationString = sender.currentTitle;
    [self enterPressed];
    [self.brain pushOperand:operationString];
 
//    [self.brain performOperation:operationString];
//    double result = [self.brain performOperation:operationString];
    //NSLog(@"vaariables dict %@", self.variablesDict);
    double result = [RPNCalculatorBrain runProgram:self.brain.program usingVariableValues:self.variablesDict];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.infixDisplay.text = [RPNCalculatorBrain descriptionOfProgram:self.brain.program];

}

//--------------------------------------------------
- (IBAction)variableValuePressed:(UIButton *)sender {
  
    NSString *currentTitle = sender.currentTitle;
    NSInteger varValue;
    
    if ([currentTitle isEqualToString:@"x"]) {
        varValue = self.xValue;
    } else if ([currentTitle isEqualToString:@"y"]) {
        varValue = self.yValue;
    } else if ([currentTitle isEqualToString:@"z"]) {
        varValue = self.zValue;
    }
    [self.brain pushOperand:currentTitle];
    //NSLog(@"varvalue %i", varValue);

}


//--------------------------------------------------
- (IBAction)undoPressed {
    if (self.userIsInTheMiddleOfEnteringANumber){
        //remove last digit
        //if is last digit set flag to false
        int lengthOfDisplay = self.display.text.length;
        
        NSString *newString = [self.display.text substringToIndex:lengthOfDisplay - 1];
        self.display.text = newString;
        if (lengthOfDisplay == 1) {
            self.userIsInTheMiddleOfEnteringANumber = FALSE;
        }
    } else {
        [self.brain popOffStack];
        //NSLog(@"vaariables dict %@", self.variablesDict);
        double result = [RPNCalculatorBrain runProgram:self.brain.program usingVariableValues:self.variablesDict];
        NSString *resultString = [NSString stringWithFormat:@"%g", result];
        self.display.text = resultString;
        self.infixDisplay.text = [RPNCalculatorBrain descriptionOfProgram:self.brain.program];
    }    
    //NSLog(@"stackcheck: %@", self.brain.program);
        
}

//--------------------------------------------------
- (IBAction)enterPressed {
    if (self.userIsInTheMiddleOfEnteringANumber){
        
        NSNumber *digitToPush = [[NSNumber alloc] initWithDouble:[self.display.text doubleValue]];
        [self.brain pushOperand:digitToPush];

        //NSLog(@"MMMM Brain: %@", [self.brain program]);
        self.userIsInTheMiddleOfEnteringANumber = FALSE;
    }
}

//--------------------------------------------------
- (IBAction)clearButtonPressed {
    self.display.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = FALSE;
}
@end
