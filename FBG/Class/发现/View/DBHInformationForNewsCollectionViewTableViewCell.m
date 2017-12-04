//
//  DBHInformationForNewsCollectionViewTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/30.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationForNewsCollectionViewTableViewCell.h"

@interface DBHInformationForNewsCollectionViewTableViewCell ()

@property (nonatomic, strong) UIView *orangeCircleView;
@property (nonatomic, strong) UILabel *contentLabel;;

@end

@implementation DBHInformationForNewsCollectionViewTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.orangeCircleView];
    [self addSubview:self.contentLabel];
    
    WEAKSELF
    [self.orangeCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(5));
        make.left.offset(AUTOLAYOUTSIZE(12.5));
        make.centerY.equalTo(weakSelf);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.orangeCircleView.mas_right).offset(AUTOLAYOUTSIZE(6.5));
        make.right.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.contentLabel.text = _title;
}

- (UIView *)orangeCircleView {
    if (!_orangeCircleView) {
        _orangeCircleView = [[UIView alloc] init];
        _orangeCircleView.backgroundColor = COLORFROM16(0xFF7800, 1);
        _orangeCircleView.layer.cornerRadius = AUTOLAYOUTSIZE(2.5);
    }
    return _orangeCircleView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _contentLabel;
}

@end
