//
//  ViewController.m
//  Drawer
//
//  Created by  wuhiwi on 2018/5/7.
//  Copyright © 2018年 Wangli Technology Co. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "FirstVC.h"
#import "SecondVC.h"
#import "UIView+Frame.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define Min_Right_Margin  100

@interface ViewController ()

@property (nonatomic, strong) FirstVC *firstVC;
@property (nonatomic, strong) SecondVC *secondVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.firstVC];
    [self.view addSubview:self.firstVC.view];
    [self addChildViewController:self.secondVC];
    [self.view addSubview:self.secondVC.view];
    
    //设置一个按钮点击实现抽屉效果
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame = CGRectMake(0, 50, 150, 150);
    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"left" forState:UIControlStateNormal];
    [self.secondVC.view addSubview:leftButton];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.secondVC.view addGestureRecognizer:pan];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture
{
    CGPoint transition = [panGesture translationInView:self.secondVC.view];
    NSLog(@"%@",NSStringFromCGPoint(transition));
    
    BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
    if ((self.secondVC.view.x >= (SCREEN_WIDTH - Min_Right_Margin) && transition.x > 0) || (self.secondVC.view.x + transition.x * 0.8) < 0) {
        needMoveWithTap = NO;
    }
    
    if (needMoveWithTap) {
        self.secondVC.view.x = self.secondVC.view.x + transition.x * 0.8;
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.secondVC.view];
    }else
    {
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.secondVC.view];

    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.secondVC.view.x >= (SCREEN_WIDTH - Min_Right_Margin )/ 2) {
            [UIView animateWithDuration:0.2 animations:^{
                self.secondVC.view.x = SCREEN_WIDTH - Min_Right_Margin;
            }];
        }else
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.secondVC.view.x = 0;
            }];
        }
    }
}

- (void)leftButtonPressed
{
    //判断抽屉是否是展开状态
    if (self.secondVC.view.frame.origin.x == 0) {
        //通过动画实现view.fram的改变
        [UIView animateWithDuration:0.3 animations:^{
            self.secondVC.view.frame = CGRectMake(SCREEN_WIDTH - Min_Right_Margin, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.secondVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - getter

- (FirstVC *)firstVC
{
    if (!_firstVC) {
        _firstVC = [[FirstVC alloc] init];
    }
    return _firstVC;
}
- (SecondVC *)secondVC
{
    if (!_secondVC) {
        _secondVC = [[SecondVC alloc] init];
    }
    return _secondVC;
}

@end
