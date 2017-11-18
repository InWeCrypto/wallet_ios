//
//  DBHSearchBarButton.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHSearchBarButton.h"

@interface DBHSearchBarButton ()

@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UILabel *searchLabel;

@end

@implementation DBHSearchBarButton

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = AUTOLAYOUTSIZE(4);
        self.backgroundColor = [UIColor colorWithHexString:@"161F26"];
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.searchImageView];
    [self addSubview:self.searchLabel];
    
    WEAKSELF
    [self.searchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(16));
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf.searchLabel.mas_left).offset(- AUTOLAYOUTSIZE(3.5));
    }];
    [self.searchLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(9.75));
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIImageView *)searchImageView {
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_market_search"]];
    }
    return _searchImageView;
}
- (UILabel *)searchLabel {
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _searchLabel.text = @"搜索项目";
        _searchLabel.textColor = [UIColor colorWithHexString:@"55637E "];
    }
    return _searchLabel;
}

@end
