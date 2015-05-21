//
//  CollectionCell.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/13.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.itemImage.layer.cornerRadius = 7.0f;
    self.itemImage.clipsToBounds = YES;
}

@end
