//
//  DBHInWeHotViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInWeHotViewController.h"

#import "KKWebView.h"
#import "DBHFunctionalUnitLookViewController.h"

#import "DBHProjectHomeHeaderView.h"
#import "DBHProjectHomeTypeTwoTableViewCell.h"

#import "DBHProjectHomeNewsDataModels.h"

static NSString *const kDBHProjectHomeTypeTwoTableViewCellIdentifier = @"kDBHProjectHomeTypeTwoTableViewCellIdentifier";

@interface DBHInWeHotViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIButton *yourOpinionButton;

@property (nonatomic, assign) NSInteger currentPage; // 当前页
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHInWeHotViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self addRefresh];
    
    self.currentPage = 1;
    [self getInfomation];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_ren_ico"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToPersonBarButtonItem)];
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.grayLineView];
    //[self.view addSubview:self.yourOpinionButton];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
//        make.bottom.equalTo(weakSelf.grayLineView.mas_top);
        make.bottom.equalTo(weakSelf.view);
    }];
//    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(1));
//        make.centerX.equalTo(weakSelf.view);
//        make.bottom.equalTo(weakSelf.yourOpinionButton.mas_top);
//    }];
//    [self.yourOpinionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(47));
//        make.centerX.bottom.equalTo(weakSelf.view);
//    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHProjectHomeTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectHomeTypeTwoTableViewCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.section];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHProjectHomeNewsModelData *model = self.dataSource[indexPath.section];
    KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"http://inwecrypto.com/newsdetail2?art_id=%ld", (NSInteger)model.dataIdentifier]];
    webView.title = model.title;
    webView.isHaveShare = YES;
    [self.navigationController pushViewController:webView animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DBHProjectHomeNewsModelData *model = self.dataSource[section];
    DBHProjectHomeHeaderView *headerView = [[DBHProjectHomeHeaderView alloc] init];
    headerView.time = model.updatedAt;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(42);
}

#pragma mark ------ Data ------
/**
 获取Inwe热点数据
 */
- (void)getInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"article?is_scroll&per_page=5&page=%ld", self.currentPage] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        
        [weakSelf.dataSource removeAllObjects];
        NSArray *dataArray = responseCache[@"data"];
        for (NSInteger i = dataArray.count - 1; i >= 0; i--) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:dataArray[i]];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf scrollViewToBottom:NO];
        });
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        
        if (weakSelf.currentPage == 1) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *array = responseObject[@"data"];
        for (NSInteger i = array.count - 1; i >= 0; i--) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:array[i]];
            
            [dataArray addObject:model];
        }
        
        if (weakSelf.currentPage == 1) {
            [weakSelf.dataSource addObjectsFromArray:dataArray];
        } else if (dataArray.count) {
            [weakSelf.dataSource insertObjects:dataArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dataArray.count)]];
        }
        
        [weakSelf.tableView reloadData];
        if (weakSelf.currentPage == 1) {
            if (weakSelf.dataSource.count > 2) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[weakSelf.dataSource count] - 1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        } else if (dataArray.count) {
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:dataArray.count] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}

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
/**
 你的观点
 */
- (void)respondsToYourOpinionButton {
    if ([self.conversation isKindOfClass:[EMConversation class]]) {
        // 内存中有会话
        EaseMessageViewController *chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:self.conversation.conversationId conversationType:self.conversation.type];
        chatViewController.title = self.title;
        [self.navigationController pushViewController:chatViewController animated:YES];
    } else {
        // 内存中没有会话
        EMError *error = nil;
        NSArray *myGroups = [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:1 pageSize:50 error:&error];
        if (!error) {
            for (EMGroup *group in myGroups) {
                if ([group.subject containsString:@"SYS_MSG_INWEHOT"]) {
                    EaseMessageViewController *chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
                    chatViewController.title = self.title;
                    [self.navigationController pushViewController:chatViewController animated:YES];
                }
            }
        }
    }
}

#pragma mark ------ Private Methods ------
/**
 滑动到底部
 */
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.dataSource.count < weakSelf.currentPage * 5) {
            [weakSelf endRefresh];
            
            return ;
        }
        
        weakSelf.currentPage += 1;
        [weakSelf getInfomation];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
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
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(215.5);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHProjectHomeTypeTwoTableViewCell class] forCellReuseIdentifier:kDBHProjectHomeTypeTwoTableViewCellIdentifier];
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
    }
    return _dataSource;
}

@end
