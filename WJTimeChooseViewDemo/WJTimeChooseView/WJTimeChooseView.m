//
//  WJTimeChooseView.m
//  WJTimeChooseViewDemo
//
//  Created by 高文杰 on 16/7/16.
//  Copyright © 2016年 musicTime. All rights reserved.
//
#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                [[UIScreen mainScreen] bounds].size.height
#define COLOR_White [UIColor whiteColor]
#define COLOR_ThemeRed UIColorFromHex(0xe64e4d)
#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define UIGrayColorWithAlpha(alpha) [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha]

#define WJColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#import "WJTimeChooseView.h"

@interface WJTimeChooseView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIDatePicker   *pickerView;
@property (nonatomic, strong) UIView         *headView;
@property (nonatomic, strong) UIView         *maskView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,   weak) UIPickerView   *pickView;

@property (nonatomic, assign) BOOL           isPDBSMainTime;
@property (nonatomic, assign) NSInteger      currentMaxYear;
@property (nonatomic, assign) NSInteger      currentMaxMonth;

@property (nonatomic, copy)   NSString       *selectedYear;
@property (nonatomic, copy)   NSString       *selectedDay;

@end

@implementation WJTimeChooseView


- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithTitle:(NSString *)title style:(WJTimeChooseStyle)style{
    return [self initWithFrame:[UIScreen mainScreen].bounds withTitle:title style:style];
}


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title style:(WJTimeChooseStyle)style{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        _maskView = [[UIView alloc]initWithFrame:frame];
        _maskView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [self addSubview:_maskView];
        
  
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 244, SCREEN_WIDTH, 44)];
        _headView.backgroundColor = COLOR_White;
        [self addSubview:_headView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:COLOR_ThemeRed forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(15, 7, 50, 30);
        cancelBtn.tag = 1;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:cancelBtn];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        titleLabel.textColor = WJColor(26, 26, 26);
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:titleLabel];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        sureBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 7, 50, 30);
        [sureBtn setTitleColor:COLOR_ThemeRed forState:UIControlStateNormal];
        sureBtn.tag = 2;
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [sureBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:sureBtn];
        
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        lineImage.backgroundColor = WJColor(26, 26, 26);
        [_headView addSubview:lineImage];
        
        
        if (style < 4) {
            _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200)];
            _pickerView.backgroundColor = COLOR_White;
            _pickerView.datePickerMode = (NSInteger)style;
            [_pickerView setDate:[NSDate date] animated:YES];
            [self addSubview:_pickerView];
        }else{
            [self initPick];
        }
        [self showToScreen];
    }
    return self;
}


- (void)initPick{
    
    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200)];
    picker.backgroundColor = COLOR_White;
    [self addSubview:picker];
    picker.delegate = self;
    picker.dataSource = self;
    self.pickView = picker;
    [self loadData];
    
}

- (void)loadData{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[[NSDate alloc]init]];
    [cmp setMonth:[cmp month]-1];
    NSDate *lastMonDate = [calendar dateFromComponents:cmp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *dateStr = [formatter stringFromDate:lastMonDate];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    
    NSString *currentYear = dateArr[0];
    self.selectedYear = currentYear;
    self.currentMaxYear = [currentYear integerValue];
    
    NSInteger minYear = [currentYear integerValue] - 50;
    NSString *currentDay = dateArr[1];
    self.selectedDay = currentDay;
    self.currentMaxMonth = [currentDay integerValue];
    
    
    NSMutableArray *yearArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 100; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%ld年",(minYear + i)]];
    }
    NSArray *dayArray = @[@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月"];
    NSInteger currentIndex = 0;
    for (int j = 0; j < dayArray.count; j++) {
        if ([[NSString stringWithFormat:@"%@月",currentDay] isEqualToString:dayArray[j]]) {
            currentIndex = j;
        }
    }
    self.currentMaxMonth = currentIndex;
    [self.dataSource addObject:yearArray];
    [self.dataSource addObject:dayArray];
    [self.pickView selectRow:currentIndex inComponent:1 animated:YES];
    [self.pickView selectRow:50 inComponent:0 animated:YES];
    
}
- (void)showToScreen{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    });
    
   
}

