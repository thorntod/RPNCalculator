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
    
    NSArray *dtArray = [[NSArray alloc] initWithObjects:@"a",@"b",@"c",@"alpha",@"beta", nil];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    NSLog(@"%@ tearDown", self.name);
}

- (void) testAddition {
    NSLog(@"%@ start", self.name);   // self.name is the name of the test-case method.
    [calculator pushOperand:5.0];
    [calculator pushOperand:3.0];
    [calculator performOperation:@"+"];
    
    NSLog(@"testAddition: 5.0 + 3.0 = %f", [RPNCalculatorBrain runProgram:calculator.program]);
    //  
    STAssertTrue([RPNCalculatorBrain runProgram:calculator.program] == 8.0, @"5 + 3");
    NSLog(@"%@ end", self.name);
}
@end
