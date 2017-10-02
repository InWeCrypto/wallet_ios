//
//  RemindVC.m
//  FBG
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "RemindVC.h"
#import "RemindCell.h"
#import "RemindModel.h"
#import "AddRemindVC.h"
#import "EditRemindVC.h"

@interface RemindVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation RemindVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"提醒";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_add"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)rightButton
{
    //添加行情
    AddRemindVC * vc = [[AddRemindVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    [PPNetworkHelper GET:@"market-notification" parameters:nil hudString:@"获取中..." success:^(id responseObject)
     {
         if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
         {
             [self.dataSource removeAllObjects];
             for (NSDictionary * dic in [responseObject objectForKey:@"list"])
             {
                 RemindModel * model = [[RemindModel alloc] initWithDictionary:dic];
                 model.relationCap = [[RelationCapModel alloc] initWithDictionary:[dic objectForKey:@"relationCap"]];
                 model.relationCapMin = [[RelationCapMinModel alloc] initWithDictionary:[dic objectForKey:@"relationCapMin"]];
                 if (model.relation_notification_count == 1)
                 {
                     //已添加的提醒
                     for (NSDictionary * notDic in [dic objectForKey:@"relation_notification"])
                     {
                         model.relation_notification = [[RemindRelationNotificationModel alloc] initWithDictionary:notDic];
                         [self.dataSource addObject:model];
                     }
                     
                 }
             }
             [self.coustromTableView reloadData];
         }
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"RemindCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindModel * model = self.dataSource[indexPath.row];
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        [PPNetworkHelper DELETE:[NSString stringWithFormat:@"market-notification/%d",model.relation_notification.id] parameters:nil hudString:@"删除中..." success:^(id responseObject)
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
    
    //添加一个编辑按钮
    UITableViewRowAction *editRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:NSLocalizedString(@"Edit", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
     {
         EditRemindVC * vc = [[EditRemindVC alloc] init];
         vc.model = model;
         [self.navigationController pushViewController:vc animated:YES];
         
     }];
    editRowAction.backgroundColor = [UIColor colorWithHexString:@"BABABB"];
    //将设置好的按钮方到数组中返回
    return @[editRowAction,deleteAction];
}

#pragma mark -- get

- (UITableView *)coustromTableView
{
    if (!_coustromTableView)
    {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 64) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
        _coustromTableView.rowHeight = 100;
    }
    return _coustromTableView;
}


@end
