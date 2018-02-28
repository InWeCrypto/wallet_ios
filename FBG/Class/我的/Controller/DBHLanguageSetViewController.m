//
//  DBHLanguageSetViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHLanguageSetViewController.h"

#import "DBHMonetaryUnitTableViewCell.h"

static NSString *const kDBHMonetaryUnitTableViewCellIdentifier = @"kDBHMonetaryUnitTableViewCellIdentifier";

@interface DBHLanguageSetViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentSelectedRow;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHLanguageSetViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Languages", nil);
    self.view.backgroundColor = COLORFROM16(0xF8F8F8, 1);
    self.currentSelectedRow = [LANGUAGE isEqualToString:EN] ? 1 : 0;
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Confirm", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSureBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHMonetaryUnitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMonetaryUnitTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.isSelected = self.currentSelectedRow == indexPath.row;
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelectedRow = indexPath.row;
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(11.5);
}

#pragma mark ------ Event Responds ------
/**
 确定
 */
- (void)respondsToSureBarButtonItem {
    [[DBHLanguageTool sharedInstance] setNewLanguage:self.currentSelectedRow ? EN : CNS];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(51);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHMonetaryUnitTableViewCell class] forCellReuseIdentifier:kDBHMonetaryUnitTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"简体中文", @"English(U.S.)"];
    }
    return _titleArray;
}

@end
