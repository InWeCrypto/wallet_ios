//
//  DBHMyQuotationReminderViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyQuotationReminderViewController.h"

@interface DBHMyQuotationReminderViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHMyQuotationReminderViewController

#pragma mark ------ Lifecycle ------
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.title = NSLocalizedString(@"My Quotation Reminder", nil);
//    self.view.backgroundColor = BACKGROUNDCOLOR;
//
//    [self setUI];
//}
//
//#pragma mark ------ UI ------
//- (void)setUI {
//    [self.view addSubview:self.tableView];
//
//    WEAKSELF
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(weakSelf.view);
//        make.center.equalTo(weakSelf.view);
//    }];
//}
//
//#pragma mark ------ UITableViewDataSource ------
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DBHMyFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyFavoriteTableViewCellIdentifier forIndexPath:indexPath];
//
//    return cell;
//}
//
//#pragma mark ------ UITableViewDelegate ------
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 取消收藏
//    WEAKSELF
//    UITableViewRowAction *cancelColletAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"Cancel Collection", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//
//        //        tableView.editing = NO;
//    }];
//    //删除按钮颜色
//
//    cancelColletAction.backgroundColor = COLORFROM16(0xFF841C, 1);
//
//    return @[cancelColletAction];
//}
//
//#pragma mark ------ Getters And Setters ------
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
//        _tableView.sectionHeaderHeight = 0;
//        _tableView.sectionFooterHeight = 0;
//        _tableView.rowHeight = AUTOLAYOUTSIZE(76);
//
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//
//        [_tableView registerClass:[DBHMyFavoriteTableViewCell class] forCellReuseIdentifier:kDBHMyFavoriteTableViewCellIdentifier];
//    }
//    return _tableView;
//}
//
//- (NSMutableArray *)dataSource {
//    if (!_dataSource) {
//        _dataSource = [NSMutableArray array];
//        [_dataSource addObject:@""];
//        [_dataSource addObject:@""];
//        [_dataSource addObject:@""];
//        [_dataSource addObject:@""];
//    }
//    return _dataSource;
//}

@end
