//
//  PopoverPresentationVC.m
//  NewsTracker
//
//  Created by Olena Synenka on 4/10/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "PopoverPresentationVC.h"
#import "PopoverTableViewCell.h"


#pragma mark - Constants
static NSString *const cellIdentifier = @"categoryCell";

@interface PopoverPresentationVC ()<UITableViewDelegate, UITableViewDataSource>


@end


@implementation PopoverPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (self.categoryArray.count > indexPath.row)
        cell.categoryName.text = self.categoryArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *categoryName = self.categoryArray[indexPath.row];
    [self.popoverPresentationDelegate categoryPopoverDone:categoryName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

