//
//  YYRedPacketViewController.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketViewController.h"
#import "YYRedPacketHomeHeaderView.h"

#import "YYRedPacketSection0TableViewCell.h"
#import "YYRedPacketSection1TableViewCell.h"
#import "YYRedPacketSendHistoryViewController.h"

#define HEADER_VIEW_HEIGHT 223

@interface YYRedPacketViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, weak) YYRedPacketHomeHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *dataSource;

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
    
    tableView.tableHeaderView = nil;
    tableView.sectionHeaderHeight = 0;
    
    tableView.tableFooterView = nil;
    tableView.sectionFooterHeight = 0;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketSection0TableViewCell class]) bundle:nil] forCellReuseIdentifier:REDPACKET_SECTION0_CELL_ID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketSection1TableViewCell class]) bundle:nil] forCellReuseIdentifier:REDPACKET_SECTION1_CELL_ID];
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
    
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = tableView;
    [self.view addSubview:_tableView];
    
    WEAKSELF
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf.view);
        make.top.offset(- 44);
    }];
}

#pragma mark ----- RespondsToSelector ---------
- (void)respondsToMoreBtn {
    YYRedPacketSendHistoryViewController *vc = [[YYRedPacketSendHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        YYRedPacketSection0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SECTION0_CELL_ID forIndexPath:indexPath];
        
        return cell;
    }
  
    YYRedPacketSection1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SECTION1_CELL_ID forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return REDPACKET_SECTION0_CELL_HEIGHT;
    }
    
    return REDPACKET_SECTION1_CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    view.backgroundColor = WHITE_COLOR;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:DBHGetStringWithKeyFromTable(@"Check transfer Record", nil) forState:UIControlStateNormal];
    [btn setTitleColor:COLORFROM16(0xDF565B, 1) forState:UIControlStateNormal];
    [btn setBorderWidth:1 color:COLORFROM16(0xDF565B, 1)];
    
    btn.titleLabel.font = FONT(13);
    
    CGFloat width = [NSString getWidthtWithString:btn.currentTitle fontSize:13] + 100;
    btn.frame = CGRectMake(0, 0, width, 36);
    btn.center = view.center;
    [btn addTarget:self action:@selector(respondsToMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (YYRedPacketHomeHeaderView *)headerView {
    if (!_headerView) {
        YYRedPacketHomeHeaderView *headerView = [[YYRedPacketHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 223 - 20 + STATUS_HEIGHT)];
        _headerView = headerView;
    }
    return _headerView;
}

@end
