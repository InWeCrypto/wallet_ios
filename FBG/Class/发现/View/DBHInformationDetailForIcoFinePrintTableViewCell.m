//
//  DBHInformationDetailForIcoFinePrintTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForIcoFinePrintTableViewCell.h"

#import "DBHInformationDetailModelIcoDetail.h"

@interface DBHInformationDetailForIcoFinePrintTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *officialWebsiteButton;

@property (nonatomic, copy) ClickOfficialWebsiteBlock clickOfficialWebsiteBlock;

@end

@implementation DBHInformationDetailForIcoFinePrintTableViewCell

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
    [self.contentView addSubview:self.contentTextView];
    [self.contentView addSubview:self.officialWebsiteButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(10));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(6.5));
        make.centerX.equalTo(weakSelf.boxView);
    }];
    [self.contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(50));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(15));
        make.bottom.equalTo(weakSelf.officialWebsiteButton.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.officialWebsiteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(200));
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(10.5));
    }];
}

#pragma mark ------ Event Responds ------
/**
 官网
 */
- (void)respondsToOfficialWebsiteButton {
    self.clickOfficialWebsiteBlock();
}

#pragma mark ------ Public Methods ------
- (void)clickOfficialWebsiteBlock:(ClickOfficialWebsiteBlock)clickOfficialWebsiteBlock {
    self.clickOfficialWebsiteBlock = clickOfficialWebsiteBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setIcoArray:(NSArray *)icoArray {
    _icoArray = icoArray;
    
    NSMutableString *content = [NSMutableString string];
    for (DBHInformationDetailModelIcoDetail *model in _icoArray) {
        [content appendFormat:@"%@%@\n", model.name, model.desc];
    }
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:AUTOLAYOUTSIZE(5)];
    [contentAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    
    NSInteger current = 0;
    for (DBHInformationDetailModelIcoDetail *model in _icoArray) {
        if ([model isEqual:_icoArray.firstObject]) {
            current += model.name.length + model.desc.length;
            [contentAttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:AUTOLAYOUTSIZE(9)]} range:NSMakeRange(0, current)];
        } else {
            [contentAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(7)]} range:NSMakeRange(current + 1, model.name.length)];
            current += model.name.length;
            
            [contentAttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:AUTOLAYOUTSIZE(7)]} range:NSMakeRange(current + 1, model.desc.length)];
            current += model.desc.length + 1;
        }
    }
    
    self.contentTextView.attributedText = contentAttributedString;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor whiteColor];
    }
    return _boxView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        _titleLabel.text = @"ICO细则";
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
//        _contentTextView.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(7)];
        _contentTextView.textColor = COLORFROM16(0x333333, 1);
        _contentTextView.editable = NO;
        _contentTextView.showsVerticalScrollIndicator = NO;
    }
    return _contentTextView;
}
- (UIButton *)officialWebsiteButton {
    if (!_officialWebsiteButton) {
        _officialWebsiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _officialWebsiteButton.backgroundColor = COLORFROM16(0x3E495B, 1);
        _officialWebsiteButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(12)];
        [_officialWebsiteButton setTitle:@"官网" forState:UIControlStateNormal];
        [_officialWebsiteButton setTitleColor:COLORFROM16(0xFFFEFE, 1) forState:UIControlStateNormal];
        [_officialWebsiteButton addTarget:self action:@selector(respondsToOfficialWebsiteButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _officialWebsiteButton;
}

@end
