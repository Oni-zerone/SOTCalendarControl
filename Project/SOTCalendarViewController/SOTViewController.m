//
//  SOTViewController.m
//  SOTCalendarViewController
//
//  Created by Oni_01 on 29/07/13.
//  Copyright (c) 2013 Andrea Altea. All rights reserved.
//

#import "SOTViewController.h"
#import "SOTCalendarControl.h"

@interface SOTViewController ()
@property (strong, nonatomic)SOTCalendarControl *calendarControl;

@end

@implementation SOTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _calendarControl = [[SOTCalendarControl alloc] initWithDate:[NSDate dateWithTimeIntervalSinceNow:-10800]];
    [self.view addSubview: _calendarControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)prev:(id)sender {
    [_calendarControl selectPrevDate];
}

- (IBAction)next:(id)sender {
    [_calendarControl selectNextDate];
}
@end
