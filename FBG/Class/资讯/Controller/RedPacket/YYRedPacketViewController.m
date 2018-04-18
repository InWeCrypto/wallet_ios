//
//  YYRedPacketViewController.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketViewController.h"
#import "YYRedPacketHomeHeaderView.h"

#define HEADER_VIEW_HEIGHT 223
#define FOOTER_VIEW_HEIGHT 10

@interface YYRedPacketViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, weak) YYRedPacketHomeHeaderView *headerView;

@end

@implementation YYRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)setUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.allowsSelection = NO;
    
//    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketHomeSection0TableViewCell class]) bundle:nil] forCellReuseIdentifier:REDPACKET_HOME_SECTION0_CELL_ID];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    _tableView = tableView;
    [self.view addSubview:_tableView];
    
    WEAKSELF
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf.view);
        make.top.offset(-STATUS_HEIGHT - 44);
    }];
}

#pragma mark ----- UITableView ---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    YYRedPacketHomeSection0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_HOME_SECTION0_CELL_ID forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"staic"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerView.height;
}

- (YYRedPacketHomeHeaderView *)headerView {
    if (!_headerView) {
        YYRedPacketHomeHeaderView *headerView = [[YYRedPacketHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 223 - 20 + STATUS_HEIGHT)];
        _headerView = headerView;
    }
    return _headerView;
}

@end
