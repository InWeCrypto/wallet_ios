//
//  DBHExchangeNoticeViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHExchangeNoticeViewController.h"

#import "DBHProjectHomeHeaderView.h"
#import "DBHIotificationTableViewCell.h"

static NSString *const kDBHIotificationTableViewCellIdentifier = @"kDBHIotificationTableViewCellIdentifier";

@interface DBHExchangeNoticeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIButton *yourOpinionButton;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHExchangeNoticeViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"交易所公告";
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_ren_ico"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToPersonBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.grayLineView];
    [self.view addSubview:self.yourOpinionButton];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.grayLineView.mas_top);
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.yourOpinionButton.mas_top);
    }];
    [self.yourOpinionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(47));
        make.centerX.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHIotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHIotificationTableViewCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //    DBHProjectHomeNewsModelData *model = self.dataSource[section - 1];
    DBHProjectHomeHeaderView *headerView = [[DBHProjectHomeHeaderView alloc] init];
    headerView.time = @"2017-11-11 11:11:11";//model.updatedAt;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(42);
}

#pragma mark ------ Data ------

#pragma mark ------ Event Responds ------
/**
 项目查看
 */
- (void)respondsToPersonBarButtonItem {
    
}
/**
 你的观点
 */
- (void)respondsToYourOpinionButton {
    
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM10(235, 235, 235, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(150);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHIotificationTableViewCell class] forCellReuseIdentifier:kDBHIotificationTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xDEDEDE, 1);
    }
    return _grayLineView;
}
- (UIButton *)yourOpinionButton {
    if (!_yourOpinionButton) {
        _yourOpinionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _yourOpinionButton.titleLabel.font = FONT(14);
        [_yourOpinionButton setTitle:DBHGetStringWithKeyFromTable(@"Your Opinion", nil) forState:UIControlStateNormal];
        [_yourOpinionButton setTitleColor:COLORFROM16(0x626262, 1) forState:UIControlStateNormal];
        [_yourOpinionButton addTarget:self action:@selector(respondsToYourOpinionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yourOpinionButton;
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
