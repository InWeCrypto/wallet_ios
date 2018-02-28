//
//  DBHInformationHeaderView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInformationHeaderView.h"

#import "DBHFunctionalUnitCollectionViewCell.h"

static NSString *const kDBHFunctionalUnitCollectionViewCellIdentifier = @"kDBHFunctionalUnitCollectionViewCellIdentifier";

@interface DBHInformationHeaderView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *refreshButton;

@property (nonatomic, copy) SelectTypeBlock selectTypeBlock;
@property (nonatomic, copy) ClickFunctionalUnitBlock clickFunctionalUnitBlock;
@property (nonatomic, copy) NSArray *menuArray;
@property (nonatomic, copy) NSArray *titleArray; // 功能组件标题

@end

@implementation DBHInformationHeaderView

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
    [self addSubview:self.collectionView];
    [self addSubview:self.topLineView];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.refreshButton];
    
    WEAKSELF
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(125));
        make.top.centerX.equalTo(weakSelf);
    }];
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.bottom.equalTo(weakSelf);
    }];
    [self.refreshButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(33));
        make.right.offset(- AUTOLAYOUTSIZE(3.5));
        make.bottom.equalTo(weakSelf);
    }];
    
    for (NSInteger i = 0; i < self.menuArray.count + 1; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 200 + i;
        if (!i) {
            button.selected = YES;
            [button setImage:[UIImage imageNamed:@"xiangmugaikuang_xing1"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"xiangmugaikuang_xing_s1"] forState:UIControlStateSelected];
        } else {
            button.titleLabel.font = BOLDFONT(12);
            [button setTitle:DBHGetStringWithKeyFromTable(self.menuArray[i - 1], nil) forState:UIControlStateNormal];
            [button setTitleColor:COLORFROM16(0xD8D8D8, 1) forState:UIControlStateNormal];
            [button setTitleColor:COLORFROM16(0xF46A00, 1) forState:UIControlStateSelected];
        }
        [button addTarget:self action:@selector(respondsToMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!i) {
                make.width.offset(AUTOLAYOUTSIZE(27));
                make.left.offset(AUTOLAYOUTSIZE(6));
            } else {
                make.width.offset([self.menuArray[i - 1] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:BOLDFONT(12)} context:nil].size.width + AUTOLAYOUTSIZE(14));
                make.left.equalTo([weakSelf viewWithTag:199 + i].mas_right);
            }
            make.height.offset(AUTOLAYOUTSIZE(32.5));
            make.bottom.equalTo(weakSelf);
        }];
        if (!i) {
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(AUTOLAYOUTSIZE(10));
                make.height.offset(AUTOLAYOUTSIZE(1.5));
                make.centerX.equalTo(button);
                make.bottom.offset(- AUTOLAYOUTSIZE(3));
            }];
        }
    }
}

#pragma mark ------ UICollectionViewDataSource ------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBHFunctionalUnitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDBHFunctionalUnitCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];

    return cell;
}

#pragma mark ------ UICollectionViewDelegate ------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.clickFunctionalUnitBlock(indexPath.row);
}

#pragma mark ------ Event Responds ------
/**
 选择菜单
 */
- (void)respondsToMenuButton:(UIButton *)sender {
    if (sender.tag - 200 == self.currentSelectedIndex) {
        return;
    }
    
    UIButton *lastSelectedButton = [self viewWithTag:200 + self.currentSelectedIndex];
    lastSelectedButton.selected = NO;
    
    sender.selected = YES;
    self.currentSelectedIndex = sender.tag - 200;
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(10));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo(sender);
        make.bottom.offset(- AUTOLAYOUTSIZE(3));
    }];
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
    
    self.selectTypeBlock();
}
/**
 刷新
 */
- (void)respondsToRefreshButton {
    self.selectTypeBlock();
    [self startAnimation];
}

#pragma mark ------ Public Methods ------
- (void)selectTypeBlock:(SelectTypeBlock)selectTypeBlock {
    self.selectTypeBlock = selectTypeBlock;
}
- (void)clickFunctionalUnitBlock:(ClickFunctionalUnitBlock)clickFunctionalUnitBlock {
    self.clickFunctionalUnitBlock = clickFunctionalUnitBlock;
}
- (void)stopAnimation {
    [self.refreshButton.layer removeAnimationForKey:@"rotateAnimation"];
}

#pragma mark ------ Private Methods ------
- (void)startAnimation {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotateAnimation.duration = 1;
    rotateAnimation.repeatCount = CGFLOAT_MAX;
    [self.refreshButton.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

#pragma mark ------ Getters And Setters ------
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(SCREENWIDTH * 0.25, AUTOLAYOUTSIZE(125));
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = COLORFROM16(0xF8F8F8, 1);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[DBHFunctionalUnitCollectionViewCell class] forCellWithReuseIdentifier:kDBHFunctionalUnitCollectionViewCellIdentifier];
    }
    return _collectionView;
}
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _topLineView;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xFF6806, 1);
    }
    return _bottomLineView;
}
- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[UIImage imageNamed:@"zhuye_shuaxin_ico"] forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(respondsToRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (NSArray *)menuArray {
    if (!_menuArray) {
        _menuArray = @[@"Trading", @"Active", @"Upcoming", @"Ended"];
    }
    return _menuArray;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"InWe Hotspot",
                        @"Trading View",
                        @"Exchange",
//                        @"Candybowl",
                        @"Trading Reminder",
                        @"Notice"];
    }
    return _titleArray;
}

@end
