//
//  CustomSliderView.h
//  CustomSlider
//
//  Created by chuanglong03 on 16/6/17.
//  Copyright © 2016年 chuanglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSliderViewDelegate <NSObject>

- (void)clickedButton:(UIButton *)sender;
- (void)panAction:(UIPanGestureRecognizer *)pan;

@end

@interface CustomSliderView : UIView

@property (nonatomic, assign) NSInteger number; // 按钮个数
@property (nonatomic, assign) id<CustomSliderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number contentArray:(NSArray *)contentArray imageArray:(NSArray *)imageArray;

@end
