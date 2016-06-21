//
//  CustomSliderView.m
//  CustomSlider
//
//  Created by chuanglong03 on 16/6/17.
//  Copyright © 2016年 chuanglong. All rights reserved.
//

#define kTop 20
#define kBottom 15
#define kVertical 10
#define kPic 40
#define kContent 20
#define kGrayPoint 6
#define kSliderLineHeight 4
#define kButton 25
#define kLeft 20

#import "CustomSliderView.h"

@implementation CustomSliderView

- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number contentArray:(NSArray *)contentArray imageArray:(NSArray *)imageArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.number = number;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        CGFloat distanceBetweenTwoButton = (width-2*kLeft-kButton)/(CGFloat)(number-1);
        for (NSInteger i = 0; i < number; i++) {
            // label
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kContent, kContent)];
            CGFloat contentCenterX = kLeft+kButton/2.0+i*distanceBetweenTwoButton;
            CGFloat contentCenterY = kTop+kPic/2.0;
            contentLabel.center = CGPointMake(contentCenterX, contentCenterY);
            contentLabel.text = contentArray[i];
            contentLabel.font = [UIFont systemFontOfSize:12];
            contentLabel.textAlignment = NSTextAlignmentCenter;
            contentLabel.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
            [self addSubview:contentLabel];
            
            // imageView
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPic, kPic)];
            imageView.center = contentLabel.center;
            imageView.image = imageArray[i];
            if (!(i==0 || i==number-1)) {
                imageView.alpha = 0;
            }
            imageView.tag = 100+i;
            [self addSubview:imageView];
            
            // grayPoint
            UIView *grayPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGrayPoint, kGrayPoint)];
            CGFloat grayPointCenterX = contentCenterX;
            CGFloat grayPointCenterY = kTop+kPic+kVertical+kButton/2.0;
            grayPointView.center = CGPointMake(grayPointCenterX, grayPointCenterY);
            grayPointView.backgroundColor = [UIColor grayColor];
            grayPointView.layer.cornerRadius = kGrayPoint/2.0;
            grayPointView.layer.masksToBounds = YES;
            [self addSubview:grayPointView];
            
            // button
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButton, kButton)];
            button.center = grayPointView.center;
            if (i==0 || i==number-1) {
                button.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.500];
            } else {
                button.backgroundColor = [UIColor colorWithRed:1.000 green:0.588 blue:0.451 alpha:1.000];
            }
            button.layer.cornerRadius = kButton/2.0;
            button.layer.masksToBounds = YES;
            button.tag = 1000+i;
            [button addTarget:self action:@selector(clickedButton:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:button];
            
            // grayLine
            if (i < number-1) {
                CGFloat grayLineX = grayPointCenterX+kButton/2.0-0.5;
                CGFloat grayLineY = grayPointCenterY-kSliderLineHeight/2.0;
                CGFloat grayLineWidth = distanceBetweenTwoButton-kButton+1;
                UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(grayLineX, grayLineY, grayLineWidth, kSliderLineHeight)];
                grayLineView.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.500];
                [self addSubview:grayLineView];
            }
        }
        
        // sliderLineImageView
        CGFloat sliderLineImageViewX = kLeft+kButton-0.5;
        CGFloat sliderLineImageViewY = kTop+kPic+kVertical+kButton/2.0-kSliderLineHeight/2.0;
        CGFloat sliderLineImageViewWidth = width-2*kLeft-2*kButton+1;
        UIImageView *sliderLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(sliderLineImageViewX, sliderLineImageViewY, sliderLineImageViewWidth, kSliderLineHeight)];
        sliderLineImageView.image = [UIImage imageNamed:@"slider-2"];
        sliderLineImageView.tag = 5000;
        [self addSubview:sliderLineImageView];
        
        // movableImageView
        for (NSInteger i = 0; i < 2; i++) {
            UIImageView *movableImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kButton, kButton)];
            CGFloat movableImageViewCenterX = kLeft+kButton/2.0+6*i*distanceBetweenTwoButton;
            CGFloat movableImageViewCenterY = kTop+kPic+kVertical+kButton/2.0;
            movableImageView.center = CGPointMake(movableImageViewCenterX, movableImageViewCenterY);
            movableImageView.image = [UIImage imageNamed:@"slider-1"];
            movableImageView.userInteractionEnabled = YES;
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
            [movableImageView addGestureRecognizer:pan];
            [movableImageView addObserver:self forKeyPath:@"center" options:(NSKeyValueObservingOptionNew) context:nil];
            movableImageView.tag = 10000+i*6;
            [self addSubview:movableImageView];
        }
        
        // bottomLineView
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 1)];
        bottomLineView.backgroundColor = [UIColor colorWithRed:0.784 green:0.780 blue:0.800 alpha:1.000];
        [self addSubview:bottomLineView];
    }
    return self;
}

