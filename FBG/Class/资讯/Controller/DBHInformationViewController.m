//
//  DBHInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInformationViewController.h"

#import <HyphenateLite/HyphenateLite.h>

#import "DBHPaymentReceivedViewController.h"
#import "DBHProjectHomeViewController.h"
#import "DBHProjectHomeNoTradingViewController.h"
#import "DBHInWeHotViewController.h"
#import "DBHTradingViewViewController.h"
#import "DBHExchangeNoticeViewController.h"
#import "DBHCandyBowlViewController.h"
#import "DBHTraderClockViewController.h"
#import "DBHNotificationViewController.h"
#import "DBHCreateWalletViewController.h"
#import "DBHImportWalletViewController.h"

#import "DBHInformationTitleView.h"
#import "DBHMenuView.h"
#import "DBHInformationTopView.h"
#import "DBHInformationHeaderView.h"
#import "DBHAddWalletPromptView.h"
#import "DBHSelectWalletTypeOnePromptView.h"
#import "DBHSelectWalletTypeTwoPromptView.h"
#import "DBHInformationTableViewCell.h"

#import "DBHInformationDataModels.h"

static NSString *const kDBHInformationTableViewCellIdentifier = @"kDBHInformationTableViewCellIdentifier";

@interface DBHInformationViewController ()<UITableViewDataSource, UITableViewDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) DBHInformationTitleView *informationTitleView;
@property (nonatomic, strong) DBHMenuView *menuView;
@property (nonatomic, strong) DBHInformationTopView *informationTopView;
@property (nonatomic, strong) DBHInformationHeaderView *informationHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHAddWalletPromptView *addWalletPromptView;
@property (nonatomic, strong) DBHSelectWalletTypeOnePromptView *selectWalletTypeOnePromptView;
@property (nonatomic, strong) DBHSelectWalletTypeTwoPromptView *selectWalletTypeTwoPromptView;

@property (nonatomic, assign) BOOL isShowTopView; // 是否显示功能组件
@property (nonatomic, strong) NSArray *menuArray; // 菜单选项
@property (nonatomic, copy) NSArray *titleArray; // 功能组件标题
@property (nonatomic, strong) NSMutableArray *conversationArray; // 功能组件会话列表
@property (nonatomic, strong) NSMutableArray *contentArray; // 功能组件最新消息
@property (nonatomic, strong) NSMutableArray *timeArray; // 功能组件最新消息时间
@property (nonatomic, strong) NSMutableArray *noReadArray; // 未读消息数量
@property (nonatomic, copy) NSArray *titleGroupNameArray; // 功能组件对应环信的组名
@property (nonatomic, strong) NSMutableArray *functionalUnitArray; // 功能组件
@property (nonatomic, strong) NSMutableArray *dataSource; // 项目

@end

@implementation DBHInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf getFunctionalUnit];
    });
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.titleView = self.informationTitleView;
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.informationTopView];
    
    WEAKSELF
