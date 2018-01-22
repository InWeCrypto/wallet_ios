//
//  DBHMyViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyViewController.h"

@interface DBHMyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DBHMyViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroudColor];
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
//    [self.view addSubview:self.tableView];
//
//    WEAKSELF
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(weakSelf.view);
//        make.center.equalTo(weakSelf.view);
//    }];
}

//#pragma mark ------ UITableViewDataSource ------
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 5;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DBHMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyTableViewCellIdentifier forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.title = self.titleArray[indexPath.section];
//    cell.leftImageName = self.leftImageNameArray[indexPath.section];
//
//    return cell;
//}
//
//#pragma mark ------ UITableViewDelegate ------
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//#pragma mark ------ Getters And Setters ------
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//        _tableView.tableHeaderView = self.headerView;
//
//        _tableView.sectionFooterHeight = 0;
//        _tableView.rowHeight = AUTOLAYOUTSIZE(60);
//
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//
//        [_tableView registerClass:[DBHMyTableViewCell class] forCellReuseIdentifier:kDBHMyTableViewCellIdentifier];
//    }
//    return _tableView;
//}

@end
