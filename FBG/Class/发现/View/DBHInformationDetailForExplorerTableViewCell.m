//
//  DBHInformationDetailForExplorerTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/16.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForExplorerTableViewCell.h"

@interface DBHInformationDetailForExplorerTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DBHInformationDetailForExplorerTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLORFROM16(0x2DA4DA, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(8));
        make.right.offset(- AUTOLAYOUTSIZE(8));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(8)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