#pragma mark - 点击 button 触发方法
- (void)clickedButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedButton:)]) {
        [self.delegate clickedButton:sender];
    }
}

#pragma mark - 平移触发方法
- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (self.delegate && [self.delegate respondsToSelector:@selector(panAction:)]) {
        [self.delegate panAction:pan];
    }
}

#pragma mark - 观察者执行方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"center"]) {
        UIImageView *imageView1 = object;
        NSInteger tag = 0;
        if (imageView1.tag == 10000) {
            tag = 10006;
        } else {
            tag = 10000;
        }
        UIImageView *imageView2 = (UIImageView *)[self viewWithTag:tag];
        CGFloat imageView1X = imageView1.frame.origin.x;
        CGFloat imageView2X = imageView2.frame.origin.x;
        UIImageView *imageView3 = (UIImageView *)[self viewWithTag:5000];
        CGFloat imageView3X = 0;
        CGFloat imageView3Y = kTop+kPic+kVertical+kButton/2.0-kSliderLineHeight/2.0;
        CGFloat imageView3Width = 0;
        if (imageView1X+kButton < imageView2X) {
            imageView3X = imageView1X+kButton-1;
            imageView3Width = imageView2X-imageView1X-kButton+2;
        } else if (imageView1X > imageView2X+kButton) {
            imageView3X = imageView2X+kButton-1;
            imageView3Width = imageView1X-imageView2X-kButton+2;
        }
        imageView3.frame = CGRectMake(imageView3X, imageView3Y, imageView3Width, kSliderLineHeight);
        for (NSInteger i = 1; i < self.number-1; i++) {
            UIButton *button = (UIButton *)[self viewWithTag:1000+i];
            CGFloat buttonX = button.frame.origin.x;
            if ((buttonX>imageView1X && buttonX<imageView2X) || (buttonX>imageView2X && buttonX<imageView1X)) {
                button.backgroundColor = [UIColor colorWithRed:1.000 green:0.588 blue:0.451 alpha:1.000];
            } else {
                button.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.500];
            }
        }
        for (NSInteger i = 0; i < self.number; i++) {
            UIImageView *imageView = (UIImageView *)[self viewWithTag:100+i];
            CGFloat imageViewCenterX = imageView.center.x;
            if ((imageViewCenterX > imageView1X+kButton/2.0-0.5 && imageViewCenterX < imageView1X+kButton/2.0+0.5) || (imageViewCenterX > imageView2X+kButton/2.0-0.5 && imageViewCenterX < imageView2X+kButton/2.0+0.5)) {
                imageView.alpha = 1;
            } else {
                imageView.alpha = 0;
            }
        }
        if (imageView1.frame.origin.x < kLeft+1) {
            CGRect leftFrame = imageView1.frame;
            leftFrame.origin.x = kLeft;
            imageView1.frame = leftFrame;
        } else if (imageView1.frame.origin.x > self.frame.size.width-kLeft-kButton-1) {
            CGRect rightFrame = imageView1.frame;
            rightFrame.origin.x = self.frame.size.width-kLeft-kButton;
            imageView1.frame = rightFrame;
        }
    }
}

#pragma mark - 移除观察者
- (void)dealloc {
    for (NSInteger i = 0; i < 2; i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:10000+i*6];
        [imageView removeObserver:self forKeyPath:@"center"];
    }
}

@end
