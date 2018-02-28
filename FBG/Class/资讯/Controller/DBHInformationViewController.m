//
//  DBHInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInformationViewController.h"

#import <HyphenateLite/HyphenateLite.h>

#import "DBHSearchViewController.h"
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
#import "DBHInformationHeaderView.h"
#import "DBHAddWalletPromptView.h"
#import "DBHSelectWalletTypeOnePromptView.h"
#import "DBHSelectWalletTypeTwoPromptView.h"
#import "DBHInformationTableViewCell.h"

#import "DBHInformationDataModels.h"
#import "DBHInformationForICODataModels.h"

static NSString *const kDBHInformationTableViewCellIdentifier = @"kDBHInformationTableViewCellIdentifier";

@interface DBHInformationViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) DBHInformationTitleView *informationTitleView;
@property (nonatomic, strong) DBHMenuView *menuView;
@property (nonatomic, strong) DBHInformationHeaderView *informationHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHAddWalletPromptView *addWalletPromptView;
@property (nonatomic, strong) DBHSelectWalletTypeOnePromptView *selectWalletTypeOnePromptView;
@property (nonatomic, strong) DBHSelectWalletTypeTwoPromptView *selectWalletTypeTwoPromptView;

@property (nonatomic, assign) BOOL isShowFunctionalUnit;
@property (nonatomic, strong) NSArray *menuArray; // 菜单选项
@property (nonatomic, copy) NSArray *titleArray; // 功能组件标题
@property (nonatomic, strong) NSMutableArray *conversationCacheArray; // 功能组件会话列表
@property (nonatomic, strong) NSMutableArray *conversationArray; // 功能组件会话列表
@property (nonatomic, strong) NSMutableArray *contentArray; // 功能组件最新消息
@property (nonatomic, strong) NSMutableArray *timeArray; // 功能组件最新消息时间
@property (nonatomic, strong) NSMutableArray *noReadArray; // 未读消息数量
@property (nonatomic, copy) NSArray *titleGroupNameArray; // 功能组件对应环信的组名
@property (nonatomic, strong) NSMutableArray *functionalUnitArray; // 功能组件
@property (nonatomic, strong) NSMutableArray *dataSource; // 项目
@property (nonatomic, strong) NSMutableArray *icoArray; // ico

@end

