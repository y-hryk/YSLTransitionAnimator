//
//  SelectTableViewController.m
//  YSLTransitionAnimatorDemo
//
//  Created by yamaguchi on 2015/05/13.
//  Copyright (c) 2015年 h.yamaguchi. All rights reserved.
//

#import "SelectTableViewController.h"
#import "CollectionViewController.h"
#import "TableViewController.h"

@interface SelectTableViewController ()

@end

@implementation SelectTableViewController

static NSString *cellIdentifier = @"SelectTableCell";

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Futura-Medium" size:16];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"CollectionView";
            break;
        case 1:
            
            cell.textLabel.text = @"TableView";
            break;
        default:break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            CollectionViewController *vc = [[CollectionViewController alloc]initWithNibName:@"CollectionViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            TableViewController *vc = [[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:break;
    }
}

@end
