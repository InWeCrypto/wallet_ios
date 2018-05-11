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
        make.center.equalTo(weakSelf.progessSuperView);
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
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Done", nil));
                break;
            }
                
            case RedBagStatusCashPackaging: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packet preparation successful", nil));
                break;
            }
                
            case RedBagStatusCreating: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Red Packet creation successful", nil));
                break;
            }
            
            case RedBagStatusCashAuthPending: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Packaging Assets", nil));
                break;
            }
            case RedBagStatusCreatePending: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Creating Red Packet", nil));
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
        
        NSString *openedRedBag = openedModel.redbag.redbag;
        
        [self showProgressView:NO];
        RedBagLotteryStatus status = openedModel.redbag.done;
        switch (status) {
            case RedBagLotteryStatusHad: { // 已开奖
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Launched", nil));
                
                NSString *number = [NSString notRounding:openedRedBag afterPoint:4];
                self.priceLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, openedModel.redbag.redbag_symbol];
                break;
            }
            case RedBagLotteryStatusWait: { // 待开奖
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"To be launched", nil));
                self.priceLabel.text = [NSString stringWithFormat:@"???%@", openedModel.redbag.redbag_symbol];
                break;
            }
            case RedBagLotteryStatusEnd: { // 开奖结束
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@" Ended ", nil));
                
                NSString *number = [NSString notRounding:openedRedBag afterPoint:4];
                self.priceLabel.text = [NSString stringWithFormat:@"%.4lf%@", number.doubleValue, openedModel.redbag.redbag_symbol];
                break;
            }
        }
    }
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
        make.center.equalTo(weakSelf.progessSuperView);
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
