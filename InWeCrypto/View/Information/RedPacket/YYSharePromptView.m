//
//  YYSharePromptView.m
//  FBG
//
//  Created by yy on 2018/4/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYSharePromptView.h"
#import "LYShareMenuView.h"
#import <TwitterKit/TWTRComposer.h>
#import "YYRedPacketShareViewController.h"
#import "DBHBaseNavigationController.h"
#import "WKWebView+ZFJViewCapture.h"

@interface YYSharePromptView()<LYShareMenuViewDelegate>

@property (nonatomic, strong) LYShareMenuView *sharedMenuView;
@property (nonatomic, strong) NSMutableArray *sharedMenuItems;
@property (nonatomic, copy) NSString *sharedUrl;
@property (nonatomic, strong) UIViewController *target;

@end

@implementation YYSharePromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.sharedMenuView];
    }
    return self;
}

#pragma mark ---- push vc ------
- (void)pushToShareVC:(NSInteger)index {
    YYRedPacketShareViewController *shareVC = [[UIStoryboard storyboardWithName:REDPACKET_STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:REDPACKET_SHARE_STORYBOARD_ID];
    shareVC.model = self.model;
    shareVC.index = index;
    DBHBaseNavigationController *navigationController = [[DBHBaseNavigationController alloc] initWithRootViewController:shareVC];
    [self.target presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark ------- Private Method ---------
- (void)showWithTarget:(UIViewController *)target {
    self.target = target;
    [self.sharedMenuView show];
}

- (void)shareToTwitter {

    NSString *urlStr = self.sharedUrl;
    NSString *titleStr = @"You have a redpacket to pick up！";
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setURL:[NSURL URLWithString:urlStr]];

    [composer setText:titleStr];

    WEAKSELF
    [composer showFromViewController:self.target completion:^(TWTRComposerResult result) {
        [weakSelf shareSuccess:result == TWTRComposerResultDone];
    }];
}

- (void)shareToTelegram {
    NSString *urlStr = [NSString stringWithFormat:@"https://t.me/share/url?text=%@&url=%@", @"You have a redpacket to pick up！", self.sharedUrl];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
    [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
        if (!success) {
            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Uninstalled Telegram", nil)];
        }
    }];
}

- (void)shareSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Share successfully", nil)];
    } else {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Share failed", nil)];
    }
}

#pragma mark ----- Share Delegate ------
- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    switch (index) {
        case 3: { // tele
            [self shareToTelegram];
            break;
        }
        case 4: { // twitter
            [self shareToTwitter];
            break;
        }
       
        default: {
            [self pushToShareVC:index];
            break;
        }
    }
}

#pragma mark ----- Setters And Getters ---------
- (LYShareMenuView *)sharedMenuView {
    if (!_sharedMenuView) {
        _sharedMenuView = [[LYShareMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _sharedMenuView.shareMenuItems = self.sharedMenuItems;
        
        WEAKSELF
        [_sharedMenuView setBlock:^{
            [weakSelf removeFromSuperview];
        }];
    }
    if (!_sharedMenuView.delegate) {
        _sharedMenuView.delegate = self;
    }
    return _sharedMenuView;
}

- (NSString *)sharedUrl {
    if (!_sharedUrl) {
        NSString *tempURL = TEST_REDPACKET_CREATE_CODE;
        if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
            tempURL = REDPACKET_CREATE_CODE;
        }
        
        NSString *user = [self.model.share_user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *createCodeUrl = [tempURL stringByAppendingFormat:@"redbag/%@/%@?share_user=%@&lang=%@&target=%@&symbol=%@&inwe", @(self.model.redPacketId), self.model.redbag_addr, user, [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh" : @"en", @"draw", self.model.redbag_symbol];
        _sharedUrl = createCodeUrl;
    }
    return _sharedUrl;
}

- (NSMutableArray *)sharedMenuItems {
    if (!_sharedMenuItems) {
        LYShareMenuItem *friendItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"friend_pr" itemTitle:DBHGetStringWithKeyFromTable(@"Moments", nil)];
        LYShareMenuItem *weixinItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"weixin_pr" itemTitle:DBHGetStringWithKeyFromTable(@"WeChat", nil)];
        LYShareMenuItem *qqItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"qq_pr" itemTitle:@"QQ"];
        LYShareMenuItem *telegramItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_telegram" itemTitle:@"Telegram"];
//        LYShareMenuItem *longImgShareItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_jietu1" itemTitle:DBHGetStringWithKeyFromTable(@"Screenshot", nil)];
        LYShareMenuItem *twitterShareItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_twitter" itemTitle:@"Twitter"];
        
        _sharedMenuItems = [NSMutableArray arrayWithObjects:friendItem, weixinItem, qqItem, telegramItem, twitterShareItem, nil];
    }
    return _sharedMenuItems;
}

@end
