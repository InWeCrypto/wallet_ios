//
//  YYRedPacketHomeHeaderView.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketHomeHeaderView.h"

@interface YYRedPacketHomeHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *sendRedPacketBtn;

@end
@implementation YYRedPacketHomeHeaderView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        self.frame = frame;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.bgImgView.image = [UIImage imageNamed:DBHGetStringWithKeyFromTable(@"redpacket_home_bg_en", nil)];
}

- (IBAction)respondsSendRedPacketBtn:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
