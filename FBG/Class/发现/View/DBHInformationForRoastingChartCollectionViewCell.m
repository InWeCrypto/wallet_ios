//
//  DBHInformationForRoastingChartCollectionViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationForRoastingChartCollectionViewCell.h"

#import "SDCycleScrollView.h"

#import "DBHInformationForRoastingChartCollectionModelList.h"

@interface DBHInformationForRoastingChartCollectionViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, copy) ClickRoastingChartBlock clickRoastingChartBlock;

@end

@implementation DBHInformationForRoastingChartCollectionViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.cycleScrollView];
    
    WEAKSELF
    [self.cycleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ SDCycleScrollViewDelegate ------
/**
 点击图片回调
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    self.clickRoastingChartBlock(index);
}

#pragma mark ------ Public Methods ------
- (void)clickRoastingChartBlock:(ClickRoastingChartBlock)clickRoastingChartBlock {
    self.clickRoastingChartBlock = clickRoastingChartBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    NSMutableArray *imageUrlArray = [NSMutableArray array];
    for (DBHInformationForRoastingChartCollectionModelList *model in _dataSource) {
        NSString *url;
        if ([model.img containsString:@"http"]) {
            url = model.img;
        } else {
            url = [NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.img];
        }
        [imageUrlArray addObject:url];
    }
    
    self.cycleScrollView.imageURLStringsGroup = imageUrlArray;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    return _cycleScrollView;
}

@end
