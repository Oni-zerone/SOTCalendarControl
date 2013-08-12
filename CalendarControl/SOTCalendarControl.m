//
//  SOTCalendarControl.m
//  SOTCalendarViewController
//
//  Created by Oni_01 on 01/08/13.
//  Copyright (c) 2013 Andrea Altea. All rights reserved.
//

#import "SOTCalendarControl.h"
#import <QuartzCore/QuartzCore.h>

@interface SOTCalendarControl () <UICollectionViewDataSource, UICollectionViewDelegate>{
    CGSize intrinsicSize;
    NSInteger numberOfDays;
}



@property UICollectionView *agendaCollection;
@property UILabel *currentLabel;

@property NSDate *firstDate;


-(void)setupInit;
-(void)loadInit;

-(void)setCurrentLabelWithDate:(NSDate *)date;
@end

@implementation SOTCalendarControl

-(id)initWithDate:(NSDate *)date{
    CGSize size = CGSizeMake(320.0f, 62.0f);
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if(self){
        intrinsicSize = size;
        [self setStartDate:date];
        [self setupInit];
    }
    return self;
}

- (void)setupInit
{
    //View
    [self setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.8f]];
    
    //SetUp FirstDate
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekcomponents = [calendar components:NSWeekdayCalendarUnit fromDate:_startDate];
    
    int dayCount = (([weekcomponents weekday]-1) == 0)? 6 : ([weekcomponents weekday]-2);
    
    numberOfDays = 56 - dayCount;
    
    _firstDate = [_startDate dateByAddingTimeInterval:-(3600 * 24 * dayCount)];

    
    //CollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setItemSize:CGSizeMake(44.0f, 44.0f)];
    [flowLayout setMinimumInteritemSpacing:0.f];
    [flowLayout setMinimumLineSpacing:0.f];
    
    _agendaCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 315, 44)
                                           collectionViewLayout:flowLayout];
    [_agendaCollection registerClass:[SOTDayCell class] forCellWithReuseIdentifier:@"DayCell"];
    [_agendaCollection setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[_agendaCollection setAllowsSelection:YES];       //Default Value
    [_agendaCollection setAllowsMultipleSelection:NO];
    [_agendaCollection setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_agendaCollection];
    
    [_agendaCollection setDelegate:self];
    [_agendaCollection setDataSource:self];
    
    //CurrentLabel
    _currentLabel = [[UILabel alloc] init];
    [_currentLabel setTextColor:[UIColor darkGrayColor]];
    [_currentLabel setBackgroundColor:[UIColor clearColor]];
    [_currentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
    [_currentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_currentLabel];
    
    [self performSelector:@selector(loadInit) withObject:nil afterDelay:0.1f];
}

-(void)loadInit{
    int item = 0;
    BOOL today = NO;

    do {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        SOTDayCell *cell = (SOTDayCell *)[_agendaCollection cellForItemAtIndexPath:indexPath];
        today = cell.today;
        
        if(today){
            [_agendaCollection selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionTop];
            [self setCurrentLabelWithDate:cell.day];
        }
        item++;
    } while (!today);
}


-(void)layoutSubviews{
    //Agenda Collection
    [_agendaCollection setBackgroundColor:[UIColor clearColor]];
    [_agendaCollection setPagingEnabled:YES];
    //Current Label
    
    //Constraints
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_agendaCollection, _currentLabel);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==1)-[_agendaCollection(==44)][_currentLabel]-(==1)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:viewDictionary];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[_agendaCollection(==308)]"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_agendaCollection)];
    [self addConstraints:constraints];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_currentLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_agendaCollection
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f];
    [self addConstraint:constraint];
    
    [super layoutSubviews];
    
    NSLog(@" %@", [[UIWindow keyWindow] _autolayoutTrace]);
}

-(UIEdgeInsets)alignmentRectInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)intrinsicContentSize{
     return intrinsicSize;
}

-(void)setCurrentLabelWithDate:(NSDate *)date{
    NSDateComponents *selectedComponents = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit)
                                                                           fromDate:date];
    
    NSArray *textWeekDays = @[@"", @"Domenica", @"Lunedì", @"Martedì", @"Mercoledì", @"Giovedì", @"Venerdì", @"Sabato"];
    NSArray *textMonths = @[@"", @"Gennaio", @"Febbraio", @"Marzo", @"Aprile", @"Maggio", @"Giugno", @"Luglio", @"Agosto", @"Settembre", @"Ottobre", @"Novembre", @"Dicembre"];
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %i %@ %i", textWeekDays[selectedComponents.weekday], selectedComponents.day, textMonths[selectedComponents.month], selectedComponents.year];
    
    [_currentLabel setText:dateString];
}

#pragma mark - CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 56;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SOTDayCell *cell = [_agendaCollection dequeueReusableCellWithReuseIdentifier:@"DayCell"
                                                                    forIndexPath:indexPath];
    
    NSDate *cellDay = [_firstDate dateByAddingTimeInterval: 86400 * indexPath.row];
    [cell setDay:cellDay];
    
    [cell setToday:[cellDay isEqualToDate:_startDate]];
    
    if([cellDay compare:_startDate] == NSOrderedAscending){
        [cell setUserInteractionEnabled:NO];
    }else{
        [cell setUserInteractionEnabled:YES];
    }
    
    return cell;
}

