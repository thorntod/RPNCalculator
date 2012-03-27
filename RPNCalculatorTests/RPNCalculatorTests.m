//
//  RPNCalculatorTests.m
//  RPNCalculatorTests
//
//  Created by David Thornton on 26/03/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import "RPNCalculatorTests.h"
#import "RPNCalculatorBrain.h"



@implementation RPNCalculatorTests

RPNCalculatorBrain *calculator;


- (void)setUp
{
    [super setUp];
    NSLog(@"%@ setUp", self.name);
    calculator = [[RPNCalculatorBrain alloc] init];
    
  //  NSArray *dtArray = [[NSArray alloc] initWithObjects:@"a",@"b",@"c",@"alpha",@"beta", nil];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    NSLog(@"%@ tearDown", self.name);
}

//--------------------------------------------------------------------------------------------------------
- (void) testAddition {
    NSLog(@"%@ start", self.name);   // self.name is the name of the test-case method.
    [calculator pushOperand:[NSNumber numberWithDouble:5.0]];
    [calculator pushOperand:[NSNumber numberWithDouble:3.0]];
    [calculator performOperation:@"+"];
    
    NSLog(@"testAddition: 5.0 + 3.0 = %f", [RPNCalculatorBrain runProgram:calculator.program]);
    //  
    STAssertTrue([RPNCalculatorBrain runProgram:calculator.program] == 8.0, @"5 + 3");
    NSLog(@"%@ end", self.name);
}

//--------------------------------------------------------------------------------------------------------
- (void) testExample1 {
    [calculator pushOperand:[NSNumber numberWithDouble:3.0]];
    [calculator pushOperand:[NSNumber numberWithDouble:5.0]];
    [calculator pushOperand:[NSNumber numberWithDouble:6.0]];
    [calculator pushOperand:[NSNumber numberWithDouble:7.0]];
    [calculator performOperation:@"+"];
    [calculator performOperation:@"*"];
    [calculator performOperation:@"-"];
    
    NSLog(@"testExample1: '3 5 6 7 + * -' => %f", [RPNCalculatorBrain runProgram:calculator.program usingVariableValues:[[NSDictionary alloc] init] ]);
    STAssertTrue([RPNCalculatorBrain runProgram:calculator.program usingVariableValues:[[NSDictionary alloc] init] ] == -62.0, nil);
}

@end
