//
//  ViewController.m
//  WJTimeChooseViewDemo
//
//  Created by 高文杰 on 16/7/16.
//  Copyright © 2016年 musicTime. All rights reserved.
//

#import "ViewController.h"
#import "WJTimeChooseView.h"

@interface ViewController ()<WJTimeChooseDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)viewDidAppear:(BOOL)animated{
    [self setTimeChooseView];
}

- (void)setTimeChooseView{
    WJTimeChooseView *orderTimeView = [[WJTimeChooseView alloc]initWithTitle:@"时间选择" style:WJTimeChooseStyle4];
    // 时间选择器，在系统自带的样式上加了一个只有年月的样式，可限制最大日期数
    orderTimeView.delegate = self;
    orderTimeView.alpha = 0;
    
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [canlendar components:(NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay) fromDate:[[NSDate alloc]init]];
    [cmp setMonth:[cmp month]-1];
    NSDate *lastMonthDate = [canlendar dateFromComponents:cmp];
    orderTimeView.MaxDate = lastMonthDate;
    
    
}

- (void)setOrderTime:(NSString *)time{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
