//
//  DBHInformationDetailForMoreTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForMoreTableViewCell.h"

#import "DBHInformationDetailForMoreCollectionViewCell.h"

#import "DBHInformationDetailModelProjectMedias.h"

static NSString *const kDBHInformationDetailForMoreCollectionViewCellIdentifier = @"kDBHInformationDetailForMoreCollectionViewCellIdentifier";

@interface DBHInformationDetailForMoreTableViewCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) ClickMoreButtonBlock clickMoreButtonBlock;

@end

@implementation DBHInformationDetailForMoreTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.collectionView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(10));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.top.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.bottom.centerX.equalTo(weakSelf.titleLabel);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.bottomLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ UICollectionViewDataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.dataSouce) {
        return 0;
    }
    return self.dataSouce.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailForMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHInformationDetailForMoreCollectionViewCellIdentifier forIndexPath:indexPath];
    DBHInformationDetailModelProjectMedias *model = self.dataSouce[indexPath.row];
    cell.imageUrl = model.img;
    
    return cell;
}

#pragma mark ------ UICollectionViewDelegate ------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailModelProjectMedias *model = self.dataSouce[indexPath.row];
    self.clickMoreButtonBlock(model.url);
}

#pragma mark ------ UICollectionViewDelegateFlowLayout ------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, AUTOLAYOUTSIZE(6), 0, 0);
}

#pragma mark ------ Public Methods ------
- (void)clickMoreButtonBlock:(ClickMoreButtonBlock)clickMoreButtonBlock {
    self.clickMoreButtonBlock = clickMoreButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setDataSouce:(NSArray *)dataSouce {
    _dataSouce = dataSouce;
    
    [self.collectionView reloadData];
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM16(0x2DA4DA, 1);
    }
    return _boxView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _titleLabel.text = @"更多资讯";
        _titleLabel.textColor = COLORFROM16(0xFFFFFF, 1);
    }
    return _titleLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0x000000, 1);
    }
    return _bottomLineView;
}
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake((SCREEN_WIDTH - AUTOLAYOUTSIZE(44)) / 8.0, AUTOLAYOUTSIZE(52.5));
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = COLORFROM16(0x2DA4DA, 1);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[DBHInformationDetailForMoreCollectionViewCell class] forCellWithReuseIdentifier:kDBHInformationDetailForMoreCollectionViewCellIdentifier];
    }
    return _collectionView;
}

@end