@implementation DBHInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
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
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return !self.informationHeaderView.currentSelectedIndex ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *dataArray = self.dataSource[self.informationHeaderView.currentSelectedIndex];
    return !section && !self.informationHeaderView.currentSelectedIndex ? self.functionalUnitArray.count : dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationTableViewCellIdentifier forIndexPath:indexPath];
    if (!indexPath.section && !self.informationHeaderView.currentSelectedIndex) {
        cell.functionalUnitTitle = self.functionalUnitArray[indexPath.row];
        cell.content = self.contentArray[indexPath.row];
        cell.time = self.timeArray[indexPath.row];
        cell.noReadNumber = self.noReadArray[indexPath.row];
    } else {
        NSMutableArray *array1 = self.icoArray[self.informationHeaderView.currentSelectedIndex];
        NSMutableArray *array2 = self.dataSource[self.informationHeaderView.currentSelectedIndex];
        cell.noReadNumber = 0;
        if (indexPath.row < array1.count) {
            cell.icoModel = self.icoArray[self.informationHeaderView.currentSelectedIndex][indexPath.row];
        }
        if (indexPath.row < array2.count) {
            cell.model = self.dataSource[self.informationHeaderView.currentSelectedIndex][indexPath.row];
        }
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
                inWeHotViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
                inWeHotViewController.functionalUnitType = 0;
                inWeHotViewController.conversation = self.conversationArray[indexPath.row];
                [self.navigationController pushViewController:inWeHotViewController animated:YES];
                break;
            }
            case 1: {
                // TradingView
                DBHTradingViewViewController *tradingViewViewController = [[DBHTradingViewViewController alloc] init];
                tradingViewViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
                tradingViewViewController.functionalUnitType = 1;
                tradingViewViewController.conversation = self.conversationArray[indexPath.row];
                [self.navigationController pushViewController:tradingViewViewController animated:YES];
                break;
            }
            case 2: {
                // 交易所公告
                DBHExchangeNoticeViewController *exchangeNoticeViewController = [[DBHExchangeNoticeViewController alloc] init];
                exchangeNoticeViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
                exchangeNoticeViewController.functionalUnitType = 2;
                exchangeNoticeViewController.conversation = self.conversationArray[indexPath.row];
                [self.navigationController pushViewController:exchangeNoticeViewController animated:YES];
                break;
            }
                //            case 3: {
                //                // CandyBowl
                //                DBHCandyBowlViewController *candyBowlViewController = [[DBHCandyBowlViewController alloc] init];
                //                candyBowlViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
                //                candyBowlViewController.functionalUnitType = 3;
                //                candyBowlViewController.conversation = self.conversationArray[indexPath.row];
                //                [self.navigationController pushViewController:candyBowlViewController animated:YES];
                //                break;
                //            }
            case 3: {
                // 交易提醒
                DBHTraderClockViewController *traderClockViewController = [[DBHTraderClockViewController alloc] init];
                traderClockViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
                traderClockViewController.functionalUnitType = 3;
                traderClockViewController.conversation = self.conversationArray[indexPath.row];
                [self.navigationController pushViewController:traderClockViewController animated:YES];
                break;
            }
            case 4: {
                // 通知
                DBHNotificationViewController *notificationViewController = [[DBHNotificationViewController alloc] init];
                notificationViewController.title = DBHGetStringWithKeyFromTable(self.functionalUnitArray[indexPath.row], nil);
                notificationViewController.functionalUnitType = 4;
                notificationViewController.conversation = self.conversationArray[indexPath.row];
                [self.navigationController pushViewController:notificationViewController animated:YES];
                break;
            }
                
            default:
                break;
        }
    } else {
        [self readMessage:indexPath.row];
        
        DBHInformationModelData *projectModel = self.dataSource[self.informationHeaderView.currentSelectedIndex][indexPath.row];
        
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
    UITableViewRowAction *cancelColletAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:DBHGetStringWithKeyFromTable(!indexPath.section ? @"Delete" : @"Cancel Collection", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if (!indexPath.section) {
            // 删除功能组件
            [UserSignData share].user.functionalUnitArray[[self.titleArray indexOfObject:self.functionalUnitArray[indexPath.row]]] = @"1";
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

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat offsetY = scrollView.contentOffset.y;
    WEAKSELF
    if (self.isShowFunctionalUnit) {
        // 现在是显示
        if (offsetY > AUTOLAYOUTSIZE(45)) {
            self.tableView.contentInset = UIEdgeInsetsMake(-AUTOLAYOUTSIZE(125), 0, 0, 0);
            self.isShowFunctionalUnit = NO;
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:YES];
            });
        }
    } else {
        // 现在是隐藏
        if (offsetY < AUTOLAYOUTSIZE(80)) {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.isShowFunctionalUnit = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:YES];
            });
        }
    }
}

