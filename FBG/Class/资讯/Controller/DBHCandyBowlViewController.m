//
//  DBHCandyBowlViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCandyBowlViewController.h"

#import "DBHCandyBowlHeaderView.h"
#import "DBHCandyBowlTableViewCell.h"

static NSString *const kDBHCandyBowlTableViewCellIdentifier = @"kDBHCandyBowlTableViewCellIdentifier";

@interface DBHCandyBowlViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHCandyBowlHeaderView *candyBowlHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIButton *yourOpinionButton;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHCandyBowlViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CandyBowl";
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHCandyBowlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHCandyBowlTableViewCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
- (DBHCandyBowlHeaderView *)candyBowlHeaderView {
    if (!_candyBowlHeaderView) {
        _candyBowlHeaderView = [[DBHCandyBowlHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(396.5))];
    }
    return _candyBowlHeaderView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = self.candyBowlHeaderView;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(91);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHCandyBowlTableViewCell class] forCellReuseIdentifier:kDBHCandyBowlTableViewCellIdentifier];
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