//    [self.informationTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
//        make.height.offset(AUTOLAYOUTSIZE(125));
//        make.centerX.equalTo(weakSelf.view);
//        make.top.offset(- AUTOLAYOUTSIZE(125));
//    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
    
    self.tableView.contentOffset = CGPointMake(0, 100);
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return !self.informationHeaderView.currentSelectedIndex ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !section && !self.informationHeaderView.currentSelectedIndex ? self.functionalUnitArray.count : self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationTableViewCellIdentifier forIndexPath:indexPath];
    if (!indexPath.section && !self.informationHeaderView.currentSelectedIndex) {
        cell.functionalUnitTitle = self.functionalUnitArray[indexPath.row];
        cell.content = self.contentArray[indexPath.row];
        cell.time = self.timeArray[indexPath.row];
        cell.noReadNumber = self.noReadArray[indexPath.row];
    } else {
        cell.model = self.dataSource[indexPath.row];
        cell.noReadNumber = 0;
    }
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section && !self.informationHeaderView.currentSelectedIndex) {
        // 标识为已读
        if (![self.conversationArray[indexPath.row] isKindOfClass:[NSString class]]) {
            EMConversation *conversation = self.conversationArray[indexPath.row];
            [conversation markAllMessagesAsRead:nil];
        }
        
        switch ([self.titleArray indexOfObject:self.functionalUnitArray[indexPath.row]]) {
            case 0: {
                // InWe热点
                DBHInWeHotViewController *inWeHotViewController = [[DBHInWeHotViewController alloc] init];
                inWeHotViewController.title = self.functionalUnitArray[indexPath.row];
                inWeHotViewController.functionalUnitType = 0;
                [self.navigationController pushViewController:inWeHotViewController animated:YES];
                break;
            }
            case 1: {
                // TradingView
                DBHTradingViewViewController *tradingViewViewController = [[DBHTradingViewViewController alloc] init];
                tradingViewViewController.title = self.functionalUnitArray[indexPath.row];
                tradingViewViewController.functionalUnitType = 1;
                [self.navigationController pushViewController:tradingViewViewController animated:YES];
                break;
            }
            case 2: {
                // 交易所公告
                DBHExchangeNoticeViewController *exchangeNoticeViewController = [[DBHExchangeNoticeViewController alloc] init];
                exchangeNoticeViewController.title = self.functionalUnitArray[indexPath.row];
                exchangeNoticeViewController.functionalUnitType = 2;
                [self.navigationController pushViewController:exchangeNoticeViewController animated:YES];
                break;
            }
            case 3: {
                // CandyBowl
                DBHCandyBowlViewController *candyBowlViewController = [[DBHCandyBowlViewController alloc] init];
                candyBowlViewController.title = self.functionalUnitArray[indexPath.row];
                candyBowlViewController.functionalUnitType = 3;
                [self.navigationController pushViewController:candyBowlViewController animated:YES];
                break;
            }
            case 4: {
                // 交易提醒
                DBHTraderClockViewController *traderClockViewController = [[DBHTraderClockViewController alloc] init];
                traderClockViewController.title = self.functionalUnitArray[indexPath.row];
                traderClockViewController.functionalUnitType = 4;
                [self.navigationController pushViewController:traderClockViewController animated:YES];
                break;
            }
            case 5: {
                // 通知
                DBHNotificationViewController *notificationViewController = [[DBHNotificationViewController alloc] init];
                notificationViewController.title = self.functionalUnitArray[indexPath.row];
                notificationViewController.functionalUnitType = 5;
                [self.navigationController pushViewController:notificationViewController animated:YES];
                break;
            }
                
            default:
                break;
        }
    } else {
        DBHInformationModelData *projectModel = self.dataSource[indexPath.row];
        
        if (projectModel.type == 1) {
            // 交易中项目
            DBHProjectHomeViewController *projectHomeViewController = [[DBHProjectHomeViewController alloc] init];
            projectHomeViewController.projectModel = projectModel;
            [self.navigationController pushViewController:projectHomeViewController animated:YES];
        } else {
            // 其他项目
            DBHProjectHomeNoTradingViewController *projectHomeNoTradingViewController = [[DBHProjectHomeNoTradingViewController alloc] init];
            projectHomeNoTradingViewController.projectModel = projectModel;
            [self.navigationController pushViewController:projectHomeNoTradingViewController animated:YES];
        }
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.informationHeaderView.currentSelectedIndex ? NO : YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消收藏
    WEAKSELF
    UITableViewRowAction *cancelColletAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(!indexPath.section ? @"Delete" : @"Cancel Collection", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if (!indexPath.section) {
            // 删除功能组件
            [UserSignData share].user.functionalUnitArray[indexPath.row] = @"1";
            [[UserSignData share] storageData:[UserSignData share].user];
            [weakSelf.functionalUnitArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            // 取消收藏
            [weakSelf cancelColletWithRow:indexPath.row];
        }
    }];
    //删除按钮颜色
    
    cancelColletAction.backgroundColor = COLORFROM16(0xFF841C, 1);
    
    return @[cancelColletAction];
}

//#pragma mark ------ UIScrollViewDelegate ------
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.informationTopView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(- AUTOLAYOUTSIZE(125) - scrollView.contentOffset.y);
//    }];
//}
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (self.isShowTopView) {
//        if (offsetY > AUTOLAYOUTSIZE(62.5)) {
//            self.isShowTopView = NO;
//        }
//    } else {
//        if (offsetY > AUTOLAYOUTSIZE(62.5)) {
//            self.isShowTopView = YES;
//        }
//    }
//}

#pragma mark ------ EMChatManagerDelegate ------
/**
 收到消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *msg in aMessages) {
        switch (msg.chatType) {
            case EMChatTypeChat: {
                // 单聊
                //                EMConversation *conversation =
                NSLog(@"ssss:%@", msg.conversationId);
                break;
            }
            case EMChatTypeGroupChat: {
                // 群聊
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:msg.conversationId error:&error];
                if (!error) {
                    NSInteger index = [self.titleGroupNameArray indexOfObject:[group.subject substringToIndex:group.subject.length - 3]];
                    if (index >= 0 && index < 4) {
                        [UserSignData share].user.functionalUnitArray[index] = @"0";
                        [[UserSignData share] storageData:[UserSignData share].user];
                    }
                }
                break;
            }
            case EMChatTypeChatRoom: {
                // 聊天室
                break;
            }
                
            default:
                break;
        }
    }
    [self getFunctionalUnit];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark ------ Data ------
/**
 获取项目列表
 */
- (void)getProjectList {
    WEAKSELF
    [PPNetworkHelper GET:!self.informationHeaderView.currentSelectedIndex ? @"category?user_favorite" : [NSString stringWithFormat:@"category?type=%ld", self.informationHeaderView.currentSelectedIndex] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[@"data"]) {
            DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }

        [weakSelf.informationHeaderView stopAnimation];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [weakSelf.informationHeaderView stopAnimation];
        [LCProgressHUD showFailure:error];
    }];
}
/**
 取消收藏
 */
