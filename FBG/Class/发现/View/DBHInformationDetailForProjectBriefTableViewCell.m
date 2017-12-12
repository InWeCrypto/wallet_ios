//
//  DBHInformationDetailForProjectBriefTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForProjectBriefTableViewCell.h"

#import <WebKit/WebKit.h>

#import "DBHInformationDetailModelProjectDesc.h"

@interface DBHInformationDetailForProjectBriefTableViewCell ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation DBHInformationDetailForProjectBriefTableViewCell

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
    [self.contentView addSubview:self.webView];
    
    WEAKSELF
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHInformationDetailModelProjectDesc *)model {
    _model = model;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@article/%@", [APP_APIEHEAD isEqualToString:APIEHEAD] ? APIEHEADOTHER : APIEHEAD1OTHER, _model.projectDescIdentifier]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

@end
