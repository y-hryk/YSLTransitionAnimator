# YSLTransitionAnimator

## Demo
![Dome](https://raw.githubusercontent.com/y-hryk/YSLTransitionAnimator/master/sample_01.gif)
![Dome](https://raw.githubusercontent.com/y-hryk/YSLTransitionAnimator/master/sample_02.gif)
## Requirement
not support landscape

iOS 7.0
## Install
#### Manually
 Copy YSLTransitionAnimator directory to your project.
#### CocoaPods
 Add pod 'YSLTransitionAnimator' to your Podfile.
 
## Usage
- import `YSLTransitionAnimator.h`
- import `UIViewController+YSLTransition.h`

### Push Transition
``` objective-c
@interface ViewController () <YSLTransitionAnimatorDataSource>

- (void)viewWillDisappear:(BOOL)animated
{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    [self ysl_addTransitionDelegate:self];
    [self ysl_pushTransitionAnimationWithToViewControllerImagePointY:statusHeight + navigationHeight
                                                   animationDuration:0.3];
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)pushTransitionImageView
{
    CollectionCell *cell = (CollectionCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
    return cell.itemImage;
}

- (UIImageView *)popTransitionImageView
{
    return nil;
}

```
### Pop Transition
``` objective-c
@interface ViewController () <YSLTransitionAnimatorDataSource>

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

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)popTransitionImageView
{
    return self.headerImageView;
}

- (UIImageView *)pushTransitionImageView
{
    return nil;
}
```
## Licence
MIT

