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

NSDictionary *mockVariables;
RPNCalculatorBrain *brain;
NSArray *whyTimesTwo;
NSArray *exPlusWhy;
NSArray *cosineOfZeroTimesPi;
NSArray *bakeMeSomePi;
NSArray *justEx;
NSArray *exampleA;
NSArray *exampleB;
NSArray *exampleC;
NSArray *exampleD;
NSArray *exampleE;
NSArray *exampleF;

- (void)setUp
{
    [super setUp];
    NSLog(@"%@ setUp", self.name);
    calculator = [[RPNCalculatorBrain alloc] init];
    
  //  NSArray *dtArray = [[NSArray alloc] initWithObjects:@"a",@"b",@"c",@"alpha",@"beta", nil];
    NSArray *values = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:23.0],[[NSNumber alloc]initWithDouble:42.0],[[NSNumber alloc]initWithDouble:-1.0],nil];
    
    
    NSArray *names = [[NSArray alloc]initWithObjects:@"x",@"y",@"y", nil];
    
    mockVariables = [[NSDictionary alloc]initWithObjects:values forKeys:names];    
    
    brain = [[RPNCalculatorBrain alloc] init];
    
    whyTimesTwo = [[NSArray alloc]initWithObjects:@"y", @"y", @"+" , nil ];
    cosineOfZeroTimesPi = [[NSArray alloc]initWithObjects:@"x", @"cos", @"PI", @"*", nil ];
    bakeMeSomePi = [[NSArray alloc]initWithObjects:@"pi", nil ];
    justEx = [[NSArray alloc]initWithObjects:@"x", nil ];
    exPlusWhy = [[NSArray alloc]initWithObjects:@"x", @"y", @"+", nil ];
    
    exampleA = [[NSArray alloc]initWithObjects:@"3", @"5", @"6", @"7", @"+", @"*", @"-" , nil ];
    exampleB = [[NSArray alloc]initWithObjects:@"3", @"5", @"+", @"sqrt", nil ];
    exampleC = [[NSArray alloc]initWithObjects:@"3", @"sqrt", @"sqrt", nil ];
    exampleD = [[NSArray alloc]initWithObjects:@"3", @"5", @"sqrt", @"+", nil ];
    exampleE = [[NSArray alloc]initWithObjects:@"PI", @"r", @"r", @"*", @"*", nil ];
    exampleF = [[NSArray alloc]initWithObjects:@"a", @"a", @"*", @"b", @"b", @"*", @"+", @"sqrt" , nil ];

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

- (void)testRunningProgramWithoutVariables
{
    [brain pushOperand:[[NSNumber alloc]initWithDouble:5.0]];
    [brain pushOperand:[[NSNumber alloc]initWithDouble:3.0]];
    [brain performOperation:@"+"];   
    double result = [RPNCalculatorBrain runProgram:brain.program];
    
    STAssertEquals( 8.0, result, @"bad result 5,3,+ should equal 8. got %lf!!", result );
}

- (void)testRunningProgramWithVariables
{
    double result = [RPNCalculatorBrain runProgram:whyTimesTwo usingVariableValues:mockVariables];
    NSLog( @"obtained result=%lf", result );
    STAssertEquals( 84.0, result, @"y,y,+ should equal 84!!" );
}


- (void)testRunningAnotherProgramWithVariables
{
    double result = [RPNCalculatorBrain runProgram:cosineOfZeroTimesPi usingVariableValues:mockVariables];
    NSLog( @"obtained result=%lf", result );
    STAssertEquals( M_PI, result, @"beta,cos,pi,* should equal PI!!" );
}


- (void)testDescriptionOfBakeMeSomePi
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:bakeMeSomePi];
    STAssertEqualObjects( @"pi", description, @"Should equal pi, but equals %@", description );
}



- (void)testDescriptionOfJustEx
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:justEx];
    STAssertEqualObjects( @"x", description, @"Should equal x, but equals %@", description );
}


- (void)testDescriptionOfExPlusWhy
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exPlusWhy];
    NSString *expected = @"x+y";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testDescriptionOfWhyPlusWhy
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:whyTimesTwo];
    NSString *expected = @"y+y";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testDescriptionOfSineOfBetaTimesPi
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:cosineOfZeroTimesPi];
    NSString *expected = @"cos(beta)*pi";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testDescriptionOfSineOfExampleA
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleA];
    NSString *expected = @"3-5*(6+7)";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testDescriptionOfSineOfExampleB
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleB];
    NSString *expected = @"sqrt(3+5)";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testDescriptionOfSineOfExampleC
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleC];
    NSString *expected = @"sqrt(sqrt(3))";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
    
}


- (void)testDescriptionOfSineOfExampleD
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleD];
    NSString *expected = @"3+sqrt(5)";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testDescriptionOfSineOfExampleE
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleE];
    NSString *expected = @"pi*r*r";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testDescriptionOfSineOfExampleF
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleF];
    NSString *expected = @"sqrt(a*a+b*b)";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}

- (void)testPrecedence
{
    NSArray *operatorsInOrder = [NSArray arrayWithObjects: @"-", @"+", @"/", @"*", @"sin", @"sqrt", nil ];
    int multiplicationPrecedence = [operatorsInOrder indexOfObject:@"*"];
    int divisionPrecedence = [operatorsInOrder indexOfObject:@"/"];
    int additionPrecedence = [operatorsInOrder indexOfObject:@"+"];
    int subtractionPrecedence = [operatorsInOrder indexOfObject:@"-"];
    int sinPrecedence = [operatorsInOrder indexOfObject:@"sin"];
    int sqrtPrecedence = [operatorsInOrder indexOfObject:@"sqrt"];
    int piPrecedence = [operatorsInOrder indexOfObject:@"pi"];
    
    NSLog( @"piPrecedence=%d", piPrecedence );
    
    STAssertTrue( 3 == multiplicationPrecedence, @"Multiply should be 3!!" );
    STAssertTrue( 2 == divisionPrecedence, @"divide should be 3!!" );
    STAssertTrue( 1 == additionPrecedence, @"add should be 3!!" );
    STAssertTrue( 0 == subtractionPrecedence, @"subtract should be 3!!" );
    STAssertTrue( 4 == sinPrecedence, @"sin should be 4!!" );
    STAssertTrue( 5 == sqrtPrecedence, @"sqrt should be 5!!" );
    //    STAssertTrue( -1 == piPrecedence, @"pi should be -1!!" );
    
}
@end
