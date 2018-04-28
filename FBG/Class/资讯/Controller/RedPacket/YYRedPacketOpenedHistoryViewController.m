//
//  YYRedPacketOpenedHistoryViewController.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketOpenedHistoryViewController.h"
#import "YYRedPacketSection1TableViewCell.h"
#import "YYRedPacketSuccessViewController.h"
#define REDPACKET_STORYBOARD_NAME @"RedPacket"

@interface YYRedPacketOpenedHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *grayLineView;

@end

@implementation YYRedPacketOpenedHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.title = DBHGetStringWithKeyFromTable(@"Opened Record", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR] forBarMetrics:UIBarMetricsDefault];
}

- (void)setUI {
    [self.view addSubview:self.grayLineView];
    
    WEAKSELF
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    
    tableView.tableHeaderView = nil;
    tableView.sectionHeaderHeight = 0;
    
    tableView.tableFooterView = nil;
    tableView.sectionFooterHeight = 0;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketSection1TableViewCell class]) bundle:nil] forCellReuseIdentifier:REDPACKET_SECTION1_CELL_ID];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = tableView;
    [self.view addSubview:_tableView];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(8));
    }];
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.dataSource.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYRedPacketSection1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SECTION1_CELL_ID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYRedPacketSuccessViewController *vc = [[UIStoryboard storyboardWithName:REDPACKET_STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:REDPACKET_SUCCESS_STORYBOARD_ID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return REDPACKET_SECTION1_CELL_HEIGHT;
}

#pragma mark ----- Setters And Getters ---------

- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _grayLineView;
}

@end
