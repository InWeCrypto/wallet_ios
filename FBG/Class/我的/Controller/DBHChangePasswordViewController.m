//
//  DBHChangePasswordViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHChangePasswordViewController.h"

#import "DBHChangePasswordTableViewCell.h"

static NSString *const kDBHChangePasswordTableViewCellIdentifier = @"kDBHChangePasswordTableViewCellIdentifier";

@interface DBHChangePasswordViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHChangePasswordViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Change Password", nil);
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSaveBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHChangePasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHChangePasswordTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(11.5);
}

#pragma mark ------ Event Responds ------
/**
 保存
 */
- (void)respondsToSaveBarButtonItem {
    
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(51);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHChangePasswordTableViewCell class] forCellReuseIdentifier:kDBHChangePasswordTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"Verification code", @"New Password", @"Sure Password"];
    }
    return _titleArray;
}

@end
