//
//  YYRedPacketChooseCashViewController.m
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketChooseCashViewController.h"
#import "YYRedPacketChooseCashTableViewCell.h"
#import "YYRedPacketChoosePayStyleView.h"

@interface YYRedPacketChooseCashViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYRedPacketChooseCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Choose Cash", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYRedPacketChooseCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHOOSE_CASH_CELL_ID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

@end
