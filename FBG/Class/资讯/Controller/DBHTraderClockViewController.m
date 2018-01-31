//
//  DBHTraderClockViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTraderClockViewController.h"

#import "DBHFunctionalUnitLookViewController.h"

#import "DBHProjectHomeHeaderView.h"
#import "DBHTraderClockTableViewCell.h"

static NSString *const kDBHTraderClockTableViewCellIdentifier = @"kDBHTraderClockTableViewCellIdentifier";

@interface DBHTraderClockViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHTraderClockViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Trader Clock", nil);
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_ren_ico"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToPersonBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
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
    DBHTraderClockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHTraderClockTableViewCellIdentifier forIndexPath:indexPath];
    
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
    DBHFunctionalUnitLookViewController *functionalUnitLookViewController = [[DBHFunctionalUnitLookViewController alloc] init];
    functionalUnitLookViewController.title = self.title;
    functionalUnitLookViewController.functionalUnitType = self.functionalUnitType;
    [self.navigationController pushViewController:functionalUnitLookViewController animated:YES];
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
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(308);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHTraderClockTableViewCell class] forCellReuseIdentifier:kDBHTraderClockTableViewCellIdentifier];
    }
    return _tableView;
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
