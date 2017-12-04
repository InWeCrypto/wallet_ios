//
//  DBHSearchViewController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/21.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHSearchViewController.h"

#import "KKWebView.h"

#import "DBHSearchView.h"
#import "DBHSearchTableViewCell.h"

#import "DBHSearchDataModels.h"

static NSString *const kDBHSearchTableViewCellIdentifier = @"kDBHSearchTableViewCellIdentifier";

@interface DBHSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHSearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHSearchViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"171C27"];
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.searchView.searchTextField becomeFirstResponder];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(24));
        make.height.offset(AUTOLAYOUTSIZE(32.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(5));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchView.mas_bottom).offset(AUTOLAYOUTSIZE(5));
        make.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHSearchTableViewCellIdentifier forIndexPath:indexPath];
    DBHSearchModelData *model = self.dataSource[indexPath.row];
    cell.title = model.title;
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.title isEqualToString:@"搜索项目"]) {
        
    } else {
        DBHSearchModelData *model = self.dataSource[indexPath.row];
        
        NSString *url;
        if ([model.url containsString:@"http"]) {
            url = model.url;
        } else {
            url = [NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.url];
        }
        
        KKWebView * vc = [[KKWebView alloc] initWithUrl:url];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchView endEditing:YES];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UIPanGestureRecognizer *panGR = scrollView.panGestureRecognizer;
    CGFloat velocity = [panGR velocityInView:scrollView].y;
    
    if (velocity >= -15 && velocity <= 15) {
        return;
    }
    
    WEAKSELF
    [self.searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(24));
        make.height.offset(AUTOLAYOUTSIZE(32.5));
        make.centerX.equalTo(weakSelf.view);
        if (velocity < - 15) {
            make.top.offset(- AUTOLAYOUTSIZE(59.5));
        } else if (velocity > 15) {
            make.top.offset(AUTOLAYOUTSIZE(5));
        }
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

#pragma mark ------ Data ------
/**
 根据关键字搜索
 */
- (void)searchWithKeyword:(NSString *)keyword {
    WEAKSELF
    NSString *searchType = @"project";
    if ([self.title isEqualToString:@"搜索资讯"]) {
        searchType = @"articles";
    }
    if ([self.title isEqualToString:@"搜索Ico评测"]) {
        searchType = @"ico_assess";
    }
    [PPNetworkHelper GET:[NSString stringWithFormat:@"https://dev.inwecrypto.com/search/%@/?k=%@", searchType, keyword] isOtherBaseUrl:NO parameters:nil hudString:@"" success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        for (NSDictionary *dic in responseObject) {
            DBHSearchModelData *model = [DBHSearchModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Getters And Setters ------
- (DBHSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[DBHSearchView alloc] init];
        
        WEAKSELF
        [_searchView keywordsUpdateBlock:^(NSString *keywords) {
            // 搜索关键字改变
            [weakSelf searchWithKeyword:keywords];
        }];
    }
    return _searchView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"171C27"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(50);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHSearchTableViewCell class] forCellReuseIdentifier:kDBHSearchTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
