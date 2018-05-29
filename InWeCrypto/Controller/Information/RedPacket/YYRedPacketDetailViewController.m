//
//  YYRedPacketDetailViewController.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailViewController.h"
#import "YYRedPacketDetailHeaderView.h"
#import "YYRedPacketDetailTableViewCell.h"
#import "YYRedPacketDetailSpecialTableViewCell.h"
#import "YYRedPacketPackagingViewController.h"
#import "YYRedPacketPreviewViewController.h"
#import "YYRedPacketSendSecondViewController.h"

@interface YYRedPacketDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YYRedPacketDetailModel *detailModel;

@end

@implementation YYRedPacketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getDetailData];
    
    [self setNavigationBarTitleColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.tableView setContentOffset:CGPointZero animated:NO]; // 滚到顶部
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)redPacketNavigationBar {
    NSArray *colors = @[COLORFROM16(0xD9725B, 1), COLORFROM16(0xC35542, 1)];
    UIImage *image = [UIImage imageWithGradients:colors];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ------- Data ---------
- (void)getDetailData {
    if (![UserSignData share].user.isLogin) {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"redbag/send_record/%ld", self.model.redPacketId];
    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"Loading...", nil)];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
            [weakSelf handleResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD hide];
            [LCProgressHUD showFailure:error];
        }];
    });
}

- (void)handleResponse:(id)responseObj {
    if ([NSObject isNulllWithObject:responseObj]) {
        [LCProgressHUD hide];
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        YYRedPacketDetailModel *model = [YYRedPacketDetailModel mj_objectWithKeyValues:responseObj];
        
        WEAKSELF
        [PPNetworkHelper POST:@"extend/blockNumber" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
            [weakSelf loadCurrentBlockResponse:responseObject model:model];
        } failure:^(NSString *error) {
            [LCProgressHUD hide];
        }];
    } else {
        [LCProgressHUD hide];
    }
}

- (void)loadCurrentBlockResponse:(id)responseObj model:(YYRedPacketDetailModel *)model {
    [LCProgressHUD hide];
    if (![NSObject isNulllWithObject:responseObj]) {
        NSString *value = [responseObj objectForKey:VALUE];
        if (value.length > 2) {
            value = [value substringFromIndex:2];
            model.current_block = [NSString numberHexString:value].integerValue;
        }
    }
    
    self.detailModel = model;
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Red Packet Detail", nil);

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.bounces = NO;
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > -scrollView.contentInset.top) {
        [self redPacketNavigationBar];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark ----- UITableView ---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    RedBagStatus status = self.detailModel.status;
    if (status == RedBagStatusCashPackaging || status == RedBagStatusCashPackageFailed || status == RedBagStatusCashAuthPending) { // 礼金打包
        count = count + 1;
    } else if (status == RedBagStatusCreateFailed || status == RedBagStatusCreating || status == RedBagStatusCreatePending) { // 红包创建
        count = count + 2;
    } else if (status == RedBagStatusOpening) {
        count = count + 3;
    } else if (status == RedBagStatusDone) {
        count = count + 3;
        
        NSString *backPrice = [NSString convertValue:self.detailModel.redbag_back decimals:self.detailModel.gnt_category.decimals];
        if (backPrice.doubleValue > 0) // 有退回金额
            count = count + 1;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 3:
            return self.detailModel.draw_redbag_number;
            break;
          
        default:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        YYRedPacketDetailSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_DETAIL_SPECIAL_CELL_ID forIndexPath:indexPath];
        cell.model = self.detailModel;
        WEAKSELF
        [cell setBlock:^(RedBagStatus status) {
            if (status == RedBagStatusCashPackaging ||
                status == RedBagStatusCreating ||
                status == RedBagStatusCashAuthPending ||
                status == RedBagStatusCreatePending) {
                [weakSelf pushToPackagingVC:status];
            } else if (status == RedBagStatusDone || status == RedBagStatusOpening) {
                // 预览界面
                [weakSelf pushToPreviewVC:status];
            } else if (status == RedBagStatusCreateFailed && self.detailModel.global_status == 8) { // 可以重新创建
                [weakSelf pushToSecondVC];
            }
        }];
        
        [cell setClickCopyBlock:^(NSString *orderNumber) {
            [weakSelf pushToWebView:orderNumber];
        }];
        return cell;
    }

    NSInteger row = indexPath.row;
    YYRedPacketDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_DETAIL_CELL_ID forIndexPath:indexPath];
    [cell setModel:self.detailModel redbagCellType:(RedBagCellType)section - 1 index:row];
    if (section == 1 || section == 2 || section == 4) {
        cell.isLastCellInSection = YES;
    } else {
        if (row == self.detailModel.draw_redbag_number - 1) {
            cell.isLastCellInSection = YES;
        } else {
            cell.isLastCellInSection = NO;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat height = REDPACKET_DETAIL_SPECIAL_CELL_HEIGHT - 20 + STATUS_HEIGHT;
        RedBagStatus status = self.detailModel.status;
        if (status == RedBagStatusOpening ||
            status == RedBagStatusDone ||
            status == RedBagStatusCreateFailed ||
            (status == RedBagStatusCashPackageFailed && self.detailModel.global_status != 8)) {
            height += REDPACKET_ADD_HEIGHT;
        }
        
        return height;
    }

    return REDPACKET_DETAIL_CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    }
    
    YYRedPacketDetailHeaderView *headerView = [[YYRedPacketDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DETAIL_HEADERVIEW_HEIGHT)];
    [headerView setModel:self.detailModel redbagCellType:(RedBagCellType)section - 1];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return DETAIL_HEADERVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = COLORFROM16(0xFAFAFA, 1);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark ------- Push To VC ---------
- (void)pushToPackagingVC:(RedBagStatus)status {
    YYRedPacketPackagingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_PACKAGING_STORYBOARD_ID];
    if (status == RedBagStatusCashPackaging || status == RedBagStatusCashAuthPending) {
        vc.packageType = PackageTypeCash;
    } else if (status == RedBagStatusCreating || status == RedBagStatusCreatePending) {
        vc.packageType = PackageTypeRedPacket;
    }
    vc.ethWalletsArray = self.ethWalletsArr;
    vc.model = self.detailModel;
    vc.from = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToPreviewVC:(RedBagStatus)status {
    YYRedPacketPreviewViewController *vc = [[YYRedPacketPreviewViewController alloc] init];
    if (status == RedBagStatusOpening) {
        vc.hideShareBtn = NO;
    } else if (status == RedBagStatusDone) {
       vc.hideShareBtn = YES;
    }
    vc.detailModel = self.detailModel;
    vc.from = PreViewVCFromDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToSecondVC {
    YYRedPacketSendSecondViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_SECOND_STORYBOARD_ID];
    vc.model = self.detailModel;
    vc.ethWalletsArray = self.ethWalletsArr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToWebView:(NSString *)orderNumber {
    NSString *url;
    if ([APP_APIEHEAD isEqualToString:V2API])  {
        //正式
        url = @"https://etherscan.io/tx/";
    } else {
        //测试
        url = @"https://ropsten.etherscan.io/tx/";
    }
    
    KKWebView * vc = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", url, orderNumber]];
    vc.title = DBHGetStringWithKeyFromTable(@"Check the balance", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----- Setters And Getters ---------
- (void)setDetailModel:(YYRedPacketDetailModel *)detailModel {
    _detailModel = detailModel;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