- (void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataSource[component] count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataSource[component][row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSString *tempYearStr = self.dataSource[component][row];
        self.selectedYear = [tempYearStr substringWithRange:NSMakeRange(0, tempYearStr.length -1)];
        
        if ([self.selectedYear integerValue] > self.currentMaxYear ) {
            [self.pickView selectRow:50 inComponent:component animated:YES];
            NSString *tempYearStr = self.dataSource[component][50];
            self.selectedYear = [tempYearStr substringWithRange:NSMakeRange(0, tempYearStr.length -1)];
        }
        if ([self.selectedYear integerValue] >= self.currentMaxYear) {
            if ([self.selectedDay integerValue] > self.currentMaxMonth) {
                [self.pickView selectRow:self.currentMaxMonth inComponent:1 animated:YES];
                NSString *tempDayStr = self.dataSource[1][self.currentMaxMonth];
                self.selectedDay = [tempDayStr substringWithRange:NSMakeRange(0, tempDayStr.length - 1)];
            }
        }
        
    }else{
        NSString *tempDayStr = self.dataSource[component][row];
        self.selectedDay = [tempDayStr substringWithRange:NSMakeRange(0, tempDayStr.length - 1)];
        if ([self.selectedYear integerValue] >= self.currentMaxYear) {
            if ([self.selectedDay integerValue] > self.currentMaxMonth) {
                [self.pickView selectRow:self.currentMaxMonth inComponent:component animated:YES];
                NSString *tempDayStr = self.dataSource[component][self.currentMaxMonth];
                self.selectedDay = [tempDayStr substringWithRange:NSMakeRange(0, tempDayStr.length - 1)];
            }
        }
        
    }
    
    
    
    
}


- (void)setMaxDate:(NSDate *)MaxDate{
    _pickerView.maximumDate = [self getFirstAndLastDayOfThisMonthWith:MaxDate];
    [_pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
}

-(void)dateChanged:(id)sender{
    _pickerView = (UIDatePicker*)sender;
    NSDate* date = _pickerView.date;
    NSDate *endDay = [self getFirstAndLastDayOfThisMonthWith:date];
    [_pickerView setDate:endDay animated:YES];
}

-(NSDate *)getFirstAndLastDayOfThisMonthWith:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:nil forDate:date];
    NSDateComponents *lastDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitDay fromDate:firstDay];
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    return lastDay;
}

- (void)btnAction:(UIButton *)sender{
    if ([self.selectedYear integerValue] >= self.currentMaxYear) {
        if ([self.selectedDay integerValue] > self.currentMaxMonth+1) {
            return;
        }
        
    }
    
    if (self.isPDBSMainTime) {
        
        NSString *yeayAndDay = [NSString stringWithFormat:@"%@-%@",self.selectedYear,self.selectedDay];
        NSLog(@"---yearandday=====%@",yeayAndDay);
        if (sender.tag == 1) {
            
            if ([_delegate respondsToSelector:@selector(setTimeYearAndDay:)]) {
                [_delegate setTimeYearAndDay:@""];
            }
            
            
        }else{
            if ([_delegate respondsToSelector:@selector(setTimeYearAndDay:)]) {
                [_delegate setTimeYearAndDay:yeayAndDay];
            }
            
        }
        
        
        
    }else{
        switch (sender.tag) {
            case 1:
            {
                if ([_delegate respondsToSelector:@selector(setOrderTime:)]) {
                    [_delegate setOrderTime:@""];
                }
                if ([_delegate respondsToSelector:@selector(setOrderTimeForCn:andTime:)]) {
                    [_delegate setOrderTimeForCn:@"" andTime:@""];
                }
            }
                break;
                
            case 2:
            {
                if ([_delegate respondsToSelector:@selector(setOrderTime:)]) {
                    NSDate* date = _pickerView.date;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *time = [formatter stringFromDate:date];
                    [_delegate setOrderTime:time];
                }
                
                if ([_delegate respondsToSelector:@selector(setOrderTimeForCn:andTime:)]) {
                    NSDate* date = _pickerView.date;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *time = [formatter stringFromDate:date];
                    [formatter setDateFormat:@"yyyy年MM月dd日"];
                    NSString *timeCn = [formatter stringFromDate:date];
                    [_delegate setOrderTimeForCn:time andTime:timeCn];
                }
            }
                break;
                
            default:
                break;
        }
        
        
    }
    [self hide];

}

@end
