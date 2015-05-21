//
//  TableViewController.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/13.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "TableViewController.h"
#import "TableCell.h"
#import "TableDetailViewController.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

@interface TableViewController () <YSLTransitionAnimatorDataSource>

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation TableViewController

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
    if ([self.tableView indexPathForSelectedRow] ) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableCell" bundle:nil] forCellReuseIdentifier:@"TableCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TableCell";
    TableCell *cell = (TableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.itemImage.image = [UIImage imageNamed:_items[indexPath.row]];
    cell.itemLabel.text = [NSString stringWithFormat:@"Item Index %ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableDetailViewController *vc = [[TableDetailViewController alloc]init];
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)pushTransitionImageView
{
    TableCell *cell = (TableCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    return cell.itemImage;
}

- (UIImageView *)popTransitionImageView
{
    return nil;
}

@end
