//
//  TableDetailViewController2.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/20.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "TableDetailViewController2.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

@interface TableDetailViewController2 () <YSLTransitionAnimatorDataSource>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TableDetailViewController2

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
    [super viewDidAppear:animated];
    [self ysl_addTransitionDelegate:self];
    // pop
    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
                                    cancelAnimationPointY:0
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    // header
    self.imageView = [[UIImageView alloc]init];
    self.imageView.frame = CGRectMake(rect.size.width / 2 - (200 / 2), 100, 200, 200);
    [self.view addSubview:self.imageView];
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    
    // label
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(10,
                             self.imageView.frame.origin.y + self.imageView.frame.size.height + 50,
                             rect.size.width - 20,
                             100);
    label.font = [UIFont fontWithName:@"Futura-Medium" size:22];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"TableDetailViewController2";
    [self.view addSubview:label];
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)popTransitionImageView
{
    return self.imageView;
}

- (UIImageView *)pushTransitionImageView
{
    return nil;
}

@end
