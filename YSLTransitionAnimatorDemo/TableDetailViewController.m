//
//  TableDetailViewController.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/20.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "TableDetailViewController.h"
#import "TableCell.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"
#import "TableDetailViewController2.h"

@interface TableDetailViewController () <YSLTransitionAnimatorDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation TableDetailViewController

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
    // push
    [self ysl_pushTransitionAnimationWithToViewControllerImagePointY:100
                                                   animationDuration:0.3];
    // pop
    [self ysl_popTransitionAnimationWithCurrentScrollView:self.tableView
                                    cancelAnimationPointY:self.headerImageView.frame.size.height - (statusHeight + navigationHeight)
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
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
    [self createTableHaaderView];
}

- (void)createTableHaaderView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    UIView *headerBackView = [[UIView alloc]init];
    headerBackView.frame = CGRectMake(0, statusHeight + navigationHeight, rect.size.width, 255);
    
    self.headerImageView = [[UIImageView alloc]init];
    self.headerImageView.frame = CGRectMake(0, 0, rect.size.width, 250);
    [headerBackView addSubview:self.headerImageView];
    
    self.tableView.tableHeaderView = headerBackView;
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
    TableDetailViewController2 *vc = [[TableDetailViewController2 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)popTransitionImageView
{
    return self.headerImageView;
}

- (UIImageView *)pushTransitionImageView
{
    TableCell *cell = (TableCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    return cell.itemImage;
}

@end