#pragma mark ------ EMChatManagerDelegate ------
/**
 收到消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *msg in aMessages) {
        switch (msg.chatType) {
            case EMChatTypeChat: {
                // 单聊
                if ([msg.conversationId isEqualToString:@"sys_msg_order"] || [msg.conversationId isEqualToString:@"sys_msg"]) {
                    [UserSignData share].user.functionalUnitArray[[msg.conversationId isEqualToString:@"sys_msg_order"] ? 3 : 4] = @"0";
                    [[UserSignData share] storageData:[UserSignData share].user];
                }
                break;
            }
            case EMChatTypeGroupChat: {
                // 群聊
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:msg.conversationId error:&error];
                if (!error) {
                    NSInteger index = [self.titleGroupNameArray indexOfObject:[group.subject substringToIndex:group.subject.length - 3]];
                    if (index < 0 || index > 4) {
                        return;
                    }
                    if ([[UserSignData share].user.functionalUnitArray[index] isEqualToString:@"1"]) {
                        [UserSignData share].user.functionalUnitArray[index] = @"0";
                        [[UserSignData share] storageData:[UserSignData share].user];
                        return;
                    }
                }
                break;
            }
            case EMChatTypeChatRoom: {
                // 聊天室
                return;
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
    [PPNetworkHelper GET:!self.informationHeaderView.currentSelectedIndex ? @"category?user_favorite&per_page=100" : [NSString stringWithFormat:@"category?type=%ld&per_page=100", self.informationHeaderView.currentSelectedIndex] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex] removeAllObjects];
        
        for (NSDictionary *dic in responseCache[@"data"]) {
            DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
            
            if (model.categoryUser.isTop) {
                [weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex] insertObject:model atIndex:0];
            } else {
                [weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex] addObject:model];
            }
        }
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex] removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
            
            if (model.categoryUser.isTop) {
                [weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex] insertObject:model atIndex:0];
            } else {
                [weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex] addObject:model];
            }
        }
        
        NSMutableArray *dataArray = weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex];
        if (dataArray.count && (!self.informationHeaderView.currentSelectedIndex || self.informationHeaderView.currentSelectedIndex == 1)) {
            [weakSelf getICOData];
        }
        
        [weakSelf.informationHeaderView stopAnimation];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [weakSelf.informationHeaderView stopAnimation];
        [LCProgressHUD showFailure:error];
    }];
}
- (void)getICOData {
    NSMutableArray *icoList = [NSMutableArray array];
    for (DBHInformationModelData *model in self.dataSource[self.informationHeaderView.currentSelectedIndex]) {
        [icoList addObject:model.unit];
    }
    NSDictionary *paramters = @{@"ico_list":icoList,
                                @"currency":@"cny"};
    
    WEAKSELF
    [PPNetworkHelper POST:@"ico/ranks" baseUrlType:3 parameters:paramters hudString:nil responseCache:^(id responseCache) {
        [weakSelf.icoArray[self.informationHeaderView.currentSelectedIndex] removeAllObjects];
        
        for (DBHInformationModelData *model in weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex]) {
            DBHInformationModelIco *icoModel = [DBHInformationModelIco modelObjectWithDictionary:responseCache[model.unit]];
            [weakSelf.icoArray[self.informationHeaderView.currentSelectedIndex] addObject:icoModel];
        }
        
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf.icoArray[self.informationHeaderView.currentSelectedIndex] removeAllObjects];
        
        for (DBHInformationModelData *model in weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex]) {
            DBHInformationModelIco *icoModel = [DBHInformationModelIco modelObjectWithDictionary:responseObject[model.unit]];
            [weakSelf.icoArray[self.informationHeaderView.currentSelectedIndex] addObject:icoModel];
        }
        
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}
/**
 取消收藏
 */
