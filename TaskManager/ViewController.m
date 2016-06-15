//
//  ViewController.m
//  TaskManager
//
//  Created by 周文春 on 16/5/31.
//  Copyright © 2016年 周文春. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"

@interface ViewController ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong)iCarousel * carousel;
@property (nonatomic, assign)CGSize taskSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat taskWidth = [UIScreen mainScreen].bounds.size.width * 5/7;
    self.taskSize = CGSizeMake(taskWidth, taskWidth* 16 /9);
    [self.view setBackgroundColor:[UIColor grayColor]];
    self.carousel = [[iCarousel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.carousel];
    [self.carousel setDelegate:self];
    [self.carousel setDataSource:self];
    [self.carousel setType:iCarouselTypeCustom];
    [self.carousel setBounceDistance:0.1f];
}
#pragma mark - iCarouselDelegate && iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 7;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView * taskView = view;
    if (!taskView) {
        taskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.taskSize.width, self.taskSize.height)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:taskView.bounds];
        //简单的方式添加圆角
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = 5.0f;
        [taskView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",(long)index]]];
        
        //添加圆角
        [taskView.layer setShadowPath:[UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath];
        [taskView.layer setShadowRadius:3.0f];
        [taskView.layer setShadowColor:[UIColor blackColor].CGColor];
        [taskView.layer setShadowOffset:CGSizeZero];
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        [layer setFrame:imageView.bounds];
        [layer setPath:[UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath];
        [imageView.layer setMask:layer];
        
        UILabel * lable = [[UILabel alloc]initWithFrame:taskView.frame];
//        [lable setText:[@(index) stringValue]];
        lable.font = [UIFont systemFontOfSize:50];
        lable.textAlignment = NSTextAlignmentCenter;
        [taskView addSubview:lable];
    }
    return taskView;
}
//计算缩放
- (CGFloat)calcScaleWithOffset:(CGFloat)offset
{
    return  offset * 0.02f + 1.0f;
}
//计算位移
- (CGFloat)calcTranslationWithOffset:(CGFloat)offset
{
    CGFloat z = 5.0f / 4.0f;
    CGFloat a = 5.0f / 8.0f;
    
    //移出屏幕
    if (offset >= z/a) {
        return 2.0f;
    }
    return 1/(z-a*offset)-1/z;
}
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
//    NSLog(@"%f",offset);
    CGFloat scale = [self calcScaleWithOffset:offset];
    CGFloat translation = [self calcTranslationWithOffset:offset];
    
    return CATransform3DScale(CATransform3DTranslate(transform, translation * self.taskSize.width, 0, offset),scale,scale,1.0f);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
