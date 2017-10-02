//
//  AddRemindVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/10.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AddRemindVC.h"
#import "RemindCell.h"
#import "RemindModel.h"

@interface AddRemindVC () <UITableViewDelegate, UITableViewDataSource, RemindCellDelegate>

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * seleteDataSource;

@end

@implementation AddRemindVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"提醒添加";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.seleteDataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)rightButton
{
    //添加行情提醒
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[self.seleteDataSource toJSONStringForArray] forKey:@"market_arr"];
    if ([UserSignData share].user.walletUnitType == 1)
    {
        //人民币
        [parametersDic setObject:@"cny" forKey:@"currency"];
    }
    else
    {
        //美元
        [parametersDic setObject:@"usd" forKey:@"currency"];
    }
    
    [PPNetworkHelper POST:@"market-notification" parameters:parametersDic hudString:@"添加中..." success:^(id responseObject)
     {
         [self.navigationController popViewControllerAnimated:YES];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

- (void)loadData
{
    [PPNetworkHelper GET:@"market-notification" parameters:nil hudString:@"获取中..." success:^(id responseObject)
     {
         if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]])
         {
             [self.dataSource removeAllObjects];
             [self.seleteDataSource removeAllObjects];
             for (NSDictionary * dic in [responseObject objectForKey:@"list"])
             {
                 RemindModel * model = [[RemindModel alloc] initWithDictionary:dic];
                 model.isDelate = YES;
                 model.isEdit = YES;
                 if (model.relation_notification_count == 1 )
                 {
                     //已添加的行情提醒
                     for (NSDictionary * notDic in [dic objectForKey:@"relation_notification"])
                     {
                         model.relation_notification = [[RemindRelationNotificationModel alloc] initWithDictionary:notDic];
                         
                         NSMutableDictionary * jsonDic = [[NSMutableDictionary alloc] init];
                         [jsonDic setObject:@(model.id) forKey:@"market_id"];
                         [jsonDic setObject:model.relation_notification.upper_limit forKey:@"upper_limit"];
                         [jsonDic setObject:model.relation_notification.lower_limit forKey:@"lower_limit"];
                         
                         [self.seleteDataSource addObject:jsonDic];
                     }
                     
                 }
                 [self.dataSource addObject:model];
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
    cell.delegate = self;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindModel * model = self.dataSource[indexPath.row];
    
    if (![NSString isMoneyNumber:model.relation_notification.upper_limit] || ![NSString isMoneyNumber:model.relation_notification.lower_limit])
    {
        [LCProgressHUD showMessage:@"请输入正确的金额"];
        return;
    }
    
    RemindCell *cell = [self.coustromTableView cellForRowAtIndexPath:indexPath];
    if (model.relation_notification_count == 0 && ![NSString isNulllWithObject:model.relation_notification.upper_limit] && ![NSString isNulllWithObject:model.relation_notification.lower_limit])
    {
        //添加
        NSMutableDictionary * jsonDic = [[NSMutableDictionary alloc] init];
        [jsonDic setObject:@(model.id) forKey:@"market_id"];
        [jsonDic setObject:model.relation_notification.upper_limit forKey:@"upper_limit"];
        [jsonDic setObject:model.relation_notification.lower_limit forKey:@"lower_limit"];
        model.relation_notification_count = 1;
        
        [self.seleteDataSource addObject:jsonDic];
        cell.seletedImage.image = [UIImage imageNamed:@"list_btn_selected"];
    }
    else
    {
//        [LCProgressHUD showMessage:@"该提醒已添加"];
    }
}

- (void)priceChangeUpper_limit:(NSString *)upper_limit lower_limit:(NSString *)lower_limit cell:(UITableViewCell *)cell
{
    NSIndexPath * indx = [self.coustromTableView indexPathForCell:cell];
    RemindModel * model = self.dataSource[indx.row];
    model.relation_notification = [[RemindRelationNotificationModel alloc] init];
    model.relation_notification.upper_limit = upper_limit;
    model.relation_notification.lower_limit = lower_limit;
    [self.dataSource removeObjectAtIndex:indx.row];
    [self.dataSource insertObject:model atIndex:indx.row];
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
