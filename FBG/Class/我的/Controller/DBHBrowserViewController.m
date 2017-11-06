//
//  DBHBrowserViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHBrowserViewController.h"

#import "DBHBrowserTableViewCell.h"

static NSString * const kDBHBrowserTableViewCellIdentifier = @"kDBHBrowserTableViewCellIdentifier";

@interface DBHBrowserViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHBrowserViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"浏览器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHBrowserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHBrowserTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = 55;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHBrowserTableViewCell class] forCellReuseIdentifier:kDBHBrowserTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"BLOCKCHAIN",
                        @"ETHERSCAN",
                        @"NEO TRACKER"];
    }
    return _titleArray;
}

@end
