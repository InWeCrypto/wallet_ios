//
//  DBHInformationDetailForTwitterTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForTwitterTableViewCell.h"

#import <WebKit/WebKit.h>

@interface DBHInformationDetailForTwitterTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *loadMoreButton;

@property (nonatomic, copy) ClickTwitterBlock clickTwitterBlock;

@end

@implementation DBHInformationDetailForTwitterTableViewCell

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
//    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.loadMoreButton];
    
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
//    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(23));
//        make.top.equalTo(weakSelf.bottomLineView.mas_bottom).offset(AUTOLAYOUTSIZE(9.5));
//        make.centerX.equalTo(weakSelf.bottomLineView);
//    }];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.bottomLineView.mas_bottom).offset(AUTOLAYOUTSIZE(9.5));
        make.bottom.equalTo(weakSelf.loadMoreButton.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.loadMoreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(55));
        make.height.offset(AUTOLAYOUTSIZE(20));
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.offset(- AUTOLAYOUTSIZE(13.5));
    }];
}

#pragma mark ------ Event Responds ------
/**
 加载更多
 */
- (void)respondsToLoadMoreButton {
    self.clickTwitterBlock();
}

/**
 点击twitter
 */
- (void)respondsToContentLabel {
    
}

#pragma mark ------ Public Methods ------
- (void)clickTwitterBlock:(ClickTwitterBlock)clickTwitterBlock {
    self.clickTwitterBlock = clickTwitterBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setTwitter:(NSString *)twitter {
    _twitter = twitter;
    
    if ([_twitter containsString:@"<"]) {
        [self.webView loadHTMLString:_twitter baseURL:nil];
    } else {
        NSURL *url = [NSURL URLWithString:_twitter];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_twitter dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    self.contentLabel.attributedText = attrStr;
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
        _titleLabel.text = @"Twitter";
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xE6E6E6, 1);
    }
    return _bottomLineView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToContentLabel)];
        [_contentLabel addGestureRecognizer:tapGR];
    }
    return _contentLabel;
}
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}
- (UIButton *)loadMoreButton {
    if (!_loadMoreButton) {
        _loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadMoreButton.backgroundColor = COLORFROM16(0x3E495B, 1);
        _loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(9)];
        [_loadMoreButton setTitle:@"加载更多" forState:UIControlStateNormal];
        [_loadMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loadMoreButton addTarget:self action:@selector(respondsToLoadMoreButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadMoreButton;
}

@end
