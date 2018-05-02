//
//  YYRedPacketSendHistoryViewController.m
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendHistoryViewController.h"
#import "YYRedPacketSection1TableViewCell.h"
#import "YYRedPacketDetailViewController.h"
#import "DBHWalletManagerForNeoModelList.h"


#define REDPACKET_STORYBOARD_NAME @"RedPacket"

@interface YYRedPacketSendHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, assign) NSInteger page; // 分页

@end

@implementation YYRedPacketSendHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self addRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR] forBarMetrics:UIBarMetricsDefault];
}

- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send History", nil);
    
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

#pragma mark ------- Data ---------
- (void)getSentRedPacketListIsLoadMore:(BOOL)isLoadMore {
    if (![UserSignData share].user.isLogin) {
        return;
    }
    
    if (isLoadMore) {
        self.page += 1;
    } else {
        self.page = 0;
    }
    
    NSString *urlStr = @"redbag/send_record";
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        
        NSMutableArray *tempAddrArr = [NSMutableArray array];
        for (DBHWalletManagerForNeoModelList *model in self.ethWalletsArray) {
            @autoreleasepool {
                NSString *addr = model.address;
                if (![NSObject isNulllWithObject:addr]) {
                    [tempAddrArr addObject:addr];
                }
            }
        }
        
        NSDictionary *params = @{
                                 @"wallet_addrs" : tempAddrArr
                                 };
        
        WEAKSELF
        [PPNetworkHelper POST:urlStr baseUrlType:3 parameters:params hudString:nil success:^(id responseObject) {
            [weakSelf endRefresh];
            [weakSelf handleResponse:responseObject isLoadMore:isLoadMore];
        } failure:^(NSString *error) {
            [weakSelf endRefresh];
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
    });
}

- (void)handleResponse:(id)responseObj isLoadMore:(BOOL)isLoadMore {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        if ([NSObject isNulllWithObject:responseObj]) {
            return;
        }
        
        NSMutableArray *tempArr = [NSMutableArray array];
        if (isLoadMore) {
            [tempArr addObjectsFromArray:self.dataSource];
        }
        
        if (![NSObject isNulllWithObject:responseObj]) {
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                YYRedPacketMySentModel *sentModel = [YYRedPacketMySentModel mj_objectWithKeyValues:responseObj];
                NSArray *dataArray = sentModel.data;
                if (![NSObject isNulllWithObject:dataArray] &&
                    [dataArray isKindOfClass:[NSArray class]] &&
                    dataArray.count > 0) {
                    if (dataArray.count <= 10) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                    for (YYRedPacketMySentListModel *listModel in dataArray) {
                        [tempArr addObject:listModel];
                    }
                }
            }
        }
        self.dataSource = tempArr;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getSentRedPacketListIsLoadMore:NO];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getSentRedPacketListIsLoadMore:YES];
    }];
    
    if (self.dataSource.count <= 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
/**
 结束刷新
 */
- (void)endRefresh {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYRedPacketSection1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SECTION1_CELL_ID forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YYRedPacketMySentListModel *model = self.dataSource[indexPath.row];
        [cell setModel:model from:CellFromSentHistory];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYRedPacketDetailViewController *vc = [[UIStoryboard storyboardWithName:REDPACKET_STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:REDPACKET_DETAIL_STORYBOARD_ID];
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
