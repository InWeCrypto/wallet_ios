//
//  EditRemindVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/10.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "EditRemindVC.h"
#import "RemindCell.h"
#import "RemindModel.h"

@interface EditRemindVC () <UITableViewDelegate, UITableViewDataSource, RemindCellDelegate>

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation EditRemindVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"提醒编辑";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.model.isEdit = YES;
    [self.dataSource addObject:self.model];
    [self.view addSubview:self.coustromTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)priceChangeUpper_limit:(NSString *)upper_limit lower_limit:(NSString *)lower_limit cell:(UITableViewCell *)cell
{
    self.model.relation_notification.upper_limit = upper_limit;
    self.model.relation_notification.lower_limit = lower_limit;
}

- (void)rightButton
{
    //编辑行情
    if (![NSString isMoneyNumber:self.model.relation_notification.upper_limit] || ![NSString isMoneyNumber:self.model.relation_notification.lower_limit])
    {
        [LCProgressHUD showMessage:@"请输入正确的金额"];
        return;
    }
    
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:self.model.relation_notification.upper_limit forKey:@"upper_limit"];
    [parametersDic setObject:self.model.relation_notification.lower_limit forKey:@"lower_limit"];
    
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"market-notification/%d",self.model.relation_notification.id] parameters:parametersDic hudString:@"修改中..." success:^(id responseObject)
     {
         [self.navigationController popViewControllerAnimated:YES];
         
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
    cell.delegate = self;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
