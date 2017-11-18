//
//  DBHInformationDetailForMoreCollectionViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/18.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForMoreCollectionViewCell.h"

@interface DBHInformationDetailForMoreCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation DBHInformationDetailForMoreCollectionViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLORFROM16(0x2DA4DA, 1);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.iconImageView];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(25));
        make.center.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    [self.iconImageView sdsetImageWithURL:_imageUrl placeholderImage:[UIImage imageNamed:@""]];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end
