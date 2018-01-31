//
//  DBHPersonalSettingForSwitchTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPersonalSettingForSwitchTableViewCell.h"

#import <HyphenateLite/HyphenateLite.h>

@interface DBHPersonalSettingForSwitchTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *onSwitch;

@end

@implementation DBHPersonalSettingForSwitchTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.onSwitch];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.onSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Event Responds ------
- (void)respondsToOnSwitch {
    [UserSignData share].user.isOpenNoDisturbing = !self.onSwitch.isOn;
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    options.noDisturbStatus = [UserSignData share].user.isOpenNoDisturbing ? EMPushNoDisturbStatusDay : EMPushNoDisturbStatusClose;
    EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_title, nil);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(13);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UISwitch *)onSwitch {
    if (!_onSwitch) {
        _onSwitch = [[UISwitch alloc] init];
        _onSwitch.on = ![UserSignData share].user.isOpenNoDisturbing;
        _onSwitch.onTintColor = COLORFROM16(0xF46A00, 1);
        _onSwitch.backgroundColor = COLORFROM16(0xBFBFBF, 1);
        _onSwitch.layer.cornerRadius = AUTOLAYOUTSIZE(16);
        _onSwitch.clipsToBounds = YES;
        [_onSwitch addTarget:self action:@selector(respondsToOnSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _onSwitch;
}

@end
