//
//  FindVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/1.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "FindVC.h"
#import "SDCycleScrollView.h"
#import "FindCoCell.h"
#import "FindTaCell.h"
#import "ICOTransactionVC.h"
#import "FindBannerModel.h"
#import "FindIcoModel.h"
#import "FindArticleModel.h"
#import "KKWebView.h"
#import "Masonry.h"

@interface FindVC () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

/** 页数 */
@property (nonatomic, assign) int page;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UILabel * headerViewLabel;
@property (nonatomic, strong) SDCycleScrollView * scrollImageView;
@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * bannerDataSource;
@property (nonatomic, strong) NSMutableArray * icoDataSource;
@end

@implementation FindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroudColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.coustromTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 46);
    self.coustromTableView.rowHeight = 100;
    self.coustromTableView.tableHeaderView = self.headerView;
    
    [self addpull2RefreshWithTableView:self.coustromTableView WithIsInset:NO];
    [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.bannerDataSource = [[NSMutableArray alloc] init];
    self.icoDataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.coustromTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.page = 1;
    [self loadHeaderData];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)loadHeaderData
{
    //获取banner 分类
    [PPNetworkHelper GET:@"find" parameters:nil hudString:nil responseCache:^(id responseCache)
    {
        if ([[responseCache objectForKey:@"banner"] count] > 0)
        {
            [self.bannerDataSource removeAllObjects];
            NSMutableArray * imgArray = [[NSMutableArray alloc] init];
            NSMutableArray * titleArray = [[NSMutableArray alloc] init];
            //banner 数据
            for (NSDictionary * bannerDic in [responseCache objectForKey:@"banner"])
            {
                FindBannerModel * bannerModel = [[FindBannerModel alloc] initWithDictionary:[bannerDic objectForKey:@"detail"]];
                bannerModel.id = [[bannerDic objectForKey:@"id"] intValue];
                [self.bannerDataSource addObject:bannerModel];
                [imgArray addObject:bannerModel.img];
                [titleArray addObject:bannerModel.title];
            }
            //设置轮播图
            self.scrollImageView.imageURLStringsGroup = imgArray;
            self.scrollImageView.titlesGroup = titleArray;
        }
        
        if ([[responseCache objectForKey:@"ico"] count] > 0)
        {
            [self.icoDataSource removeAllObjects];
            //ico 数据
            for (NSDictionary * icoDic in [responseCache objectForKey:@"ico"])
            {
                FindIcoModel * icoModel = [[FindIcoModel alloc] initWithDictionary:icoDic];
                [self.icoDataSource addObject:icoModel];
            }
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 344 / 375);
            self.collectionView.frame = CGRectMake(0, SCREEN_WIDTH * 196 / 375 + 8, SCREEN_WIDTH, SCREEN_WIDTH * 100 / 375);
            [self.collectionView reloadData];
        }
        else
        {
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 244 / 375);
            self.collectionView.frame = CGRectMake(0, SCREEN_WIDTH * 196 / 375 + 8, SCREEN_WIDTH, 0);
        }
        
    } success:^(id responseObject)
    {
        if ([[responseObject objectForKey:@"banner"] count] > 0 && self.bannerDataSource.count == 0)
        {
            [self.bannerDataSource removeAllObjects];
            NSMutableArray * imgArray = [[NSMutableArray alloc] init];
            //banner 数据
            for (NSDictionary * bannerDic in [responseObject objectForKey:@"banner"])
            {
                FindBannerModel * bannerModel = [[FindBannerModel alloc] initWithDictionary:[bannerDic objectForKey:@"detail"]];
                bannerModel.id = [[bannerDic objectForKey:@"id"] intValue];
                [self.bannerDataSource addObject:bannerModel];
                [imgArray addObject:bannerModel.img];
            }
            //设置轮播图
            self.scrollImageView.imageURLStringsGroup = imgArray;
        }
        
        if ([[responseObject objectForKey:@"ico"] count] > 0 && self.icoDataSource.count == 0)
        {
            [self.icoDataSource removeAllObjects];
            //ico 数据
            for (NSDictionary * icoDic in [responseObject objectForKey:@"ico"])
            {
                FindIcoModel * icoModel = [[FindIcoModel alloc] initWithDictionary:icoDic];
                [self.icoDataSource addObject:icoModel];
            }
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 344 / 375);
            self.collectionView.frame = CGRectMake(0, SCREEN_WIDTH * 196 / 375 + 8, SCREEN_WIDTH, SCREEN_WIDTH * 100 / 375);
            [self.collectionView reloadData];
        }
        else
        {
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 244 / 375);
            self.collectionView.frame = CGRectMake(0, SCREEN_WIDTH * 196 / 375 + 8, SCREEN_WIDTH, 0);
        }
        
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.page) forKey:@"page"];
    [parametersDic setObject:@(5) forKey:@"per_page"];
    
    [PPNetworkHelper GET:@"article" parameters:parametersDic hudString:nil success:^(id responseObject)
    {
        if (self.page == 1)
        {
            [self.dataSource removeAllObjects];
        }
        if ([[responseObject objectForKey:@"list"] count] > 0)
        {
            for (NSDictionary * articleDic in [responseObject objectForKey:@"list"])
            {
                FindArticleModel * model = [[FindArticleModel alloc] initWithDictionary:[articleDic objectForKey:@"detail"]];
                model.id = [[articleDic objectForKey:@"id"] intValue];
                model.created_at = [articleDic objectForKey:@"created_at"];
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
        [self.coustromTableView reloadData];
        [self endRefreshing];
    } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
         self.page = 1;
     }];
    
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    FindBannerModel * model = self.bannerDataSource[index];
    KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@article/%d",APP_APIEHEAD,model.id]];
    webView.title = model.title;
    [self.navigationController pushViewController:webView animated:YES];
}

