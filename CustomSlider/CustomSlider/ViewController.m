//
//  ViewController.m
//  CustomSlider
//
//  Created by chuanglong03 on 16/6/17.
//  Copyright © 2016年 chuanglong. All rights reserved.
//

#import "ViewController.h"
#import "CustomSliderView.h"

@interface ViewController ()<CustomSliderViewDelegate>

@property (nonatomic, strong) CustomSliderView *sliderView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSInteger i = 0; i < 7; i++) {
        NSString *ageStr = [NSString stringWithFormat:@"%ld岁", i];
        [self.contentArray addObject:ageStr];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"lubi%ld", i]];
        [self.imageArray addObject:image];
    }
    self.sliderView = [[CustomSliderView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 110) number:7 contentArray:self.contentArray imageArray:self.imageArray];
    self.sliderView.delegate = self;
    [self.view addSubview:self.sliderView];
}

#pragma mark - 点击 button 事件
- (void)clickedButton:(UIButton *)sender {
    CGFloat clickedButtonCenterX = sender.center.x;
    UIImageView *imageView1 = (UIImageView *)[self.sliderView viewWithTag:10000];
    CGFloat imageView1CenterX = imageView1.center.x;
    UIImageView *imageView2 = (UIImageView *)[self.sliderView viewWithTag:10006];
    CGFloat imageView2CenterX = imageView2.center.x;
    CGFloat distanceClickedButtonToImageView1 = 0;
    if (clickedButtonCenterX-imageView1CenterX > 0) {
        distanceClickedButtonToImageView1 = clickedButtonCenterX-imageView1CenterX;
    } else {
        distanceClickedButtonToImageView1 = imageView1CenterX-clickedButtonCenterX;
    }
    CGFloat distanceClickedButtonToImageView2 = 0;
    if (imageView2CenterX-clickedButtonCenterX > 0) {
        distanceClickedButtonToImageView2 = imageView2CenterX-clickedButtonCenterX;
    } else {
        distanceClickedButtonToImageView2 = clickedButtonCenterX-imageView2CenterX;
    }
    if (!(clickedButtonCenterX==imageView1CenterX || clickedButtonCenterX==imageView2CenterX)) {
        if (distanceClickedButtonToImageView1 < distanceClickedButtonToImageView2) {
            imageView1.center = sender.center;
        } else if (distanceClickedButtonToImageView1 > distanceClickedButtonToImageView2) {
            imageView2.center = sender.center;
        } else {
            if (imageView1CenterX < imageView2CenterX) {
                imageView2.center = sender.center;
            } else if (imageView1CenterX > imageView2CenterX) {
                imageView1.center = sender.center;
            } else {
                if (imageView2CenterX < sender.center.x) {
                    imageView2.center = sender.center;
                } else if (imageView1CenterX > sender.center.x) {
                    imageView1.center = sender.center;
                }
            }
        }
    }
}

#pragma mark - 平移事件
- (void)panAction:(UIPanGestureRecognizer *)pan {
    UIImageView *imageView1 = (UIImageView *)pan.view;
    NSInteger tag = 0;
    if (imageView1.tag == 10000) {
        tag = 10006;
    } else {
        tag = 10000;
    }
    UIImageView *imageView2 = (UIImageView *)[self.sliderView viewWithTag:tag];
    CGFloat startImageView2CenterX = imageView2.center.x;
    CGPoint touchPoint = [pan translationInView:imageView1];
    CGPoint point = imageView1.center;
    point.x += touchPoint.x;
    CGFloat centerX1 = [self.sliderView viewWithTag:100].center.x;
    CGFloat distanceBetweenTwoButton = [self.sliderView viewWithTag:101].center.x-centerX1;
    CGFloat centerX2 = centerX1+distanceBetweenTwoButton/2.0;
    if (pan.state == UIGestureRecognizerStateEnded) {
        for (NSInteger i = 0; i < 7; i++) {
            if (point.x>centerX2+(i-1)*distanceBetweenTwoButton && point.x<=centerX2+i*distanceBetweenTwoButton) {
                point.x =  centerX1+i*distanceBetweenTwoButton;
                imageView1.center = point;
                break;
            }
        }
    } else {
        imageView1.center = point;
        for (NSInteger i = 0; i < 7; i++) {
            UIImageView *imageView = (UIImageView *)[self.sliderView viewWithTag:100+i];
            CGFloat imageViewCenterX = imageView.center.x;
            CGFloat centerX = imageViewCenterX-point.x;
            if ((imageViewCenterX > startImageView2CenterX-0.5 && imageViewCenterX < startImageView2CenterX+0.5) || (centerX<=distanceBetweenTwoButton/2.0 && centerX>-distanceBetweenTwoButton/2.0)) {
                imageView.alpha = 1;
            } else {
                imageView.alpha = 0;
            }
        }
        [pan setTranslation:CGPointMake(0, 0) inView:imageView1];
    }
}

#pragma mark - 懒加载开辟空间
- (NSMutableArray *)contentArray {
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
