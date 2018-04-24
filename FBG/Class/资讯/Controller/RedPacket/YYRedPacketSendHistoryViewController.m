//
//  YYRedPacketSendHistoryViewController.m
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendHistoryViewController.h"
#import "YYRedPacketSection1TableViewCell.h"

@interface YYRedPacketSendHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation YYRedPacketSendHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.title = DBHGetStringWithKeyFromTable(@"Send History", nil);
}

- (void)setUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    
    tableView.tableHeaderView = nil;
    tableView.sectionHeaderHeight = 0;
    
    tableView.tableFooterView = nil;
    tableView.sectionFooterHeight = 0;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    
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
    
    WEAKSELF
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYRedPacketSection1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SECTION1_CELL_ID forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return REDPACKET_SECTION1_CELL_HEIGHT;
}

@end
