//
//  YYRedPacketSection1TableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSection1TableViewCell.h"
#import "YYRedPacketReceiveProgressView.h"

@interface YYRedPacketSection1TableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *redPacketNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *progessSuperView;

@property (strong, nonatomic) YYRedPacketReceiveProgressView *progressView;

@end

@implementation YYRedPacketSection1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.statusLabel setBorderWidth:1 color:COLORFROM16(0xED7421, 1)];
    [self.progessSuperView addSubview:self.progressView];
    
    WEAKSELF
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(weakSelf.progessSuperView);
        make.width.height.offset(44);
        make.left.greaterThanOrEqualTo(weakSelf.progessSuperView);
    }];
}

- (void)setModel:(id)model from:(CellFrom)from {
    if (from == CellFromSentHistory && [model isKindOfClass:[YYRedPacketDetailModel class]]) {
        YYRedPacketDetailModel *detailModel = model;
        self.redPacketNoLabel.text = detailModel.redbag_addr;
        
        NSString *number = [NSString notRounding:detailModel.redbag afterPoint:4];
        self.priceLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, detailModel.redbag_symbol];
        
        switch (detailModel.status) {
            case RedBagStatusDone: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Completed", nil));
                break;
            }
                
            case RedBagStatusCashPackaging: {
                [self showProgressView:NO];
                
                // 礼金打包中
                NSString *statusStr = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packaging Assets", nil));
                if (detailModel.auth_block != 0) {
                    NSInteger block = detailModel.current_block - detailModel.auth_block + 1;
                    if (block >= 12) { // 礼金打包成功
                        statusStr = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packet preparation sucessful", nil));
                    }
                }
                
                self.statusLabel.text = statusStr;
                
                break;
            }
                
            case RedBagStatusCreating: {
                [self showProgressView:NO];
                // 红包创建中
                NSString *statusStr = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creating Red Packet", nil));
                if (detailModel.redbag_block != 0) {
                    NSInteger block = detailModel.current_block - detailModel.redbag_block + 1;
                    if (block >= 12) { // 红包创建成功
                        statusStr = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Red Packet creation successful", nil));
                    }
                }
                
                self.statusLabel.text = statusStr;
                
                break;
            }
                
            case RedBagStatusCashAuthPending: { // 准备礼金打包
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@" Packing… ", nil));
                break;
            }
            case RedBagStatusCreatePending: { // 准备创建红包
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creating the Red Packet", nil));
                break;
            }
                
            case RedBagStatusOpening: {
                [self showProgressView:YES];
                [self.progressView setProgress:detailModel.draw_redbag_number total:detailModel.redbag_number];
                break;
            }
                
                
            case RedBagStatusCashPackageFailed: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packing Failed", nil));
                break;
            }
                
            case RedBagStatusCreateFailed: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creation Failed", nil));
                break;
            }
        }
    } else if (from == CellFromOpenedHistory && [model isKindOfClass:[YYRedPacketOpenedModel class]]) {
        YYRedPacketOpenedModel *openedModel = model;
        
        self.redPacketNoLabel.text = openedModel.draw_addr;
        
        [self showProgressView:NO];
        RedBagLotteryStatus status = openedModel.redbag.done;
        NSString *price = [NSString stringWithFormat:@"???%@", openedModel.redbag.redbag_symbol];
        switch (status) {
            case RedBagLotteryStatusHad: { // 已开奖
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"To be launched", nil));
                self.priceLabel.text = price;
                break;
            }
            case RedBagLotteryStatusWait: { // 待开奖
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"To be launched", nil));
                self.priceLabel.text = price;
                break;
            }
            case RedBagLotteryStatusEnd: { // 开奖结束
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Launched", nil));
                
                NSString *value = openedModel.value;
                if (![value isEqualToString:@"-"]) { // 领取金额已知
                    NSString *drawValue = [NSString convertValue:value decimals:openedModel.redbag.gnt_category.decimals];
                    
                    NSString *number = [NSString notRounding:drawValue afterPoint:4];
                    price = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, openedModel.redbag.redbag_symbol];
                }
                self.priceLabel.text = price;
                
                break;
            }
        }
    }
    
    [self.contentView layoutIfNeeded];
}

- (void)showProgressView:(BOOL)isShow {
    self.progressView.hidden = !isShow;
    
    self.statusLabel.hidden = isShow;
    
    if (!isShow) {
        return;
    }
    
    self.progressView.isShowOpening = self.isShowOpening;
    
    WEAKSELF
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(weakSelf.progessSuperView);
        make.width.offset(44);
        make.height.offset(self.isShowOpening ? 44 : 29);
        make.left.greaterThanOrEqualTo(weakSelf.progessSuperView);
    }];
}

#pragma mark ----- Setters And Getters ---------
- (YYRedPacketReceiveProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[YYRedPacketReceiveProgressView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}

@end
