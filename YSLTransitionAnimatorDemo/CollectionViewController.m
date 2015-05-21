//
//  CollectionViewController.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/13.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"
#import "CollectionDetailViewController.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout, YSLTransitionAnimatorDataSource>

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"CollectionCell";

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
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    [self ysl_addTransitionDelegate:self];
    [self ysl_pushTransitionAnimationWithToViewControllerImagePointY:statusHeight + navigationHeight
                                                   animationDuration:0.3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _items = [@[@"photo_sample_01",
                @"photo_sample_02",
                @"photo_sample_03",
                @"photo_sample_04",
                @"photo_sample_05",
                @"photo_sample_06",
                @"photo_sample_07",] mutableCopy];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.itemImage.image = [UIImage imageNamed:_items[indexPath.row]];
    cell.itemLabel.text = [NSString stringWithFormat:@"Item Index %ld",(long)indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     CollectionDetailViewController *vc = [[CollectionDetailViewController alloc]init];
     [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width / 2) - 9, (self.view.frame.size.width / 2) - 9);
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


@end
