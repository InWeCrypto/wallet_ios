//
//  QuotationInfoVC.m
//  FBG
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "QuotationInfoVC.h"
#import "SymbolsValueFormatter.h"
#import "DateValueFormatter.h"
#import "SetValueFormatter.h"
#import "YUSegment.h"
#import "QuotationInfoModel.h"

@import Charts;
@interface QuotationInfoVC () <ChartViewDelegate>
{
    int _type;  //类型,默认1,支持1 分,2 时,3 天,4 周
    int _lastType;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *usdPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *cnyPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *changeLB;
@property (weak, nonatomic) IBOutlet UILabel *beginLB;
@property (weak, nonatomic) IBOutlet UILabel *upPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *lowPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@property (nonatomic,strong) LineChartView * lineView;
@property (nonatomic,strong) UILabel * markY;
@property (nonatomic, strong) YUSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray * xValueDataSource;
@property (nonatomic, strong) NSMutableArray * timeValueDataSource;

@end

@implementation QuotationInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"行情详情";
    
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.segmentedControl];
    _type = 1;
    _lastType = 1;
    
    self.nameLB.text = self.quotationModel.name;
    self.typeLB.text = self.quotationModel.source;
    self.usdPriceLB.text = [NSString stringWithFormat:@"$%.2f",[self.quotationModel.relationCap.price_usd floatValue]];
    self.cnyPriceLB.text = [NSString stringWithFormat:@"￥%.2f",[self.quotationModel.relationCap.price_cny floatValue]];
    
    if ([self.quotationModel.relationCap.percent_change_24h floatValue] < 0)
    {
        self.changeLB.text = [NSString stringWithFormat:@"%@%%",self.quotationModel.relationCap.percent_change_24h];
        self.changeLB.backgroundColor = [UIColor colorWithHexString:@"FB5A67"];
    }
    else
    {
        self.changeLB.backgroundColor = [UIColor colorWithHexString:@"66B7FB"];
        self.changeLB.text = [NSString stringWithFormat:@"+%@%%",self.quotationModel.relationCap.percent_change_24h];
    }
    
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.beginLB.text = [NSString stringWithFormat:@"￥%.2f",[self.quotationModel.relationCapMin.price_cny_first floatValue]];
        self.upPriceLB.text = [NSString stringWithFormat:@"￥%.2f",[self.quotationModel.relationCapMin.price_cny_high floatValue]];
        self.lowPriceLB.text = [NSString stringWithFormat:@"￥%.2f",[self.quotationModel.relationCapMin.price_cny_low floatValue]];
        self.numberLb.text = [NSString getDealNumwithstring:self.quotationModel.relationCap.volume_cny_24h];
    }
    else
    {
        self.beginLB.text = [NSString stringWithFormat:@"$%.2f",[self.quotationModel.relationCapMin.price_usd_first floatValue]];
        self.upPriceLB.text = [NSString stringWithFormat:@"$%.2f",[self.quotationModel.relationCapMin.price_usd_high floatValue]];
        self.lowPriceLB.text = [NSString stringWithFormat:@"$%.2f",[self.quotationModel.relationCapMin.price_usd_low floatValue]];
        self.numberLb.text = [NSString getDealNumwithstring:self.quotationModel.relationCap.volume_usd_24h];
    }
    
    self.xValueDataSource = [[NSMutableArray alloc] init];
    self.timeValueDataSource = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)loadData
{
    /*
     start           string          开始时间,默认当天凌晨
     end             string          结束时间,默认当前服务器时间
     type            int             类型,默认1,支持1 分,2 时,3 天,4 周
     */

    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(_type) forKey:@"type"];
    
    [PPNetworkHelper GET:[NSString stringWithFormat:@"market-category/%d",self.quotationModel.id] parameters:parametersDic hudString:@"获取中..." responseCache:^(id responseCache)
     {
         if (![NSString isNulllWithObject:[responseCache objectForKey:@"list"]] && [[responseCache objectForKey:@"list"] count] > 0)
         {
             [self.xValueDataSource removeAllObjects];
             [self.timeValueDataSource removeAllObjects];
             _lastType = _type;
             for (NSDictionary * dic in [responseCache objectForKey:@"list"])
             {
                 QuotationInfoModel * model = [[QuotationInfoModel alloc] initWithDictionary:dic];
                 if ([UserSignData share].user.walletUnitType == 1)
                 {
                     [self.xValueDataSource addObject:@([model.price_cny_last floatValue])];
                 }
                 else
                 {
                     [self.xValueDataSource addObject:@([model.price_usd_last floatValue])];
                 }
                 
                 switch (_type)
                 {
                     case 1:
                     {
                         //分
                         [self.timeValueDataSource addObject:[NSString timeExchangeWithType:@"HH:mm" timeString:model.timestamp]];
                         break;
                     }
                     case 2:
                     {
                         //时
                         [self.timeValueDataSource addObject:[NSString timeExchangeWithType:@"dd点" timeString:model.timestamp]];
                         break;
                     }
                     default:
                     {
                         [self.timeValueDataSource addObject:[NSString timeExchangeWithType:@"MM-dd日" timeString:model.timestamp]];
                         break;
                     }
                 }
             }
             self.lineView.data = [self setData];
             [self.lineView reloadInputViews];
         }
     } success:^(id responseObject)
    {
        if (![NSString isNulllWithObject:[responseObject objectForKey:@"list"]] && [[responseObject objectForKey:@"list"] count] > 0)
        {
            [self.xValueDataSource removeAllObjects];
            [self.timeValueDataSource removeAllObjects];
            _lastType = _type;
            for (NSDictionary * dic in [responseObject objectForKey:@"list"])
            {
                QuotationInfoModel * model = [[QuotationInfoModel alloc] initWithDictionary:dic];
                if ([UserSignData share].user.walletUnitType == 1)
                {
                    [self.xValueDataSource addObject:@([model.price_cny_last floatValue])];
                }
                else
                {
                    [self.xValueDataSource addObject:@([model.price_usd_last floatValue])];
                }
                switch (_type)
                {
                    case 1:
                    {
                        //分
                        [self.timeValueDataSource addObject:[NSString timeExchangeWithType:@"HH:mm" timeString:model.timestamp]];
                        break;
                    }
                    case 2:
                    {
                        //时
                        [self.timeValueDataSource addObject:[NSString timeExchangeWithType:@"dd点" timeString:model.timestamp]];
                        break;
                    }
                    default:
                    {
                        [self.timeValueDataSource addObject:[NSString timeExchangeWithType:@"MM-dd日" timeString:model.timestamp]];
                        break;
                    }
                }
            }
            self.lineView.data = [self setData];
            [self.lineView reloadInputViews];
        }
        else
        {
            [LCProgressHUD showMessage:@"暂无数据"];
        }
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
}

- (void)segmentedControlTapped:(YUSegmentedControl *)sender
{
    //选择显示数据类型
    _type = (int)sender.selectedSegmentIndex + 1;
    [self loadData];
}

- (LineChartData *)setData
{
    NSInteger xVals_count = self.timeValueDataSource.count;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    
    _lineView.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:self.timeValueDataSource];

//    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++)
    {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[self.xValueDataSource[i] floatValue]];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = nil;
    //创建LineChartDataSet对象
    set1 = [[LineChartDataSet alloc]initWithValues:yVals label:nil];
    //设置折线的样式
    set1.lineWidth = 4.0/[UIScreen mainScreen].scale;//折线宽度
    
    set1.drawValuesEnabled = NO;//是否在拐点处显示数据
    set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
    
    set1.valueColors = @[[UIColor clearColor]];//折线拐点处显示数据的颜色
    
    [set1 setColor:[UIColor colorWithHexString:@"fdd930"]];//折线颜色
    set1.highlightColor = [UIColor whiteColor];
    set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
    //折线拐点样式
    set1.drawCirclesEnabled = NO;//是否绘制拐点
    set1.drawFilledEnabled = NO;//是否填充颜色
    
    //将 LineChartDataSet 对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    //添加第二个LineChartDataSet对象
    
    //        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    //        for (int i = 0; i <  xVals_count; i++) {
    //            int a = arc4random() % 80;
    //            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:a];
    //            [yVals2 addObject:entry];
    //        }
    //        LineChartDataSet *set2 = [set1 copy];
    //        set2.values = yVals2;
    //        set2.drawValuesEnabled = NO;
    //        [set2 setColor:[UIColor blueColor]];
    //
    //        [dataSets addObject:set2];
    //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
    LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
    
    [data setValueFont:[UIFont systemFontOfSize:11]];//文字字体
    [data setValueTextColor:[UIColor whiteColor]];//文字颜色
    return data;
    /*
    if (_lineView.data.dataSetCount > 0)
    {
        LineChartData *data = (LineChartData *)_lineView.data;
        set1 = (LineChartDataSet *)data.dataSets[0];
        set1.values = yVals;
        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        return data;
    }
    else
    {
        //创建LineChartDataSet对象
        set1 = [[LineChartDataSet alloc]initWithValues:yVals label:nil];
        //设置折线的样式
        set1.lineWidth = 4.0/[UIScreen mainScreen].scale;//折线宽度
        
        set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        
        set1.valueColors = @[[UIColor redColor]];//折线拐点处显示数据的颜色
        
        [set1 setColor:[UIColor colorWithHexString:@"fdd930"]];//折线颜色
        set1.highlightColor = [UIColor whiteColor];
        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        set1.drawFilledEnabled = NO;//是否填充颜色
        
        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //添加第二个LineChartDataSet对象
        
        //        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
        //        for (int i = 0; i <  xVals_count; i++) {
        //            int a = arc4random() % 80;
        //            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:a];
        //            [yVals2 addObject:entry];
        //        }
        //        LineChartDataSet *set2 = [set1 copy];
        //        set2.values = yVals2;
        //        set2.drawValuesEnabled = NO;
        //        [set2 setColor:[UIColor blueColor]];
        //
        //        [dataSets addObject:set2];
        //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
        
        [data setValueFont:[UIFont systemFontOfSize:11]];//文字字体
        [data setValueTextColor:[UIColor whiteColor]];//文字颜色
        return data;
    }
     */
    
}

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
    _markY.text = [NSString stringWithFormat:@"%ld",(long)entry.y];
    //将点击的数据滑动到中间
    [_lineView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_lineView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:0.3];
    
    
}
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView
{
    
}

