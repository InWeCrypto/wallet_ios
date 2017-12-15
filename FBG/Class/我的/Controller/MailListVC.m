//
//  MailListVC.m
//  FBG
//
//  Created by mac on 2017/7/22.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "MailListVC.h"
#import "MailListCell.h"
#import "AddMailVC.h"
#import "EditMailVC.h"
#import "MailMdel.h"

#import "YCXMenu.h"

@interface MailListVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL _isType; //默认 NO ==> ETH  YES ==> BTC
}

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSMutableArray * ETHDataSource;
@property (nonatomic, strong) NSMutableArray * BTCDataSource;
@property (nonatomic, strong) NSMutableArray * NEODataSource;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeChangeSM;

@property (nonatomic, strong) NSMutableArray * items;

@end

@implementation MailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    self.coustromTableView.emptyDataSetSource = self;
    self.coustromTableView.emptyDataSetDelegate = self;
    
//    self.typeChangeSM.layer.borderWidth = 1;
//    self.typeChangeSM.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_add-friends"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.coustromTableView];
    self.ETHDataSource = [[NSMutableArray alloc] init];
    self.BTCDataSource = [[NSMutableArray alloc] init];
    self.NEODataSource = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    switch (self.typeChangeSM.selectedSegmentIndex) {
        case 0:
            [self loadDataWithIcoId:@"6"];
            break;
        case 1:
            
            break;
            
        default:
            [self loadDataWithIcoId:@"7"];
            break;
    }
}

- (void)loadDataWithIcoId:(NSString *)icoId
{
    [PPNetworkHelper GET:[NSString stringWithFormat:@"user/contact?ico_id=%@", icoId] isOtherBaseUrl:YES parameters:nil hudString:@"获取中..." responseCache:^(id responseCache)
     {
         switch (self.typeChangeSM.selectedSegmentIndex) {
             case 0:
                 [self.ETHDataSource removeAllObjects];
                 break;
             case 1:
                 [self.BTCDataSource removeAllObjects];
                 break;
                 
             default:
                 [self.NEODataSource removeAllObjects];
                 break;
         }
         NSArray *dataArray = responseCache;
         if ([dataArray count] > 0)
         {
             int i = 1;
             for (NSDictionary * dic in dataArray)
             {
                 MailMdel * model = [[MailMdel alloc] initWithDictionary:dic];
                 model.img = [NSString stringWithFormat:@"通讯录头像%d",i];
                 switch (self.typeChangeSM.selectedSegmentIndex) {
                     case 0:
                         [self.ETHDataSource addObject:model];
                         break;
                     case 1:
                         [self.BTCDataSource addObject:model];
                         break;
                         
                     default:
                         [self.NEODataSource addObject:model];
                         break;
                 }
                 
                 i ++;
                 if (i == 10)
                 {
                     i = 1;
                 }
             }
             [self.coustromTableView reloadData];
             
         }
         
     } success:^(id responseObject)
     {
         switch (self.typeChangeSM.selectedSegmentIndex) {
             case 0:
                 [self.ETHDataSource removeAllObjects];
                 break;
             case 1:
                 [self.BTCDataSource removeAllObjects];
                 break;
                 
             default:
                 [self.NEODataSource removeAllObjects];
                 break;
         }
         NSArray *dataArray = responseObject;
         if ([dataArray count] > 0)
         {
             int i = 1;
             for (NSDictionary * dic in dataArray)
             {
                 MailMdel * model = [[MailMdel alloc] initWithDictionary:dic];
                 model.img = [NSString stringWithFormat:@"通讯录头像%d",i];
                 switch (self.typeChangeSM.selectedSegmentIndex) {
                     case 0:
                         [self.ETHDataSource addObject:model];
                         break;
                     case 1:
                         [self.BTCDataSource addObject:model];
                         break;
                         
                     default:
                         [self.NEODataSource addObject:model];
                         break;
                 }
                 
                 i ++;
                 if (i == 10)
                 {
                     i = 1;
                 }
             }
             [self.coustromTableView reloadData];
         }
         
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
}

- (void)rightButton
{
    //添加
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"DAD7D7"]];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    [YCXMenu setTitleFont:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(14)]];
    [YCXMenu setSelectedColor:[UIColor colorWithHexString:@"666666"]];
    [YCXMenu setselectedIndex:-1];
    if ([YCXMenu isShow])
    {
        [YCXMenu dismissMenu];
    }
    else
    {
        WEAKSELF
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item)
         {
             if (index == 1) {
                 [LCProgressHUD showMessage:@"敬请期待"];
                 
                 return ;
             }
             
             AddMailVC * vc = [[AddMailVC alloc] init];
             vc.icoId = !index ? @"6" : @"7";
             [weakSelf.navigationController pushViewController:vc animated:YES];
         }];
    }
}

