//
//  DBHProjectHomeViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeViewController.h"

@interface DBHProjectHomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHProjectHomeViewController

//#pragma mark ------ Lifecycle ------
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self setUI];
//}
//
//#pragma mark ------ UI ------
//- (void)setUI {
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Confirm", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToConfirmBarButtonItem)];
//    
//    [self.view addSubview:self.tableView];
//    
//    WEAKSELF
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(weakSelf.view);
//        make.center.equalTo(weakSelf.view);
//    }];
//}
//
//#pragma mark ------ UITableViewDataSource ------
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DBHSelectWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHSelectWalletTableViewCellIdentifier forIndexPath:indexPath];
//    DBHWalletManagerForNeoModelList *model = self.dataSource[indexPath.row];
//    cell.title = model.name;
//    cell.isSelected = indexPath.row == self.currentSelectedRow;
//    
//    return cell;
//}
//
//#pragma mark ------ UITableViewDelegate ------
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == self.currentSelectedRow) {
//        return;
//    }
//    
//    self.currentSelectedRow = indexPath.row;
//    [self.tableView reloadData];
//}
//
//#pragma mark ------ Getters And Setters ------
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] init];
//        _tableView.backgroundColor = BACKGROUNDCOLOR;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        _tableView.rowHeight = AUTOLAYOUTSIZE(70);
//        
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        
//        [_tableView registerClass:[DBHSelectWalletTableViewCell class] forCellReuseIdentifier:kDBHSelectWalletTableViewCellIdentifier];
//    }
//    return _tableView;
//}
//
//- (NSMutableArray *)dataSource {
//    if (!_dataSource) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}

@end
