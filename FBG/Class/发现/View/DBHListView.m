//
//  DBHListView.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHListView.h"

#import "DBHListViewCollectionViewCell.h"

static NSString *const kDBHListViewCollectionViewCellIdentifier = @"kDBHListViewCollectionViewCellIdentifier";

@interface DBHListView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DBHListView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.collectionView];
    
    WEAKSELF
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
        make.center.equalTo(weakSelf);
    }];
}

#pragma mark ------ UICollectionViewDataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBHListViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHListViewCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.isSelected = indexPath.row == self.selectedIndex;
    
    return cell;
}

#pragma mark ------ UICollectionViewDelegate ------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedIndex) {
        return;
    }
    
    DBHListViewCollectionViewCell *lastSelectedCell = (DBHListViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    lastSelectedCell.isSelected = NO;
    
    DBHListViewCollectionViewCell *currentSelectedCell = (DBHListViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    currentSelectedCell.isSelected = YES;
    
    self.selectedIndex = indexPath.row;
}

#pragma mark ------ UICollectionViewDelegateFlowLayout ------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, AUTOLAYOUTSIZE(0.5));
}

#pragma mark ------ Getters And Setters ------
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    
    [self.collectionView reloadData];
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(SCREEN_WIDTH - AUTOLAYOUTSIZE(24.5), AUTOLAYOUTSIZE(27));
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[DBHListViewCollectionViewCell class] forCellWithReuseIdentifier:kDBHListViewCollectionViewCellIdentifier];
    }
    return _collectionView;
}

@end