- (IBAction)TypeChange:(id)sender
{
    //改变类型
    if (self.typeChangeSM.selectedSegmentIndex == 1) {
        [LCProgressHUD showMessage:@"敬请期待"];
        [self.coustromTableView reloadData];
        return;
    }
    
    // ETH:6 NEO:7
    [self loadDataWithIcoId:!self.typeChangeSM.selectedSegmentIndex ? @"6" : @"7"];
}

#pragma mark - DZNEmptyDataSetSource Methods

//图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return Default_NoData_Image;
}

//属性字符串
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
}

//背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

//此外，你还可以调整内容视图的垂直对齐（即：有用的时候，有tableheaderview可见）：
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -40.0;
}

//最后，您可以将组件彼此分离（默认分离为11个点）：
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.typeChangeSM.selectedSegmentIndex) {
        case 0:
            return self.ETHDataSource.count;
            break;
        case 1:
            return self.BTCDataSource.count;
            break;
            
        default:
            return self.NEODataSource.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailListCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MailListCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MailMdel * model;
    switch (self.typeChangeSM.selectedSegmentIndex) {
        case 0:
            model = self.ETHDataSource[indexPath.row];
            break;
        case 1:
            model = self.BTCDataSource[indexPath.row];
            break;
            
        default:
            model = self.NEODataSource[indexPath.row];
            break;
    }
    cell.model = model;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailMdel * model;
    switch (self.typeChangeSM.selectedSegmentIndex) {
        case 0:
            model = self.ETHDataSource[indexPath.row];
            break;
        case 1:
            model = self.BTCDataSource[indexPath.row];
            break;
            
        default:
            model = self.NEODataSource[indexPath.row];
            break;
    }
    if (self.isChose)
    {
        //选择回调
        if ([self.delegate respondsToSelector:@selector(choasePersonWithData:)])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate choasePersonWithData:model];
        }
    }
    else
    {
        //通讯录查看
        EditMailVC * vc = [[EditMailVC alloc] init];
        vc.icoId = !self.typeChangeSM.selectedSegmentIndex ? @"6" : @"7";
        vc.id = [NSString stringWithFormat:@"%d",model.id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- get

- (UITableView *)coustromTableView
{
    if (!_coustromTableView)
    {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 64) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
        _coustromTableView.rowHeight = 100;
    }
    return _coustromTableView;
}

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [NSMutableArray array];
        
        YCXMenuItem *firstMenuItem = [YCXMenuItem menuItem:@"ETH"
                                                     image:nil
                                                       tag:100
                                                  userInfo:@{@"title":@"Menu"}];
        YCXMenuItem *secondMenuItem = [YCXMenuItem menuItem:@"BTC"
                                                      image:nil
                                                        tag:101
                                                   userInfo:@{@"title":@"Menu"}];
        YCXMenuItem *thirdMenuItem = [YCXMenuItem menuItem:@"NEO"
                                                      image:nil
                                                        tag:102
                                                   userInfo:@{@"title":@"Menu"}];
        [firstMenuItem setForeColor:[UIColor colorWithHexString:@"333333"]];
        [secondMenuItem setForeColor:[UIColor colorWithHexString:@"333333"]];
        [thirdMenuItem setForeColor:[UIColor colorWithHexString:@"333333"]];
        
        [_items addObject:firstMenuItem];
        [_items addObject:secondMenuItem];
        [_items addObject:thirdMenuItem];
    }
    return _items;
}

@end