#pragma mark -- get

- (UILabel *)markY{
    if (!_markY)
    {
        _markY = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
        _markY.font = [UIFont systemFontOfSize:11];
        _markY.textAlignment = NSTextAlignmentCenter;
        _markY.text =@"";
        _markY.textColor = [UIColor whiteColor];
        _markY.backgroundColor = [UIColor grayColor];
    }
    return _markY;
}

- (LineChartView *)lineView {
    if (!_lineView) {
        _lineView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 265, SCREEN_WIDTH, SCREEN_HEIGHT - 270 - 64)];
        _lineView.delegate = self;//设置代理
        _lineView.backgroundColor =  [UIColor colorWithHexString:@"2f2f2f"];
        _lineView.noDataText = @"数据获取中";
        _lineView.chartDescription.enabled = YES;
        _lineView.scaleYEnabled = YES;//取消Y轴缩放
        _lineView.doubleTapToZoomEnabled = YES;//取消双击缩放
        _lineView.dragEnabled = YES;//启用拖拽图标·
        _lineView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        _lineView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
        //设置滑动时候标签
        ChartMarkerView *markerY = [[ChartMarkerView alloc] init];
        markerY.offset = CGPointMake(-999, -8);
        markerY.chartView = _lineView;
        _lineView.marker = markerY;
        [markerY addSubview:self.markY];
        
        _lineView.rightAxis.enabled = NO;//不绘制右边轴
        ChartYAxis *leftAxis = _lineView.leftAxis;//获取左边Y轴
        leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
        // leftAxis.axisMinValue = 0;//设置Y轴的最小值
        //leftAxis.axisMaxValue = 105;//设置Y轴的最大值
        leftAxis.inverted = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineColor = [UIColor whiteColor];//Y轴颜色
        leftAxis.valueFormatter = [[SymbolsValueFormatter alloc]init];
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
        leftAxis.labelTextColor = [UIColor whiteColor];//文字颜色
        leftAxis.labelFont = [UIFont systemFontOfSize:11.0f];//文字字体
        leftAxis.gridColor = [UIColor clearColor];//网格线颜色
        leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
        
        ChartXAxis *xAxis = _lineView.xAxis;
        xAxis.granularityEnabled = YES;//设置重复的值不显示
        xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
        xAxis.gridColor = [UIColor clearColor];
        xAxis.labelTextColor = [UIColor whiteColor];//文字颜色
        xAxis.labelFont = [UIFont systemFontOfSize:11];
        xAxis.axisLineColor = [UIColor whiteColor];
        _lineView.maxVisibleCount = 999;//
        
        //描述及图例样式
        [_lineView setDescriptionText:@""];
        _lineView.legend.enabled = NO;
        
        [_lineView animateWithXAxisDuration:1.0f];
    }
    return _lineView;
}

- (YUSegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        _segmentedControl = [[YUSegmentedControl alloc] initWithTitles:@[@"分", @"时", @"天", @"周"]];
        _segmentedControl.indicator.locate = YUSegmentedControlIndicatorLocateTop;
        _segmentedControl.frame = CGRectMake(20, 230, SCREEN_WIDTH - 40, 30);
        _segmentedControl.backgroundColor = [UIColor colorWithHexString:@"2f2f2f"];
        _segmentedControl.indicator.backgroundColor = [UIColor colorWithHexString:@"fdd930"];
        [_segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

@end
