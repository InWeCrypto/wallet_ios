//
//  YYRedPacketReceiveProgressView.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketReceiveProgressView.h"

@interface YYRedPacketReceiveProgressView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidthConstaint;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *ingLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingHeightConstraint;

@end

@implementation YYRedPacketReceiveProgressView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ingLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Openning", nil));
    self.progressWidthConstaint.constant = 0;
    self.progressLabel.text = @"";
}

- (void)setIsShowOpening:(BOOL)isShowOpening {
    _isShowOpening = isShowOpening;
    
    _ingHeightConstraint.constant = isShowOpening ? 15 : 0;
}

- (void)setProgress:(NSInteger)progress total:(NSInteger)total {
    self.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", progress, total];
    CGFloat width = self.bgView.width;
    
    CGFloat value = (CGFloat)progress / (CGFloat)total;
    self.progressWidthConstaint.constant = width * value;
}

@end
