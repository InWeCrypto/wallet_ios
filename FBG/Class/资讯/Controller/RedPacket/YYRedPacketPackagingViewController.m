//
//  YYRedPacketPackagingViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketPackagingViewController.h"
#import "YYRedPacketSendSecondViewController.h"
#import "YYRedPacketSendThirdViewController.h"
#import "LDProgressView.h"
#import "SystemConvert.h"

@interface YYRedPacketPackagingViewController () {
    dispatch_queue_t queue;
    dispatch_group_t group;
    dispatch_source_t timer;
    
    BOOL isExitCurrentUI;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *backToHomeBtn;
@property (weak, nonatomic) IBOutlet UILabel *afterTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet LDProgressView *progress;

@property (nonatomic, copy) NSString * minBlockNumber;  //最小块高 确认 12
@property (nonatomic, assign) NSString *currentBlockNumber;  //当前块高
@property (nonatomic, copy) NSString * blockPerSecond;  //发生时间  5

@property (nonatomic, assign) BOOL isHaveNoFinishOrder;

@end

@implementation YYRedPacketPackagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self getData];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isExitCurrentUI = NO;
    
    [self redPacketNavigationBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    isExitCurrentUI = YES;
    if (timer) {
        dispatch_suspend(timer);
        dispatch_source_cancel(timer);
    }
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send Red Packet", nil);
    
    if (self.packageType == PackageTypeCash) {
        self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Packaging Assets", nil);
    } else {
        self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Creating Red Packet", nil);
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"(%@)", DBHGetStringWithKeyFromTable(@"Waiting for Confirmation", nil)];
    self.afterTipLabel.text = DBHGetStringWithKeyFromTable(@"Check Red Packets Creation Later", nil);
    [self.backToHomeBtn setTitle:DBHGetStringWithKeyFromTable(@"Back To the Red Packet Home Page", nil) forState:UIControlStateNormal];
    
    [self.nextBtn setTitle:DBHGetStringWithKeyFromTable(@"Next", nil) forState:UIControlStateNormal];
    
    [self.nextBtn setCorner:2];
    [self.nextBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    [self.nextBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    
    CALayer *layer = [CALayer layer];
    self.nextBtn.enabled = NO;
    if (self.packageType == PackageTypeCash) {
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.25, 4);
    } else {
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 4);
    }
    
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    
    self.progress.progress = 0.0f;
    self.progress.showText = @0;
}


#pragma mark ------- Data ---------
- (void)getData {
    // 创建全局并行
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self loadMinblockNumber];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self getBlockPerSecond];
    });
    
    dispatch_group_notify(group, queue, ^{
        self.isHaveNoFinishOrder = YES;
        
        BOOL pending = NO;
        if (self.model.auth_block == 0) {
            pending = YES;
        }
        
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW,
                                  self.blockPerSecond.floatValue * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^() {
            if (pending) {
                [self getDetailData];
            } else {
                [self loadCurrentblockNumber];
            }
        });
        dispatch_resume(timer);
    });
}

//获取红包详情
- (void)getDetailData {
    NSString *urlStr = [NSString stringWithFormat:@"redbag/send_record/%ld", self.model.redPacketId];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
            [weakSelf handleResponseObj:responseObject type:3];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
    });
}

//获取最小块高  默认12
- (void)loadMinblockNumber {
    WEAKSELF
    [PPNetworkHelper GET:@"min-block" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:0];
    } failure:^(NSString *error) {
        dispatch_group_leave(group);
    }];
}

/**
 获取轮询时间
 */
- (void)getBlockPerSecond {
    WEAKSELF
    //获取轮询时间 当前块发生速度  最小5秒
    [PPNetworkHelper POST:@"extend/blockPerSecond" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:1];
    } failure:^(NSString *error) {
        dispatch_group_leave(group);
    }];
}

//当前当前块号
- (void)loadCurrentblockNumber {
    if (!self.isHaveNoFinishOrder) {
        dispatch_suspend(timer);
        dispatch_source_cancel(timer);
        
        return;
    }
    
    WEAKSELF
    [PPNetworkHelper POST:@"extend/blockNumber" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:2];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}


