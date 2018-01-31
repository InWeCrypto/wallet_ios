
//
//  DBHProjectOverviewNoTradingViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectOverviewNoTradingViewController.h"

#import "DBHInputView.h"
#import "DBHProjectHomeMenuView.h"
#import "DBHProjectOverviewForProjectInfomtaionTableViewCell.h"
#import "DBHProjectOverviewNoTradingForRelevantInformationTableViewCell.h"
#import "DBHProjectOverviewNoTradingTableViewCell.h"

#import "DBHProjectDetailInformationDataModels.h"

static NSString *const kDBHProjectOverviewForProjectInfomtaionTableViewCellIdentifier = @"kDBHProjectOverviewForProjectInfomtaionTableViewCellIdentifier";
static NSString *const kDBHProjectOverviewNoTradingForRelevantInformationTableViewCellIdentifier = @"kDBHProjectOverviewNoTradingForRelevantInformationTableViewCellIdentifier";
static NSString *const kDBHProjectOverviewNoTradingTableViewCellIdentifier = @"kDBHProjectOverviewNoTradingTableViewCellIdentifier";

@interface DBHProjectOverviewNoTradingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHInputView *keyboardView;
@property (nonatomic, strong) DBHProjectHomeMenuView *projectHomeMenuView;

@end

@implementation DBHProjectOverviewNoTradingViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.projectDetailModel.unit;
    self.view.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyboardView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(1));
        make.bottom.equalTo(weakSelf.keyboardView.mas_top);
    }];
    [self.keyboardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(47));
        make.centerX.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            DBHProjectOverviewForProjectInfomtaionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOverviewForProjectInfomtaionTableViewCellIdentifier forIndexPath:indexPath];
            cell.projectDetailModel = self.projectDetailModel;
            
            return cell;
            break;
        }
        case 1: {
            DBHProjectOverviewNoTradingForRelevantInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOverviewNoTradingForRelevantInformationTableViewCellIdentifier forIndexPath:indexPath];
            cell.projectDetailModel = self.projectDetailModel;
            
            return cell;
            break;
        }
        case 2: {
            DBHProjectOverviewNoTradingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectOverviewNoTradingTableViewCellIdentifier forIndexPath:indexPath];
            
            return cell;
            break;
        }
            
        default:
            return nil;
            break;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return AUTOLAYOUTSIZE(169);
            break;
        case 1:
            return AUTOLAYOUTSIZE(215.5);
            break;
        case 2:
            return AUTOLAYOUTSIZE(180);
            break;
            
        default:
            return 0;
            break;
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHProjectOverviewForProjectInfomtaionTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewForProjectInfomtaionTableViewCellIdentifier];
        [_tableView registerClass:[DBHProjectOverviewNoTradingForRelevantInformationTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewNoTradingForRelevantInformationTableViewCellIdentifier];
        [_tableView registerClass:[DBHProjectOverviewNoTradingTableViewCell class] forCellReuseIdentifier:kDBHProjectOverviewNoTradingTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHInputView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[DBHInputView alloc] init];
        _keyboardView.dataSource = @[@{@"value":@"Explore", @"isMore":@"1"},
                                     @{@"value":@"Wallet", @"isMore":@"1"}];
        
        WEAKSELF
        [_keyboardView clickButtonBlock:^(NSInteger buttonType) {
            switch (buttonType) {
                case 0: {
                    // 聊天室
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    break;
                }
                case 1: {
                    // 浏览器
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    } else {
                        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.projectHomeMenuView];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.projectHomeMenuView animationShow];
                        });
                    }
                    break;
                }
                case 2: {
                    // 钱包
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    break;
                }
                case 3: {
                    // 令牌持有人
                    if (weakSelf.projectHomeMenuView.superview) {
                        [weakSelf.projectHomeMenuView animationHide];
                    }
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _keyboardView;
}
- (DBHProjectHomeMenuView *)projectHomeMenuView {
    if (!_projectHomeMenuView) {
        _projectHomeMenuView = [[DBHProjectHomeMenuView alloc] init];
        _projectHomeMenuView.line = 1;
        _projectHomeMenuView.maxLine = 3;
        _projectHomeMenuView.dataSource = @[@"Project overview",
                                            @"Real-Time Quotes",
                                            @"Trading Market"];
    }
    return _projectHomeMenuView;
}

@end
