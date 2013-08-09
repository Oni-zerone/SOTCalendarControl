//
//  SOTCalendarControl.h
//  SOTCalendarViewController
//
//  Created by Oni_01 on 01/08/13.
//  Copyright (c) 2013 Andrea Altea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (AutoLayoutTrace)
+(UIWindow *)keyWindow;
-(NSString *)_autolayoutTrace;
@end

@interface SOTCalendarControl : UIControl

@property NSDate *startDate;
@property NSDate *selectedDate;

-(id)initWithDate:(NSDate *)date;

-(void)selectNextDate;
-(void)selectPrevDate;

-(NSInteger)numberOfDays;

@end


@interface SOTDayCell : UICollectionViewCell{
    BOOL __today;
}
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *weekDayLabel;
@property (strong, nonatomic) NSDate *day;

@property BOOL today;

@end