#pragma mark - CollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDate *selectedDate = [(SOTDayCell *)[collectionView cellForItemAtIndexPath:indexPath] day];
    [self setCurrentLabelWithDate:selectedDate];
    [self setSelectedDate:selectedDate];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark - Controller Target Action

-(void)selectNextDate{
    NSIndexPath *indexPath = [_agendaCollection indexPathsForSelectedItems][0];
    if([_agendaCollection numberOfItemsInSection:indexPath.section] > indexPath.row + 1){
        indexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
    }
    
    [_agendaCollection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}

-(void)selectPrevDate{
    NSIndexPath *indexPath = [_agendaCollection indexPathsForSelectedItems][0];
    if([_agendaCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row-1 inSection:indexPath.section]].userInteractionEnabled){
        indexPath = [NSIndexPath indexPathForItem:indexPath.row-1 inSection:indexPath.section];
    }
    
    [_agendaCollection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

-(NSInteger)numberOfDays{
    return self->numberOfDays;
}

@end

#pragma mark - Controller View Cell

@implementation SOTDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSetup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        //Initialization code
        [self initSetup];
    }
    return self;
}

-(void)initSetup{
    //self.layer.cornerRadius = 22.0f;
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    [backView.layer setCornerRadius:3.0f];
    [self setSelectedBackgroundView:backView];
    
    //Day Label
    _dayLabel = [[UILabel alloc] init];
    [_dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_dayLabel];
    
    //WeekDay Label
    _weekDayLabel = [[UILabel alloc] init];
    [_weekDayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_weekDayLabel];
}

-(void)layoutSubviews{    
    //Labels
    [_dayLabel setTextAlignment:NSTextAlignmentCenter];
    [_dayLabel setBackgroundColor:[UIColor clearColor]];
    [_dayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:25.0f]];
    
    [_weekDayLabel setTextAlignment:NSTextAlignmentCenter];
    [_weekDayLabel setBackgroundColor:[UIColor clearColor]];
    //[_weekDayLabel setTextColor:[UIColor darkGrayColor]];
    [_weekDayLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    
    //Constraints
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=1)-[_weekDayLabel(==15)][_dayLabel]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(_dayLabel, _weekDayLabel)];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(<=0)-[_dayLabel]-(<=0)-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_dayLabel, _weekDayLabel)];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(<=0)-[_weekDayLabel]-(<=0)-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_dayLabel, _weekDayLabel)];
    [self addConstraints:constraints];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_weekDayLabel
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_dayLabel
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f];
    [self addConstraint:constraint];
    [super layoutSubviews];
}

-(void)setDay:(NSDate *)day{
    self->_day = day;
    
    NSDateComponents *dayOfTheMonth = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:day];
    [self.dayLabel setText: [NSString stringWithFormat:@"%i", dayOfTheMonth.day]];
    switch (dayOfTheMonth.weekday) {
        case 1:
            [self.weekDayLabel setText:@"Dom"];
            break;
            
        case 2:
            [self.weekDayLabel setText:@"Lun"];
            break;
            
        case 3:
            [self.weekDayLabel setText:@"Mar"];
            break;
            
        case 4:
            [self.weekDayLabel setText:@"Mer"];
            break;
            
        case 5:
            [self.weekDayLabel setText:@"Gio"];
            break;
            
        case 6:
            [self.weekDayLabel setText:@"Ven"];
            break;
            
        case 7:
            [self.weekDayLabel setText:@"Sab"];
            break;
    }
    
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        [_dayLabel setTextColor:[UIColor whiteColor]];
        [_weekDayLabel setTextColor:[UIColor whiteColor]];
        [self.selectedBackgroundView setAlpha:1];
    }else{
        [_dayLabel setTextColor:[UIColor blackColor]];
        [_weekDayLabel setTextColor:[UIColor darkGrayColor]];
        [self.selectedBackgroundView setAlpha:0];
    }
}

-(void)setToday:(BOOL)today{
    if(today){
        [self.selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0f
                                                                        green:0.5960f
                                                                         blue:0.8196f
                                                                        alpha:1.0f]];
        
    }else{
        [self.selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:(0.0f/225)
                                                                        green:(61.0f/225)
                                                                         blue:(87.0f/225)
                                                                        alpha:1.0f]];
    }
    self->__today = today;
}

-(BOOL)today{
    return self->__today;
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if(userInteractionEnabled){
        if(self.selected){
            [_dayLabel setTextColor:[UIColor whiteColor]];
            [_weekDayLabel setTextColor:[UIColor whiteColor]];
        }else{
            [_dayLabel setTextColor:[UIColor blackColor]];
            [_weekDayLabel setTextColor:[UIColor darkGrayColor]];
        }
    }else{
        [_dayLabel setTextColor:[UIColor lightGrayColor]];
        [_weekDayLabel setTextColor:[UIColor lightGrayColor]];
    }
}

@end
