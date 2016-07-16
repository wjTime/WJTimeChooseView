//
//  WJTimeChooseView.h
//  WJTimeChooseViewDemo
//
//  Created by 高文杰 on 16/7/16.
//  Copyright © 2016年 musicTime. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    WJTimeChooseStyle0 = 0,//(e.g. 6 | 53 | PM)
    WJTimeChooseStyle1 = 1,//(e.g. November | 15 | 2007)
    WJTimeChooseStyle2 = 2,//(e.g. Wed Nov 15 | 6 | 53 | PM)
    WJTimeChooseStyle3 = 3,//(e.g. 1 | 53)
    WJTimeChooseStyle4 = 4,//(e.g. 2016年 | 06月) 只显示年月
}WJTimeChooseStyle;

@protocol WJTimeChooseDelegate <NSObject>


@optional

/** 基于dataPicker 代理方法1*/
- (void)setOrderTime:(NSString *)time;

/** 基于dataPicker 代理方法2*/
- (void)setOrderTimeForCn:(NSString *)time andTime:(NSString *)enTime; //年月日

/** 基于UIPicker 代理方法1 */
- (void)setTimeYearAndDay:(NSString *)time;

@end

@interface WJTimeChooseView : UIView

@property (assign, nonatomic) id <WJTimeChooseDelegate> delegate;

@property (nonatomic, strong)NSDate *MaxDate;// 最大年月日


/** 创建UIPicker/DataPicker */
- (instancetype)initWithTitle:(NSString *)title style:(WJTimeChooseStyle)style;
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title style:(WJTimeChooseStyle)style;

@end
