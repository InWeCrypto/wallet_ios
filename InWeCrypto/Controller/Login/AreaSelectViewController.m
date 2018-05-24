//
//  AreaSelectViewController.m
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/24.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import "AreaSelectViewController.h"
#import "pinyin.h"
#import "AIMTableViewIndexBar.h"

@interface AreaSelectViewController ()<UITableViewDelegate,UITableViewDataSource,AIMTableViewIndexBarDelegate>

@property(strong, nonatomic)UITableView                         *myTableView;
@property(nonatomic,strong)UILabel                              *showAlertUI;
@property(nonatomic,strong)AIMTableViewIndexBar                 *indexBar;
@property(nonatomic,assign)float                                timeCount;
@property(nonatomic,strong)NSMutableArray                       *allLetterArray;
@property(strong,nonatomic)NSMutableArray                       *LeftAllCity;
@property(nonatomic,strong)NSMutableArray                       *headTitleArr;

@end

@implementation AreaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
}

-(void)initClass{
   
    _LeftAllCity = [[NSMutableArray alloc] init];
    _headTitleArr = [[NSMutableArray alloc] init];
    _allLetterArray = [[NSMutableArray alloc] init];
    [_allLetterArray addObject:@"a"];[_allLetterArray addObject:@"b"];
    [_allLetterArray addObject:@"c"];[_allLetterArray addObject:@"d"];
    [_allLetterArray addObject:@"e"];[_allLetterArray addObject:@"f"];
    [_allLetterArray addObject:@"g"];[_allLetterArray addObject:@"h"];
    [_allLetterArray addObject:@"i"];[_allLetterArray addObject:@"j"];
    [_allLetterArray addObject:@"k"];[_allLetterArray addObject:@"l"];
    [_allLetterArray addObject:@"m"];[_allLetterArray addObject:@"n"];
    [_allLetterArray addObject:@"o"];[_allLetterArray addObject:@"p"];
    [_allLetterArray addObject:@"q"];[_allLetterArray addObject:@"r"];
    [_allLetterArray addObject:@"s"];[_allLetterArray addObject:@"t"];
    [_allLetterArray addObject:@"u"];[_allLetterArray addObject:@"v"];
    [_allLetterArray addObject:@"w"];[_allLetterArray addObject:@"x"];
    [_allLetterArray addObject:@"y"];[_allLetterArray addObject:@"z"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    
    _indexBar = [AIMTableViewIndexBar new];
    
    [_indexBar setFrame:CGRectMake(SCREEN_WIDTH-20, 64 + 50, 20, SCREEN_HEIGHT - 64 - 50)];
    _indexBar.delegate = self;
    [self.view addSubview:_indexBar];
    
    [self makeShowAlertUI];
    
}

-(void)makeShowAlertUI{
    if (!_showAlertUI) {
        _showAlertUI=[UILabel new];
        [_showAlertUI setFrame:CGRectMake(0, 0, 50, 50)];
        [_showAlertUI setCenter:self.view.center];
        [_showAlertUI setBackgroundColor:[UIColor yellowColor]];
        [_showAlertUI setText:@"A"];
        [_showAlertUI setTextAlignment:NSTextAlignmentCenter];
        [_showAlertUI setFont:[UIFont systemFontOfSize:32]];
        [_showAlertUI setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_showAlertUI setHidden:YES];
        [self.view addSubview:_showAlertUI];
    }
}

-(void)showAlertText:(NSString*)context{
    //  后台执行：
    int s = 3;//几秒隐藏
    [_showAlertUI setText:context];
    
    if (_showAlertUI.isHidden) {
        [_showAlertUI setHidden:NO];
        [_showAlertUI setAlpha:1];
        _timeCount = 0;
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            while (weakSelf.timeCount <= s) {
                weakSelf.timeCount += 1;
                
                if (weakSelf.timeCount == s) {
                    // 主线程执行：
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5f animations:^{
                            [weakSelf.showAlertUI setAlpha:0];
                        } completion:^(BOOL finished) {
                            [weakSelf.showAlertUI setHidden:YES];
                            
                        }];
                    });
                }
                sleep(1);
            }
        });
    }else{
        [_showAlertUI setHidden:NO];
        [_showAlertUI setAlpha:1];
        _timeCount = 0;
    }
    
}

-(void)initHttpData{
    
}

#pragma mark - 按首字母排序
-(void)groupSort:(NSMutableArray*)allCity{
    
    NSMutableArray  *rowData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_allLetterArray count]; i++) {
        
        NSString *letterStr = [NSString stringWithFormat:@"%@",[_allLetterArray objectAtIndex:i]];
        
        for (int j = 0; j < [allCity count]; j++) {
            
//            CustomerList *bean = [CustomerList objectWithKeyValues:[allCity objectAtIndex:j]];
            
//            NSString *cityName = bean.name;
//
//            NSString *cityNameFisrtLetters = [self getFirstHanZiLetter:cityName];
//
//            if ([letterStr isEqualToString:cityNameFisrtLetters]) {
//
//                [rowData addObject:bean];
//            }
        }
        
        if ([rowData count] > 0) {
            [_LeftAllCity addObject:[rowData copy]];
            [_headTitleArr addObject:[letterStr uppercaseString]];
        }
        [rowData removeAllObjects];
        
        [_myTableView reloadData];
    }
}

-(NSString *)getFirstHanZiLetter:(NSString*)str
{
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([predicate evaluateWithObject:str]) {
        return [NSString stringWithFormat:@"%c",[str characterAtIndex:0]];
    }
    
    NSString *FirstLetter = [NSString stringWithFormat:@"%c", pinyinFirstLetter([str characterAtIndex:0])];
    
    return FirstLetter;
}

#pragma mark 多少段
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    [_indexBar setIndexes:_headTitleArr];
    return _headTitleArr.count;
}

#pragma mark 每段返回多少行
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = [_LeftAllCity objectAtIndex:section];
    return arr.count;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22.5)];
    customView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 22.5)];
    lab.text  = _headTitleArr[section];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:11.0f];
    lab.textColor = [UIColor colorWithHexString:@"000000"];
    [customView addSubview:lab];
    
    return customView;
}

#pragma mark 每一行cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSArray *arr = [_LeftAllCity objectAtIndex:indexPath.section];
    
//    CustomerList *bean = [CustomerList objectWithKeyValues:[arr objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = @"地区地区地区";
    

    
    return cell;
    
}

- (CGFloat)tableView:(UITableView * )tableView heightForHeaderInSection:(NSInteger)section{
    
    return 22.5f;
}

#pragma mark 自定义cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65.0f;
}

#pragma mark 选中一行cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = [_LeftAllCity objectAtIndex:indexPath.section];
    

    
}

#pragma mark - AIMTableViewIndexBarDelegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index selectAtIndex:(NSInteger)selectIndex{
    
    if (selectIndex==0) {
        [_myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    
    [self showAlertText:indexBar.letters[selectIndex]];
    
    if ([_myTableView numberOfSections] > index && index > -1){
        [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