- (void)cancelColletWithRow:(NSInteger)row {
    DBHInformationModelData *projectModel = self.dataSource[self.informationHeaderView.currentSelectedIndex][row];
    NSDictionary *paramters = @{@"enable":[NSNumber numberWithBool:false]};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/collect", (NSInteger)projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        [weakSelf.dataSource[self.informationHeaderView.currentSelectedIndex] removeObjectAtIndex:row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
- (void)readMessage:(NSInteger)row {
    DBHInformationModelData *projectModel = self.dataSource[self.informationHeaderView.currentSelectedIndex][row];
    if (!projectModel.categoryUser.isFavoriteDot) {
        return;
    }
    NSDictionary *paramters = @{@"enable":[NSNumber numberWithBool:false]};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/undot", (NSInteger)projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Private Methods ------
/**
 获取功能组件
 */
- (void)getFunctionalUnit {
    self.conversationArray = [@[/*@"", */@"", @"", @"", @"", @""] mutableCopy];
    self.contentArray = [@[/*@"", */@"", @"", @"", @"", @""] mutableCopy];
    self.timeArray = [@[/*@"", */@"", @"", @"", @"", @""] mutableCopy];
    self.noReadArray = [@[/*@"0", */@"0", @"0", @"0", @"0", @"0"] mutableCopy];
    
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
                        self.conversationCacheArray[index] = conversation;
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
                    self.conversationArray[[conversation.conversationId isEqualToString:@"sys_msg_order"] ? 3 : 4] = conversation;
                    self.conversationCacheArray[[conversation.conversationId isEqualToString:@"sys_msg_order"] ? 3 : 4] = conversation;
                    
                    if ([conversation.conversationId isEqualToString:@"sys_msg_order"]) {
                        self.contentArray[3] = messageContent.text;
                    } else {
                        NSString *time = [NSString timeExchangeWithType:@"yyyy-MM-dd hh:mm" timestamp:conversation.latestMessage.timestamp];
                        
                        if (messageContent.text.length) {
                            self.contentArray[4] = [messageContent.text stringByReplacingOccurrencesOfString:@":date" withString:time];
                        }
                    }
                    self.timeArray[[conversation.conversationId isEqualToString:@"sys_msg_order"] ? 3 : 4] = [messageDate formattedTime];
                    self.noReadArray[[conversation.conversationId isEqualToString:@"sys_msg_order"] ? 3 : 4] = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
                }
            }
        }
    }
    
    [self.functionalUnitArray removeAllObjects];
    NSInteger count = 0;
    for (NSInteger i = 0; i < [UserSignData share].user.functionalUnitArray.count; i++) {
        NSString *tag = [UserSignData share].user.functionalUnitArray[i];
        if ([tag isEqualToString:@"0"]) {
            [self.functionalUnitArray addObject:self.titleArray[i]];
        } else {
            [self.conversationArray removeObjectAtIndex:i - count];
            [self.contentArray removeObjectAtIndex:i - count];
            [self.timeArray removeObjectAtIndex:i - count];
            [self.noReadArray removeObjectAtIndex:i - count];
            count += 1;
        }
    }
    
    [self getProjectList];
}

