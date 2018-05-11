//
//  YYRedPacketOpenViewController.m
//  FBG
//
//  Created by yy on 2018/5/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketOpenViewController.h"
#import "YYRedPacketChooseWalletView.h"
#import "YYRedPacketSuccessViewController.h"

@interface YYRedPacketOpenViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *tip1Label;
@property (weak, nonatomic) IBOutlet UILabel *tip2Label;

@property (nonatomic, strong) YYRedPacketChooseWalletView *chooseWalletView;

@property (nonatomic, assign) NSInteger redBagID;
@property (nonatomic, copy) NSString *redBagAddr;
@property (nonatomic, copy) NSString *sharedUser;
@property (nonatomic, strong) NSMutableArray *ethWalletsArray;

@end

@implementation YYRedPacketOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self setData];
}

- (void)setUI {
    self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Open the Red Packet and Mining ", nil);
    
    self.tip1Label.text = DBHGetStringWithKeyFromTable(@"The technology is provided by", nil);
    self.tip2Label.text = DBHGetStringWithKeyFromTable(@"   ", nil);
}

- (void)setData {
    self.sharedUser = @"";
    
    if (![NSObject isNulllWithObject:self.urlStr]) {
        NSString *urlStr = [self.urlStr stringByRemovingPercentEncoding];
        
        NSString *tempURL = TEST_REDPACKET_CREATE_CODE;
        if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
            tempURL = REDPACKET_CREATE_CODE;
        }
        
        tempURL = [tempURL stringByAppendingString:@"redbag/"];
        
        if ([urlStr containsString:tempURL]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:tempURL withString:@""];
        }
        
        NSArray *arr1 = [urlStr componentsSeparatedByString:@"?"];
        if (arr1.count > 1) {
            NSString *str1 = arr1[0];
            NSArray *arr2 = [str1 componentsSeparatedByString:@"/"];
            if (arr2.count > 1) {
                NSString *redbagIdStr = arr2[0];
                self.redBagID = redbagIdStr.integerValue;
                self.redBagAddr = arr2[1];
            }
            
            NSString *paramsStr = arr1[1];
            NSArray *params = [paramsStr componentsSeparatedByString:@"&"];
            if (params.count > 0) {
                NSString *str2 = params[0];
                NSArray *arr3 = [str2 componentsSeparatedByString:@"="];
                if (arr3.count > 1) {
                    self.sharedUser = arr3[1];
                }
            }
        }
    }
    
    if (self.model) {
        self.redBagID = self.model.redbag_id;
        self.redBagAddr = self.model.redbag_addr;
        self.sharedUser = self.model.share_user;
    }
    
    self.senderLabel.text = [self.sharedUser stringByAppendingString:DBHGetStringWithKeyFromTable(@" Send you a Red Packet", nil)];
}

#pragma mark ------- Data ---------
/**
 获取钱包列表
 */
- (void)getWalletList {
    if (![UserSignData share].user.isLogin) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            [weakSelf walletListResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD hide];
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
    });
}
/**
 钱包列表的返回处理
 
 @param responseObj 返回体
 */
- (void)walletListResponse:(id)responseObj {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSMutableArray *tempArr = nil;
        BOOL isHasData = NO;
        if (![NSObject isNulllWithObject:responseObj]) {
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                NSArray *list = responseObj[LIST];
                
                if (![NSObject isNulllWithObject:list] && list.count != 0) { // 不为空
                    tempArr = [NSMutableArray array];
                    isHasData = YES;
                    for (NSDictionary *dict in list) {
                        @autoreleasepool {
                            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dict];
                            
                            NSString *data = [NSString keyChainDataFromKey:model.address isETH:YES];
                            
                            BOOL isLookWallet = [NSString isNulllWithObject:data];
                            if (model.categoryId == 1) { //ETH
                                model.isLookWallet = isLookWallet;
                                model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
                                [tempArr addObject:model];
                            }
                        }
                    }
                }
            }
        }
        self.ethWalletsArray = tempArr;
    });
}

#pragma mark ---- data -----
- (void)openRedPacket:(DBHWalletManagerForNeoModelList *)wallet {
    NSString *urlStr = [NSString stringWithFormat:@"redbag/draw/%ld/%@", self.redBagID, self.redBagAddr];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSString *addr = wallet.address;
        if ([NSObject isNulllWithObject:addr]) {
            addr = @"";
        }
        NSDictionary *params = @{@"wallet_addr" : addr};
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            [weakSelf handleResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
    });
}

- (void)handleResponse:(id)responseObj {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        YYRedPacketOpenedModel *model = [YYRedPacketOpenedModel mj_objectWithKeyValues:responseObj];
        
        YYRedPacketSuccessViewController *vc = [[UIStoryboard storyboardWithName:REDPACKET_STORYBOARD_NAME bundle:nil] instantiateViewControllerWithIdentifier:REDPACKET_SUCCESS_STORYBOARD_ID];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToOpenBtn:(UIButton *)sender { // 拆红包
    [self getWalletList];
}

#pragma mark ----- Setters And Getters ---------
- (void)setEthWalletsArray:(NSMutableArray *)ethWalletsArray {
    _ethWalletsArray = ethWalletsArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ethWalletsArray.count == 0) {
            [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"You don’t have a ETH wallet, please add one.", nil)];
        } else {
            self.chooseWalletView.dataSource = ethWalletsArray;
            [[UIApplication sharedApplication].keyWindow addSubview:self.chooseWalletView];
            
            WEAKSELF
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.chooseWalletView animationShow];
            });
        }
    });
}

- (YYRedPacketChooseWalletView *)chooseWalletView {
    if (!_chooseWalletView) {
        _chooseWalletView = [[YYRedPacketChooseWalletView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        WEAKSELF
        [_chooseWalletView setBlock:^(DBHWalletManagerForNeoModelList *model) {
            [weakSelf openRedPacket:model];
        }];
    }
    return _chooseWalletView;
}

@end