- (void)handleResponseObj:(id)responseObj type:(NSInteger)type {
    if ([NSObject isNulllWithObject:responseObj] || isExitCurrentUI) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (type == 0) { // 最小块高
            self.minBlockNumber = [responseObj objectForKey:MIN_BLOCK_NUM];
            dispatch_group_leave(group);
        } else if (type == 1) { // 轮询时间
            self.blockPerSecond = [NSString stringWithFormat:@"%f", 1 / [[responseObj objectForKey:BPS] floatValue]];
            dispatch_group_leave(group);
        } else if (type == 2) { // 当前块高
            NSString *value = [responseObj objectForKey:VALUE];
            if (value.length > 2) {
                value = [value substringFromIndex:2];
                self.currentBlockNumber = [NSString stringWithFormat:@"%@",[NSString numberHexString:value]];
                
                //（当前块高 - 订单里的块高 + 1）/最小块高
                NSInteger secondValue = self.model.auth_block;
                if (self.packageType == PackageTypeRedPacket) { // 创建红包
                    secondValue = self.model.redbag_block;
                }
                NSInteger number = self.currentBlockNumber.integerValue - secondValue + 1;
                if (number < 0) {
                    //小于0 置为0
                    number = 0;
                }
                
                if (number < self.minBlockNumber.integerValue) {
                    self.isHaveNoFinishOrder = YES;
                } else {
                    number = self.minBlockNumber.integerValue;
                    self.isHaveNoFinishOrder = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.nextBtn.enabled = YES;
                    });
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.statusLabel.text = [NSString stringWithFormat:@"(%@%ld/%@)", DBHGetStringWithKeyFromTable(@"Confirmed", nil), number, self.minBlockNumber];
                    self.progress.progress = (CGFloat)number / self.minBlockNumber.floatValue;
                });
            }
        } else if (type == 3) { // 红包详情
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                YYRedPacketDetailModel *model = [YYRedPacketDetailModel mj_objectWithKeyValues:responseObj];
                self.model = model;
                
                RedBagStatus status = model.status;
                if (self.packageType == PackageTypeCash) { // 礼金打包
                    if (status == RedBagStatusCashAuthPending) { // 授权pending中
                        dispatch_suspend(timer);
                        dispatch_source_set_event_handler(timer, ^{
                            [self getDetailData]; // 获取红包详情
                        });
                        dispatch_resume(timer);
                    } else if (status == RedBagStatusCashPackageFailed) { // 授权失败
                        dispatch_suspend(timer);
                        dispatch_source_cancel(timer);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Authorization failed", nil)];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    } else if (status == RedBagStatusCashPackaging) { // 打包中
                        if (model.auth_block == 0) { // 授权块高为0
                            dispatch_suspend(timer);
                            dispatch_source_set_event_handler(timer, ^{
                                [self getDetailData]; // 获取红包详情
                            });
                            dispatch_resume(timer);
                        } else { // 授权块高不为0
                            dispatch_suspend(timer);
                            dispatch_source_set_event_handler(timer, ^{
                                [self loadCurrentblockNumber];
                            });
                            dispatch_resume(timer);
                        }
                    }
                } else if (self.packageType == PackageTypeRedPacket) { // 红包创建
                    if (status == RedBagStatusCreatePending) { // 创建pending中
                        dispatch_suspend(timer);
                        dispatch_source_set_event_handler(timer, ^{
                            [self getDetailData]; // 获取红包详情
                        });
                        dispatch_resume(timer);
                    } else if (status == RedBagStatusCreateFailed) { // 创建失败
                        dispatch_suspend(timer);
                        dispatch_source_cancel(timer);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Creation Failed", nil)];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    } else if (status == RedBagStatusCreating) { // 创建中
                        if (model.redbag_block == 0) { // 红包块高为0
                            dispatch_suspend(timer);
                            dispatch_source_set_event_handler(timer, ^{
                                [self getDetailData]; // 获取红包详情
                            });
                            dispatch_resume(timer);
                        } else { // 授权块高不为0
                            dispatch_suspend(timer);
                            dispatch_source_set_event_handler(timer, ^{
                                [self loadCurrentblockNumber];
                            });
                            dispatch_resume(timer);
                        }
                    }
                }
            }
        }
    });
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToBackToHomeBtn:(UIButton *)sender {
    self.backIndex = 2;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)respondsToNextBtn:(UIButton *)sender {
    if (self.packageType == PackageTypeCash) {
        YYRedPacketSendSecondViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_SECOND_STORYBOARD_ID];
        vc.model = self.model;
        vc.ethWalletsArray = self.ethWalletsArray;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        YYRedPacketSendThirdViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_THIRD_STORYBOARD_ID];
        vc.model = self.model;
        vc.ethWalletsArray = self.ethWalletsArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