#pragma mark ------ Getters And Setters ------
- (DBHInformationTitleView *)informationTitleView {
    if (!_informationTitleView) {
        _informationTitleView = [[DBHInformationTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        
        WEAKSELF
        [_informationTitleView clickButtonBlock:^(NSInteger type) {
            if (!type) {
                // 搜索
                DBHSearchViewController *searchViewController = [[DBHSearchViewController alloc] init];
                [weakSelf.navigationController pushViewController:searchViewController animated:YES];
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
                    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
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
- (DBHInformationHeaderView *)informationHeaderView {
    if (!_informationHeaderView) {
        _informationHeaderView = [[DBHInformationHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(166.5))];
        
        WEAKSELF
        [_informationHeaderView selectTypeBlock:^{
            [weakSelf.tableView reloadData];
            [weakSelf getProjectList];
        }];
        [_informationHeaderView clickFunctionalUnitBlock:^(NSInteger functionalUnitType) {
            [UserSignData share].user.functionalUnitArray[functionalUnitType] = @"0";
            [[UserSignData share] storageData:[UserSignData share].user];
            // 点击功能组件
            switch (functionalUnitType) {
                case 0: {
                    // InWe热点
                    DBHInWeHotViewController *inWeHotViewController = [[DBHInWeHotViewController alloc] init];
                    inWeHotViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    inWeHotViewController.functionalUnitType = 0;
                    [weakSelf.navigationController pushViewController:inWeHotViewController animated:YES];
                    break;
                }
                case 1: {
                    // TradingView
                    DBHTradingViewViewController *tradingViewViewController = [[DBHTradingViewViewController alloc] init];
                    tradingViewViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    tradingViewViewController.functionalUnitType = 1;
                    [weakSelf.navigationController pushViewController:tradingViewViewController animated:YES];
                    break;
                }
                case 2: {
                    // 交易所公告
                    DBHExchangeNoticeViewController *exchangeNoticeViewController = [[DBHExchangeNoticeViewController alloc] init];
                    exchangeNoticeViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    exchangeNoticeViewController.functionalUnitType = 2;
                    [weakSelf.navigationController pushViewController:exchangeNoticeViewController animated:YES];
                    break;
                }
                    //                case 3: {
                    //                    // CandyBowl
                    //                    DBHCandyBowlViewController *candyBowlViewController = [[DBHCandyBowlViewController alloc] init];
                    //                    candyBowlViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    //                    candyBowlViewController.functionalUnitType = 3;
                    //                    [weakSelf.navigationController pushViewController:candyBowlViewController animated:YES];
                    //                    break;
                    //                }
                case 3: {
                    // 交易提醒
                    DBHTraderClockViewController *traderClockViewController = [[DBHTraderClockViewController alloc] init];
                    traderClockViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    traderClockViewController.functionalUnitType = 3;
                    traderClockViewController.conversation = self.conversationCacheArray[4];
                    [weakSelf.navigationController pushViewController:traderClockViewController animated:YES];
                    break;
                }
                case 4: {
                    // 通知
                    DBHNotificationViewController *notificationViewController = [[DBHNotificationViewController alloc] init];
                    notificationViewController.title = DBHGetStringWithKeyFromTable(self.titleArray[functionalUnitType], nil);
                    notificationViewController.functionalUnitType = 4;
                    notificationViewController.conversation = self.conversationCacheArray.lastObject;
                    [weakSelf.navigationController pushViewController:notificationViewController animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
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
        
        _tableView.contentInset = UIEdgeInsetsMake(-AUTOLAYOUTSIZE(125), 0, 0, 0);
        
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
                [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
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
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                }
            }
        }];
    }
    return _selectWalletTypeTwoPromptView;
}

- (NSArray *)menuArray {
    if (!_menuArray) {
        _menuArray = @[@"Scan QR Code",
                       @"Add Wallet",
                       @"Payment"];
    }
    return _menuArray;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"InWe Hotspot",
                        @"Trading View",
                        @"Exchange",
                        //                        @"Candybowl",
                        @"Trading Reminder",
                        @"Notice"];
    }
    return _titleArray;
}
- (NSMutableArray *)conversationArray {
    if (!_conversationArray) {
        _conversationArray = [NSMutableArray array];
        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
        //        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
        [_conversationArray addObject:@""];
    }
    return _conversationArray;
}
- (NSMutableArray *)conversationCacheArray {
    if (!_conversationCacheArray) {
        _conversationCacheArray = [NSMutableArray array];
        [_conversationCacheArray addObject:@""];
        [_conversationCacheArray addObject:@""];
        [_conversationCacheArray addObject:@""];
        //        [_conversationCacheArray addObject:@""];
        [_conversationCacheArray addObject:@""];
        [_conversationCacheArray addObject:@""];
    }
    return _conversationCacheArray;
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
        //        [_timeArray addObject:@""];
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
        //        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
        [_noReadArray addObject:@"0"];
    }
    return _noReadArray;
}
- (NSArray *)titleGroupNameArray {
    if (!_titleGroupNameArray) {
        _titleGroupNameArray = @[@"SYS_MSG_INWEHOT", @"SYS_MSG_TRADING", @"SYS_MSG_EXCHANGENOTICE"/*, @"SYS_MSG_CANDYBOW"*/, @"SYS_MSG_ORDER", @"SYS_MSG"];
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
        [_dataSource addObject:[NSMutableArray array]];
        [_dataSource addObject:[NSMutableArray array]];
        [_dataSource addObject:[NSMutableArray array]];
        [_dataSource addObject:[NSMutableArray array]];
        [_dataSource addObject:[NSMutableArray array]];
    }
    return _dataSource;
}
- (NSMutableArray *)icoArray {
    if (!_icoArray) {
        _icoArray = [NSMutableArray array];
        [_icoArray addObject:[NSMutableArray array]];
        [_icoArray addObject:[NSMutableArray array]];
        [_icoArray addObject:[NSMutableArray array]];
        [_icoArray addObject:[NSMutableArray array]];
        [_icoArray addObject:[NSMutableArray array]];
    }
    return _icoArray;
}

@end
