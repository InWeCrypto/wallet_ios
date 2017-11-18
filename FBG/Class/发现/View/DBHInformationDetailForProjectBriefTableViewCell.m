//
//  DBHInformationDetailForProjectBriefTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationDetailForProjectBriefTableViewCell.h"

#import <WebKit/WebKit.h>

#import "DBHListView.h"

#import "DBHInformationDetailModelProjectDesc.h"

@interface DBHInformationDetailForProjectBriefTableViewCell ()

@property (nonatomic, strong) DBHListView *listView;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) NSInteger selectedIndex; // 选中下标
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation DBHInformationDetailForProjectBriefTableViewCell

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
    [self.contentView addSubview:self.listView];
    [self.contentView addSubview:self.webView];
    
    WEAKSELF
    [self.listView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.height.offset(AUTOLAYOUTSIZE(27));
        make.top.offset(AUTOLAYOUTSIZE(10));
        make.centerX.equalTo(weakSelf.contentView);
    }];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(23));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.listView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectIntroductionArray:(NSArray *)projectIntroductionArray {
    _projectIntroductionArray = projectIntroductionArray;
    
    [self.titleArray removeAllObjects];
    for (DBHInformationDetailModelProjectDesc *model in _projectIntroductionArray) {
        [self.titleArray addObject:model.title];
    }
    
    self.listView.titleArray = [self.titleArray copy];
}

- (DBHListView *)listView {
    if (!_listView) {
        _listView = [[DBHListView alloc] init];
    }
    return _listView;
}
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.backgroundColor = COLORFROM10(0, 0, 0, 0.5);
    }
    return _webView;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

@end
