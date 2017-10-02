//
//  MessageVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/8.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
#import "MessageModel.h"

@interface MessageVC () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isRead; //是否已读
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeChangeSM;
/** 页数 */
@property (nonatomic, assign) int page;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"信息";
//    [self.typeChangeSM setTitle:NSLocalizedString(@"Transfer Accounts", nil) forSegmentAtIndex:0];
//    [self.typeChangeSM setTitle:NSLocalizedString(@"Receivables", nil) forSegmentAtIndex:1];
    
    self.coustromTableView.frame = CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 64);
    self.coustromTableView.estimatedRowHeight = 100;
//    self.coustromTableView.rowHeight = 100;
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.typeChangeSM.layer.borderWidth = 1;
    self.typeChangeSM.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
}
- (IBAction)TypeChange:(id)sender
{
    _isRead = !_isRead;
    _page = 1;
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.page = 1;
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:_isRead ? @(1) : @(0) forKey:@"type"];
    [parametersDic setObject:@(self.page) forKey:@"page"];
    [parametersDic setObject:@(10) forKey:@"per_page"];
    
    [PPNetworkHelper GET:@"message" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
    {
        if (self.page == 1)
        {
            [self.dataSource removeAllObjects];
        }
        if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
        {
            for (NSDictionary * icoDic in [responseObject objectForKey:@"list"])
            {
                MessageModel * model = [[MessageModel alloc] initWithDictionary:icoDic];
                [self.dataSource addObject:model];
            }
        }
        else
        {
            if (self.page != 1)
            {
                self.page --;
                [LCProgressHUD showMessage:@"没有更多了"];
            }
        }
        [self endRefreshing];
        [self.coustromTableView reloadData];
    } failure:^(NSString *error)
    {
        [self endRefreshing];
        [LCProgressHUD showFailure:error];
        self.page = 1;
    }];
    
}

//下拉刷新回调
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    self.page = 1;
    [self loadData];
}

//上提加载回调
- (void)push2LoadMoreWithScrollerView:(UIScrollView *)scrollerView
{
    self.page ++;
    [self loadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellident"];
    cell = nil;
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MessageCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_isRead)
    {
        //已读
    }
    else
    {
        //未读
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //标记已读
    MessageModel * model = self.dataSource[indexPath.row];
    
    if (!_isRead)
    {        
        [PPNetworkHelper PUT:[NSString stringWithFormat:@"message/%d",model.id] parameters:nil hudString:@"标记已读..." success:^(id responseObject)
         {
             [LCProgressHUD showInfoMsg:@"消息已读"];
             //1.更新数据
             [self.dataSource removeObjectAtIndex:indexPath.row];
             //2.更新UI
             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
             
         } failure:^(NSString *error)
         {
             [LCProgressHUD showFailure:error];
         }];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel * model = self.dataSource[indexPath.row];
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
      [PPNetworkHelper DELETE:[NSString stringWithFormat:@"message/%d",model.id] parameters:nil hudString:@"删除中..." success:^(id responseObject)
       {
           //1.更新数据
           [self.dataSource removeObjectAtIndex:indexPath.row];
           //2.更新UI
           [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
           
       } failure:^(NSString *error)
       {
           [LCProgressHUD showFailure:error];
       }];
      
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"fdd930"];
    
    //将设置好的按钮方到数组中返回
    return @[deleteAction];
}

#pragma mark -- get


@end
