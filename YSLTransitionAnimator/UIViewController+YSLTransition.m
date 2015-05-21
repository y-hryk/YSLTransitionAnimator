//
//  UIViewController+YSLTransition.m
//  CustomTransition_Sample
//
//  Created by yamaguchi on 2015/04/16.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "UIViewController+YSLTransition.h"
#import <objc/runtime.h>

static BOOL isScrollView = NO;

@implementation UIViewController (YSLTransition)

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition
{
    return objc_getAssociatedObject(self, @selector(interactivePopTransition));
}

- (void)setInteractivePopTransition:(UIPercentDrivenInteractiveTransition *)interactivePopTransition
{
     objc_setAssociatedObject(self, @selector(interactivePopTransition), interactivePopTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)scrollView
{
    return objc_getAssociatedObject(self, @selector(scrollView));
}

- (void)setScrollView:(UIScrollView *)scrollView
{
     objc_setAssociatedObject(self, @selector(scrollView), scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)toViewControllerImagePointY
{
    NSNumber *value = objc_getAssociatedObject(self, @selector(toViewControllerImagePointY));
    return value;
}

- (void)setToViewControllerImagePointY:(NSNumber *)toViewControllerImagePointY
{
    objc_setAssociatedObject(self, @selector(toViewControllerImagePointY), toViewControllerImagePointY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)cancelAnimationPointY
{
    NSNumber *value = objc_getAssociatedObject(self, @selector(cancelAnimationPointY));
    return value;
}

- (void)setCancelAnimationPointY:(NSNumber *)cancelAnimationPointY
{
    objc_setAssociatedObject(self, @selector(cancelAnimationPointY), cancelAnimationPointY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)animationDuration
{
    NSNumber *value = objc_getAssociatedObject(self, @selector(animationDuration));
    return value;
}

- (void)setAnimationDuration:(NSNumber *)animationDuration
{
    objc_setAssociatedObject(self, @selector(animationDuration), animationDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -- Public

- (void)ysl_setUpReturnBtnWithColor:(UIColor *)color callBackHandler:(void (^)())callBackHandler
{
    objc_setAssociatedObject(self, (__bridge void *)(@"ysl_return_Action"), callBackHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ysl_navi_back_btn.png"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(returnAction:)];
    if (color) {
        self.navigationItem.leftBarButtonItem.tintColor = color;
    } else {
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor lightGrayColor];
    }
}

- (void)ysl_setupReturnBtnWithImage:(UIImage *)image color:(UIColor *)color callBackHandler:(void (^)())callBackHandler
{
    objc_setAssociatedObject(self, (__bridge void *)(@"ysl_return_Action"), callBackHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UIImage *btnImage = [UIImage imageNamed:@"ysl_navi_back_btn.png"];
    if (image) {
        btnImage = image;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:btnImage
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(returnAction:)];
    if (color) {
        self.navigationItem.leftBarButtonItem.tintColor = color;
    } else {
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor lightGrayColor];
    }
}

#pragma mark -- private
- (void)returnAction:(id)sender
{
    void (^callBackHandler)() = objc_getAssociatedObject(self, (__bridge void *)(@"ysl_return_Action"));
    if(callBackHandler){
        callBackHandler();
    }
}

#pragma mark -- public

- (void)ysl_pushTransitionAnimationWithToViewControllerImagePointY:(CGFloat)toViewControllerImagePointY
                                                 animationDuration:(CGFloat)animationDuration
{
    self.toViewControllerImagePointY = @(toViewControllerImagePointY);
    self.animationDuration = @(animationDuration);
}

- (void)ysl_popTransitionAnimationWithCurrentScrollView:(UIScrollView*)scrollView
                                  cancelAnimationPointY:(CGFloat)cancelAnimationPointY
                                      animationDuration:(CGFloat)animationDuration
                                isInteractiveTransition:(BOOL)isInteractiveTransition
{
    if (scrollView) {
        self.scrollView = scrollView;
        isScrollView = YES;
    }
    self.cancelAnimationPointY = @(cancelAnimationPointY);
    self.animationDuration = @(animationDuration);
    
    if (isInteractiveTransition) {
        UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
        popRecognizer.edges = UIRectEdgeLeft;
        [self.view addGestureRecognizer:popRecognizer];
    }
}

- (void)ysl_addTransitionDelegate:(UIViewController*)viewController
{
    self.navigationController.delegate = self;
    
    if ([viewController isKindOfClass:[UITableViewController class]]) {
        UITableViewController *vc = (UITableViewController *)viewController;
        vc.clearsSelectionOnViewWillAppear = NO;
    }
    
    if ([viewController isKindOfClass:[UICollectionViewController class]]) {
        UICollectionViewController *vc = (UICollectionViewController *)viewController;
        vc.clearsSelectionOnViewWillAppear = NO;
    }
}

- (void)ysl_removeTransitionDelegate
{
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark -- NavitionContollerDelegate
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (!self.interactivePopTransition) { return nil; }
    return self.interactivePopTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    
    if ([(id<YSLTransitionAnimatorDataSource>)fromVC conformsToProtocol:@protocol(YSLTransitionAnimatorDataSource)] &&
        [(id<YSLTransitionAnimatorDataSource>)toVC conformsToProtocol:@protocol(YSLTransitionAnimatorDataSource)]) {
        
        if (operation == UINavigationControllerOperationPush) {
            
            if (operation != UINavigationControllerOperationPush) { return nil; }
            YSLTransitionAnimator *animator = [[YSLTransitionAnimator alloc]init];
            animator.isForward = (operation == UINavigationControllerOperationPush);
            
            animator.toViewControllerImagePointY = [self.toViewControllerImagePointY floatValue];
            animator.animationDuration = [self.animationDuration floatValue];
            return  animator;
            
        } else if (operation == UINavigationControllerOperationPop) {
         
            if (operation != UINavigationControllerOperationPop) { return nil; }
            
            if (isScrollView && self.cancelAnimationPointY != 0) {
                if (self.scrollView.contentOffset.y > [self.cancelAnimationPointY floatValue]) { return nil; }
            }
            
            YSLTransitionAnimator *animator = [[YSLTransitionAnimator alloc]init];
            animator.isForward = (operation == UINavigationControllerOperationPush);
            animator.animationDuration = [self.animationDuration floatValue];
            return  animator;
            
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

#pragma mark UIGestureRecognizer handlers

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

@end
