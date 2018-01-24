//
//  DBHInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInformationViewController.h"

#import "DBHPaymentReceivedViewController.h"

#import "DBHInformationTitleView.h"
#import "DBHMenuView.h"
#import "DBHInformationTableViewCell.h"

static NSString *const kDBHInformationTableViewCellIdentifier = @"kDBHInformationTableViewCellIdentifier";

@interface DBHInformationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHInformationTitleView *informationTitleView;
@property (nonatomic, strong) DBHMenuView *menuView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *menuArray; // 菜单选项
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.titleView = self.informationTitleView;
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationTableViewCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消收藏
    WEAKSELF
    UITableViewRowAction *cancelColletAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"Cancel Collection", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //        tableView.editing = NO;
    }];
    //删除按钮颜色
    
    cancelColletAction.backgroundColor = COLORFROM16(0xFF841C, 1);
    
    return @[cancelColletAction];
}

#pragma mark ------ Data ------

#pragma mark ------ Getters And Setters ------
- (DBHInformationTitleView *)informationTitleView {
    if (!_informationTitleView) {
        _informationTitleView = [[DBHInformationTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        
        WEAKSELF
        [_informationTitleView clickButtonBlock:^(NSInteger type) {
            if (!type) {
                // 搜索
            } else {
                // +号按钮
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.menuView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.menuView animationShow];
                });
            }
        }];
    }
    return _informationTitleView;
}
- (DBHMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[DBHMenuView alloc] init];
        _menuView.dataSource = self.menuArray;
        
        WEAKSELF
        [_menuView selectedBlock:^(NSInteger index) {
            switch (index) {
                case 0: {
                    // 扫一扫
                    break;
                }
                case 1: {
                    // 添加钱包
                    break;
                }
                case 2: {
                    // 收付款
                    DBHPaymentReceivedViewController *paymentReceivedViewController = [[DBHPaymentReceivedViewController alloc] init];
                    [weakSelf.navigationController pushViewController:paymentReceivedViewController animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _menuView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(63.5);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationTableViewCell class] forCellReuseIdentifier:kDBHInformationTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)menuArray {
    if (!_menuArray) {
        _menuArray = @[@"Scan", @"Add Wallet", @"Payment Received"];
    }
    return _menuArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@""];
        [_dataSource addObject:@""];
        [_dataSource addObject:@""];
    }
    return _dataSource;
}

@end
