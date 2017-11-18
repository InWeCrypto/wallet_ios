//
//  DBHInformationDetailForExplorerAndWalletTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/16.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForExplorerAndWalletTableViewCell.h"

#import "DBHInformationDetailForExplorerTableViewCell.h"
#import "DBHInformationDetailForWalletCollectionViewCell.h"

#import "DBHInformationDetailDataModels.h"

static NSString *const kDBHInformationDetailForExplorerTableViewCellIdentifier = @"kDBHInformationDetailForExplorerTableViewCellIdentifier";
static NSString *const kDBHInformationDetailForWalletCollectionViewCellIdentifier = @"kDBHInformationDetailForWalletCollectionViewCellIdentifier";

@interface DBHInformationDetailForExplorerAndWalletTableViewCell ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *leftBoxView;
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UIView *leftBottomLineView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *rightBoxView;
@property (nonatomic, strong) UILabel *rightTitleLabel;
@property (nonatomic, strong) UIView *rightBottomLineView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) ClickExplorerOrWalletBlock clickExplorerOrWalletBlock;

@end

@implementation DBHInformationDetailForExplorerAndWalletTableViewCell

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
    [self.contentView addSubview:self.leftBoxView];
    [self.contentView addSubview:self.leftTitleLabel];
    [self.contentView addSubview:self.leftBottomLineView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.rightBoxView];
    [self.contentView addSubview:self.rightTitleLabel];
    [self.contentView addSubview:self.rightBottomLineView];
    [self.contentView addSubview:self.collectionView];
    
    WEAKSELF
    [self.leftBoxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).multipliedBy(0.5).offset(- AUTOLAYOUTSIZE(18.5));
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.left.offset(AUTOLAYOUTSIZE(11.5));
        make.top.offset(AUTOLAYOUTSIZE(10));
    }];
    [self.leftTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftBoxView).offset(AUTOLAYOUTSIZE(7.5));
        make.centerY.equalTo(weakSelf.leftBoxView);
    }];
    [self.leftBottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.leftBoxView);
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.equalTo(weakSelf.leftBoxView);
        make.bottom.equalTo(weakSelf.leftBoxView.mas_bottom);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.leftBoxView);
        make.centerX.equalTo(weakSelf.leftBoxView);
        make.top.equalTo(weakSelf.leftBottomLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    [self.rightBoxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.leftBoxView);
        make.right.offset(- AUTOLAYOUTSIZE(11.5));
        make.centerY.equalTo(weakSelf.leftBoxView);
    }];
    [self.rightTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.rightBoxView).offset(AUTOLAYOUTSIZE(7.5));
        make.centerY.equalTo(weakSelf.rightBoxView);
    }];
    [self.rightBottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.leftBottomLineView);
        make.centerX.equalTo(weakSelf.rightBoxView);
        make.bottom.equalTo(weakSelf.rightBoxView);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tableView);
        make.top.equalTo(weakSelf.tableView);
        make.centerX.equalTo(weakSelf.rightBoxView);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.leftDataSource) {
        return 0;
    }
    return self.leftDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailForExplorerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationDetailForExplorerTableViewCellIdentifier forIndexPath:indexPath];
    DBHInformationDetailModelProjectExplorers *model = self.leftDataSource[indexPath.row];
    cell.title = model.name;
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailModelProjectExplorers *model = self.leftDataSource[indexPath.row];
    self.clickExplorerOrWalletBlock(model.url);
}

#pragma mark ------ UICollectionViewDataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.rightDataSource) {
        return 0;
    }
    return self.rightDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailForWalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHInformationDetailForWalletCollectionViewCellIdentifier forIndexPath:indexPath];
    DBHInformationDetailModelProjectWallets *model = self.rightDataSource[indexPath.row];
    cell.title = model.name;
    
    return cell;
}

#pragma mark ------ UICollectionViewDelegate ------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationDetailModelProjectWallets *model = self.rightDataSource[indexPath.row];
    self.clickExplorerOrWalletBlock(model.url);
}

#pragma mark ------ UICollectionViewDelegateFlowLayout ------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(AUTOLAYOUTSIZE(10), AUTOLAYOUTSIZE(12.5), 0, AUTOLAYOUTSIZE(12.5));
}

#pragma mark ------ Event Responds ------
- (void)clickExplorerOrWalletBlock:(ClickExplorerOrWalletBlock)clickExplorerOrWalletBlock {
    self.clickExplorerOrWalletBlock = clickExplorerOrWalletBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setLeftDataSource:(NSArray *)leftDataSource {
    _leftDataSource = leftDataSource;
    
    [self.tableView reloadData];
}
- (void)setRightDataSource:(NSArray *)rightDataSource {
    _rightDataSource = rightDataSource;
    
    [self.collectionView reloadData];
}

- (UIView *)leftBoxView {
    if (!_leftBoxView) {
        _leftBoxView = [[UIView alloc] init];
        _leftBoxView.backgroundColor = COLORFROM16(0x2DA4DA, 1);
    }
    return _leftBoxView;
}
- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _leftTitleLabel.text = @"Explorer";
        _leftTitleLabel.textColor = [UIColor whiteColor];
    }
    return _leftTitleLabel;
}
- (UIView *)leftBottomLineView {
    if (!_leftBottomLineView) {
        _leftBottomLineView = [[UIView alloc] init];
        _leftBottomLineView.backgroundColor = COLORFROM16(0x000000, 1);
    }
    return _leftBottomLineView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM16(0x2DA4DA, 1);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.rowHeight = AUTOLAYOUTSIZE(24);
        
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationDetailForExplorerTableViewCell class] forCellReuseIdentifier:kDBHInformationDetailForExplorerTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIView *)rightBoxView {
    if (!_rightBoxView) {
        _rightBoxView = [[UIView alloc] init];
        _rightBoxView.backgroundColor = COLORFROM16(0x2DA4DA, 1);
    }
    return _rightBoxView;
}
- (UILabel *)rightTitleLabel {
    if (!_rightTitleLabel) {
        _rightTitleLabel = [[UILabel alloc] init];
        _rightTitleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _rightTitleLabel.text = @"Wallet";
        _rightTitleLabel.textColor = [UIColor whiteColor];
    }
    return _rightTitleLabel;
}
- (UIView *)rightBottomLineView {
    if (!_rightBottomLineView) {
        _rightBottomLineView = [[UIView alloc] init];
        _rightBottomLineView.backgroundColor = COLORFROM16(0x000000, 1);
    }
    return _rightBottomLineView;
}
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(AUTOLAYOUTSIZE(45), AUTOLAYOUTSIZE(20));
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = COLORFROM16(0x2DA4DA, 1);
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[DBHInformationDetailForWalletCollectionViewCell class] forCellWithReuseIdentifier:kDBHInformationDetailForWalletCollectionViewCellIdentifier];
    }
    return _collectionView;
}

@end
