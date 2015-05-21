//
//  YSLTransitionAnimator.h
//  CustomTransition_Sample
//
//  Created by yamaguchi on 2015/04/16.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YSLTransitionAnimatorDataSource <NSObject>

- (UIImageView *)pushTransitionImageView;
- (UIImageView *)popTransitionImageView;

@end

@interface YSLTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isForward;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) CGFloat toViewControllerImagePointY;

@end
