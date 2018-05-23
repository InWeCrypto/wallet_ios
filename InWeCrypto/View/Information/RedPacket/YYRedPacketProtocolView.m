//
//  YYRedPacketProtocolView.m
//  FBG
//
//  Created by yy on 2018/5/14.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketProtocolView.h"

@interface YYRedPacketProtocolView()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation YYRedPacketProtocolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        self.frame = frame;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = COLORFROM16(0x323232, 0.8);
    [self.sureBtn setTitle:DBHGetStringWithKeyFromTable(@"Watch1", nil) forState:UIControlStateNormal];
    
    NSString *infoStr = DBHGetStringWithKeyFromTable(@"Please Read Carefully 《InWeCrypto Red Packet Use Agreement》 Please read and make sure you understand all the terms of the agreement.", nil);
    
    NSMutableAttributedString *allAttrStr = [[NSMutableAttributedString alloc] initWithString:infoStr];
    //设置下划线
    NSString *underlineStr = [NSString stringWithFormat:@"《%@》", DBHGetStringWithKeyFromTable(@"InWeCrypto Red Packet Use Agreement", nil)];
    
    NSRange range = [allAttrStr.string rangeOfString:underlineStr];
    [allAttrStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];//下划线
    //下划线颜色
    [allAttrStr addAttribute:NSUnderlineColorAttributeName value:self.infoLabel.textColor range:range];
    
    self.infoLabel.attributedText = allAttrStr;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(3.0f, 3.0f)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _sureBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _sureBtn.layer.mask = maskLayer;
}

- (IBAction)respondsToSureBtn:(UIButton *)sender {
    [self removeFromSuperview];
    
    if (self.block) {
        self.block();
    }
}

@end
