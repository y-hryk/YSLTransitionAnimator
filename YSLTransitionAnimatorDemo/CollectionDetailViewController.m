//
//  CollectionDetailViewController.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/20.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "CollectionDetailViewController.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

@interface CollectionDetailViewController () <YSLTransitionAnimatorDataSource>

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;

@end

@implementation CollectionDetailViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self ysl_addTransitionDelegate:self];
    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
                                    cancelAnimationPointY:0
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    // header
    // If you're using a xib and storyboard. Be sure to specify the frame
    _headerImageView.frame = CGRectMake(0, statusHeight + navigationHeight, rect.size.width, 250);
    
    // custom navigation left item
    __weak CollectionDetailViewController *weakself = self;
    [self ysl_setUpReturnBtnWithColor:[UIColor lightGrayColor]
                      callBackHandler:^{
                          [weakself.navigationController popViewControllerAnimated:YES];
                      }];
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)popTransitionImageView
{
    return self.headerImageView;
}

- (UIImageView *)pushTransitionImageView
{
    return nil;
}

@end
