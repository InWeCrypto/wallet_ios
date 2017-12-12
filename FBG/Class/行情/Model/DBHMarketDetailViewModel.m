//
//  DBHMarketDetailViewModel.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHMarketDetailViewModel.h"

#import "DBHMarketDetailKLineViewDataModels.h"
#import "DBHMarketDetailMoneyRealTimePriceDataModels.h"

@interface DBHMarketDetailViewModel ()


@property (nonatomic, copy) NSString *ico_type;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) RequestMoneyRealTimePriceBlock requestMoneyRealTimePriceBlock;
@property (nonatomic, copy) RequestBlock requestBlock;

@end

@implementation DBHMarketDetailViewModel

#pragma mark ------ Lifecycle ------
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark ------ Data ------
/**
 获取货币实时价格
 */
- (void)getMoneyRealTimePrice {
    [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/time_price/%@", self.ico_type] isOtherBaseUrl:YES parameters:nil hudString:nil responseCache:^(id responseCache) {
        DBHMarketDetailMoneyRealTimePriceModelData *model = [DBHMarketDetailMoneyRealTimePriceModelData modelObjectWithDictionary:responseCache];
        
        self.requestMoneyRealTimePriceBlock(model);
    } success:^(id responseObject) {
        DBHMarketDetailMoneyRealTimePriceModelData *model = [DBHMarketDetailMoneyRealTimePriceModelData modelObjectWithDictionary:responseObject];
        
        self.requestMoneyRealTimePriceBlock(model);
    } failure:^(NSString *error) {
//        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Public Methods ------
- (void)requestMoneyRealTimePriceBlock:(RequestMoneyRealTimePriceBlock)requestMoneyRealTimePriceBlock {
    self.requestMoneyRealTimePriceBlock = requestMoneyRealTimePriceBlock;
}
- (void)requestBlock:(RequestBlock)requestBlock {
    self.requestBlock = requestBlock;
}
- (void)getKLineDataWithIco_type:(NSString *)ico_type interval:(NSString *)interval {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/currencies/%@/%@/%@", ico_type, @"usdt", interval] isOtherBaseUrl:YES parameters:nil hudString:@"加载中" responseCache:^(id responseCache) {
        NSArray *dataArray = responseCache;
        
        if (!dataArray.count) {
            return ;
        }
        
        NSMutableArray *kLineDataArray = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            DBHMarketDetailKLineViewModelData *model = [DBHMarketDetailKLineViewModelData modelObjectWithDictionary:dic];
            
            [kLineDataArray addObject:model];
        }
        
        weakSelf.requestBlock(kLineDataArray);
    } success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        
        if (!dataArray.count) {
            return ;
        }
        
        NSMutableArray *kLineDataArray = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            DBHMarketDetailKLineViewModelData *model = [DBHMarketDetailKLineViewModelData modelObjectWithDictionary:dic];
            
            [kLineDataArray addObject:model];
        }
        
        weakSelf.requestBlock(kLineDataArray);
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
- (void)getMoneyRealTimePriceWithIco_type:(NSString *)ico_type {
    self.ico_type = ico_type;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getMoneyRealTimePrice) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

@end