- (void)cancelColletWithRow:(NSInteger)row {
    DBHInformationModelData *projectModel = self.dataSource[row];
    NSDictionary *paramters = @{@"enable":[NSNumber numberWithBool:false]};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/collect", (NSInteger)projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        [weakSelf.dataSource removeObjectAtIndex:row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Private Methods ------
/**
 获取功能组件
 */
- (void)getFunctionalUnit {
    self.conversationArray = [@[@"", @"", @"", @"", @"", @""] mutableCopy];
    self.contentArray = [@[@"", @"", @"", @"", @"", @""] mutableCopy];
    self.timeArray = [@[@"", @"", @"", @"", @"", @""] mutableCopy];
    self.noReadArray = [@[@"0", @"0", @"0", @"0", @"0", @"0"] mutableCopy];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    for (EMConversation *conversation in conversations) {
        if (conversation.type == EMConversationTypeGroupChat) {
            // 群组
            EMError *error = nil;
            EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:conversation.conversationId error:&error];
            if (!error) {
                NSInteger index = [self.titleGroupNameArray indexOfObject:[group.subject substringToIndex:group.subject.length - 3]];
                if (index >= 0 && index < 6) {
                    // 找到
                    if (conversation.latestMessage) {
                        NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)conversation.latestMessage.timestamp];
                        EMTextMessageBody *messageContent = (EMTextMessageBody *)conversation.latestMessage.body;
                        self.conversationArray[index] = conversation;
                        self.contentArray[index] = messageContent.text;
                        self.timeArray[index] = [messageDate formattedTime];
                        self.noReadArray[index] = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
                    }
                }
            }
        }
        
        if (conversation.type == EMConversationTypeChat) {
            // 单聊
            if ([conversation.conversationId isEqualToString:@"sys_msg_order"] || [conversation.conversationId isEqualToString:@"sys_msg"]) {
                if (conversation.latestMessage) {
                    NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)conversation.latestMessage.timestamp];
                    EMTextMessageBody *messageContent = (EMTextMessageBody *)conversation.latestMessage.body;
                    self.conversationArray[[conversation.conversationId isEqualToString:@"sys_msg_order"] ? 4 : 5] = conversation;
                    self.contentArray[[conversation.conversationId isEqualToString:@"sys_msg_order"] ? 4 : 5] = messageContent.text;
                    self.timeArray[[conversation.conversationId isEqualToString:@"sys_msg_order"] ? 4 : 5] = [messageDate formattedTime];
                    self.noReadArray[[conversation.conversationId isEqualToString:@"sys_msg_order"] ? 4 : 5] = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
                }
            }
        }
    }
    
    [self.functionalUnitArray removeAllObjects];
    for (NSInteger i = 0; i < [UserSignData share].user.functionalUnitArray.count; i++) {
        NSString *tag = [UserSignData share].user.functionalUnitArray[i];
        if ([tag isEqualToString:@"0"]) {
            [self.functionalUnitArray addObject:self.titleArray[i]];
        } else {
            [self.conversationArray removeObjectAtIndex:i];
            [self.contentArray removeObjectAtIndex:i];
            [self.timeArray removeObjectAtIndex:i];
            [self.noReadArray removeObjectAtIndex:i];
        }
    }

    [self getProjectList];
}