//下拉刷新回调
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    self.page = 1;
    [self loadData];
    [self loadHeaderData];
}

//上提加载回调
- (void)push2LoadMoreWithScrollerView:(UIScrollView *)scrollerView
{
    self.page ++;
    [self loadData];
}

#pragma mark -- 协议实现

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.icoDataSource.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FindCoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FindCoCellident" forIndexPath:indexPath];
    
    cell.model = self.icoDataSource[indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-( void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //ico 列表
//    FindIcoModel * model = self.icoDataSource[indexPath.row];
    ICOTransactionVC * vc = [[ICOTransactionVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES ;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    return CGSizeMake (SCREEN_WIDTH / 4, SCREEN_WIDTH * 100 / 375);
}

//定义每个UICollectionViewCell 的边距
-(UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger )section
{
    
    return UIEdgeInsetsMake (0, 0, 0, 0);
}


//此外，你还可以调整内容视图的垂直对齐（即：有用的时候，有tableheaderview可见）：
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 60.0;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindTaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTaCellident"];
    cell = nil;
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"FindTaCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindArticleModel * model = self.dataSource[indexPath.row];
    KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@article/%d",APP_APIEHEAD,model.id]];
//    webView.articleId = [NSString stringWithFormat:@"%d",model.id];
    webView.title = model.title;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark -- get

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 344 / 375)];
        _headerView.backgroundColor = [UIColor backgroudColor];
        
        [_headerView addSubview:self.scrollImageView];
        [_headerView addSubview:self.collectionView];
        [_headerView addSubview:self.headerViewLabel];
        
        [self.headerViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView).offset(20);
            make.bottom.equalTo(self.headerView).offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 50));
        }];
    }
    return _headerView;
}

- (UILabel *)headerViewLabel
{
    if (!_headerViewLabel)
    {
        _headerViewLabel = [[UILabel alloc] init];
        _headerViewLabel.text = @"资讯文章";
        _headerViewLabel.textAlignment = NSTextAlignmentLeft;
        _headerViewLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _headerViewLabel.font = [UIFont systemFontOfSize:14];
    }
    return _headerViewLabel;
}

- (SDCycleScrollView *)scrollImageView
{
    if (!_scrollImageView)
    {
        _scrollImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 196 / 375) delegate:self placeholderImage:[UIImage imageNamed:@"默认图片"]];
        _scrollImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter; // 设置pageControl居右，默认居中
        _scrollImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _scrollImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _scrollImageView.autoScrollTimeInterval = 3;// 自定义轮播时间间隔
    }
    return _scrollImageView;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH * 196 / 375 + 8, SCREEN_WIDTH, SCREEN_WIDTH * 100 / 375) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"FindCoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FindCoCellident"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
    }
    return _collectionView;
}

@end
