//
//  RPNCalculatorViewController.h
//  RPNCalculator
//
//  Created by David Thornton on 27/02/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPNCalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

@property (weak, nonatomic) IBOutlet UILabel *infixDisplay;

@end