#pragma mark ------ Getters And Setters ------
- (void)setIsShowTopView:(BOOL)isShowTopView {
    _isShowTopView = isShowTopView;
    
    WEAKSELF
    [self.informationTopView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(_isShowTopView ? 0 : - AUTOLAYOUTSIZE(125));
    }];
    if (_isShowTopView) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.view);
            make.centerX.equalTo(weakSelf.view);
            make.top.offset(AUTOLAYOUTSIZE(125));
            make.bottom.equalTo(weakSelf.view);
        }];
    } else {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(weakSelf.view);
            make.center.equalTo(weakSelf.view);
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

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
                    [LCProgressHUD showMessage:NSLocalizedString(@"Coming Soon", nil)];
                    break;
                }
                case 1: {
                    // 添加钱包
                    [[UIApplication sharedApplication].keyWindow addSubview:self.addWalletPromptView];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.addWalletPromptView animationShow];
                    });
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
- (DBHInformationTopView *)informationTopView {
    if (!_informationTopView) {
        _informationTopView = [[DBHInformationTopView alloc] init];
        _informationTopView.backgroundColor = [UIColor redColor];
    }
    return _informationTopView;
}
- (DBHInformationHeaderView *)informationHeaderView {
    if (!_informationHeaderView) {
        _informationHeaderView = [[DBHInformationHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(41.5))];
        
        WEAKSELF
        [_informationHeaderView selectTypeBlock:^{
            [weakSelf.dataSource removeAllObjects];
            [weakSelf getProjectList];
        }];
    }
    return _informationHeaderView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = self.informationHeaderView;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(63.5);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationTableViewCell class] forCellReuseIdentifier:kDBHInformationTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHAddWalletPromptView *)addWalletPromptView {
    if (!_addWalletPromptView) {
        _addWalletPromptView = [[DBHAddWalletPromptView alloc] init];
        
        WEAKSELF
        [_addWalletPromptView selectedBlock:^(NSInteger index) {
            if (!index) {
                // 添加新钱包
                [[UIApplication sharedApplication].keyWindow addSubview:self.selectWalletTypeOnePromptView];
                
                WEAKSELF
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeOnePromptView animationShow];
                });
            } else {
                // 导入钱包
                DBHImportWalletViewController *importWalletViewController = [[DBHImportWalletViewController alloc] init];
                [weakSelf.navigationController pushViewController:importWalletViewController animated:YES];
            }
        }];
    }
    return _addWalletPromptView;
}
- (DBHSelectWalletTypeOnePromptView *)selectWalletTypeOnePromptView {
    if (!_selectWalletTypeOnePromptView) {
        _selectWalletTypeOnePromptView = [[DBHSelectWalletTypeOnePromptView alloc] init];
        
        WEAKSELF
        [_selectWalletTypeOnePromptView selectedBlock:^(NSInteger index) {
            if (index == - 1) {
                // 返回
                [[UIApplication sharedApplication].keyWindow addSubview:self.addWalletPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.addWalletPromptView animationShow];
                });
            } else if (!index) {
                // 添加NEO
                [[UIApplication sharedApplication].keyWindow addSubview:self.selectWalletTypeTwoPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeTwoPromptView animationShow];
                });
            } else {
                // 添加ETH
                [LCProgressHUD showInfoMsg:NSLocalizedString(@"Coming Soon", nil)];
            }
        }];
    }
    return _selectWalletTypeOnePromptView;
}
- (DBHSelectWalletTypeTwoPromptView *)selectWalletTypeTwoPromptView {
    if (!_selectWalletTypeTwoPromptView) {
        _selectWalletTypeTwoPromptView = [[DBHSelectWalletTypeTwoPromptView alloc] init];
        
        WEAKSELF
        [_selectWalletTypeTwoPromptView selectedBlock:^(NSInteger index) {
            if (index == - 1) {
                // 返回
                [[UIApplication sharedApplication].keyWindow addSubview:self.selectWalletTypeOnePromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeOnePromptView animationShow];
                });
            } else {
                if (!index) {
                    // 热钱包
                    DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
                    [weakSelf.navigationController pushViewController:createWalletViewController animated:YES];
                } else {
                    // 冷钱包
                    [LCProgressHUD showInfoMsg:NSLocalizedString(@"Coming Soon", nil)];
                }
            }
        }];
    }
    return _selectWalletTypeTwoPromptView;
}

- (NSArray *)menuArray {
    if (!_menuArray) {
        _menuArray = @[@"Scan", @"Add Wallet", @"Payment Received"];
    }
    return _menuArray;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"InWe热点", @"TradingView", @"交易所公告", @"CandyBowl", @"交易提醒", @"通知"];
    }
    return _titleArray;
}
- (NSMutableArray *)conversationArray {
    if (!_conversationArray) {
        _conversationArray = [NSMutableArray array];
        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
    }
    return _conversationArray;
}
- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
- (NSMutableArray *)timeArray {
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
        [_timeArray addObject:@""];
        [_timeArray addObject:@""];
        [_timeArray addObject:@""];
        [_timeArray addObject:@""];
        [_timeArray addObject:@""];
        [_timeArray addObject:@""];
    }
    return _timeArray;
}
- (NSMutableArray *)noReadArray {
    if (!_noReadArray) {
        _noReadArray = [NSMutableArray array];
        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
    }
    return _noReadArray;
}
- (NSArray *)titleGroupNameArray {
    if (!_titleGroupNameArray) {
        _titleGroupNameArray = @[@"SYS_MSG_INWEHOT", @"SYS_MSG_TRADING", @"SYS_MSG_EXCHANGENOTICE", @"SYS_MSG_CANDYBOW", @"SYS_MSG_ORDER", @"SYS_MSG"];
    }
    return _titleGroupNameArray;
}
- (NSMutableArray *)functionalUnitArray {
    if (!_functionalUnitArray) {
        _functionalUnitArray = [NSMutableArray array];
    }
    return _functionalUnitArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
