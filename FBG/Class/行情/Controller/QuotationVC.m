//
//  QuotationVC.m
//  FBG
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "QuotationVC.h"
#import "QuotationCell.h"
#import "AddQuotesVC.h"
#import "EditQuotesVC.h"
#import "RemindVC.h"
#import "QuotationInfoVC.h"
#import "QuotationModel.h"

@interface QuotationVC ()
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;
/** 计时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation QuotationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroudColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_add"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.coustromTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 46);
    self.coustromTableView.rowHeight = 100;
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
    [self timerDown];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    //别忘了删除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)rightButton
{
    //添加
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *addQuotesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //添加行情
        AddQuotesVC * vc = [[AddQuotesVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIAlertAction *editQuotesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Edit", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //编辑行情
        EditQuotesVC * vc = [[EditQuotesVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIAlertAction *remindAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remind", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //提醒
        RemindVC * vc = [[RemindVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *canelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:addQuotesAction];
    [alertController addAction:editQuotesAction];
    [alertController addAction:remindAction];
    [alertController addAction:canelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadData
{
    [PPNetworkHelper GET:@"market-category" parameters:nil hudString:nil responseCache:^(id responseCache)
    {
        //获取数据
        if (![NSString isNulllWithObject:[responseCache objectForKey:@"list"]])
        {
            [self.dataSource removeAllObjects];
            for (NSDictionary * quotesDic in [responseCache objectForKey:@"list"])
            {
                for (NSDictionary * dic in [quotesDic objectForKey:@"data"])
                {
                    QuotationModel * quotesModel = [[QuotationModel alloc] initWithDictionary:dic];
                    quotesModel.relationCap = [[RelationCapModel alloc] initWithDictionary:[dic objectForKey:@"relationCap"]];
                    quotesModel.relationCapMin = [[RelationCapMinModel alloc] initWithDictionary:[dic objectForKey:@"relationCapMin"]];
                    [self.dataSource addObject:quotesModel];
                }
            }
            [self.coustromTableView reloadData];
        }

    } success:^(id responseObject)
    {
        //获取数据
        if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]] && self.dataSource.count == 0)
        {
            [self.dataSource removeAllObjects];
            for (NSDictionary * quotesDic in [responseObject objectForKey:@"list"])
            {
                for (NSDictionary * dic in [quotesDic objectForKey:@"data"])
                {
                    QuotationModel * quotesModel = [[QuotationModel alloc] initWithDictionary:dic];
                    quotesModel.relationCap = [[RelationCapModel alloc] initWithDictionary:[dic objectForKey:@"relationCap"]];
                    quotesModel.relationCapMin = [[RelationCapMinModel alloc] initWithDictionary:[dic objectForKey:@"relationCapMin"]];
                    [self.dataSource addObject:quotesModel];
                }
            }
            [self.coustromTableView reloadData];
        }
        [self endRefreshing];
    } failure:^(NSString *error)
    {
        [self endRefreshing];
        [LCProgressHUD showFailure:error];
    }];
}

- (void)timerDown
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil]; //监听是否触发home键挂起程序.
    //开始计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    self.timer.fireDate = [NSDate distantPast];
}

- (void)countDownTime
{
    //10s 请求一次接口
    [self loadData];
}

- (void)appHasGoneInForeground:(NSNotification *)notification
{
    //从后台唤醒
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    //切换到后台
    [self.timer setFireDate:[NSDate distantFuture]];
}

//下拉刷新回调
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    [self loadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuotationCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"QuotationCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuotationModel * quotesModel = self.dataSource[indexPath.row];
    QuotationInfoVC * vc = [[QuotationInfoVC alloc] init];
    vc.quotationModel = quotesModel;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
