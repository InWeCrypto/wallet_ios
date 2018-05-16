//
//  YYRedPacketSuccessViewController.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSuccessViewController.h"
#import "YYRedPacketSucessTableViewCell.h"

#import "YYRedPacketDetailTableViewCell.h"
#import "YYRedPacketDetailHeaderView.h"

@interface YYRedPacketSuccessViewController ()

@end

@implementation YYRedPacketSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDetailData];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarTitleColor];
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
//获取红包详情
- (void)getDetailData {
    NSString *urlStr = [NSString stringWithFormat:@"redbag/send_record/%ld", self.model.redbag.redPacketId];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
            [weakSelf handleResponseObj:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    });
}

- (void)handleResponseObj:(id)responseObj {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        YYRedPacketDetailModel *model = [YYRedPacketDetailModel mj_objectWithKeyValues:responseObj];
        self.model.redbag = model;
        
        [self.tableView reloadData];
    }
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Opened Success", nil);
    
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return self.model.redbag.draws.count;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        YYRedPacketSucessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SUCCESS_CELL_ID forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }
    
    YYRedPacketDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_DETAIL_CELL_ID forIndexPath:indexPath];
    
    if (row == self.model.redbag.draw_redbag_number - 1) {
        cell.isLastCellInSection = YES;
    } else {
        cell.isLastCellInSection = NO;
    }
    
    [cell setModel:self.model.redbag redbagCellType:RedBagCellTypeDrawNum index:row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return REDPACKET_SUCCESS_CELL_HEIGHT - 20 + STATUS_HEIGHT;
    }
    
    return REDPACKET_DETAIL_CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    }
    
    YYRedPacketDetailHeaderView *headerView = [[YYRedPacketDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DETAIL_HEADERVIEW_HEIGHT)];
    [headerView setModel:self.model.redbag redbagCellType:RedBagCellTypeDrawNum];
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

- (void)setModel:(YYRedPacketOpenedModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    [self.tableView reloadData];
}
@end
