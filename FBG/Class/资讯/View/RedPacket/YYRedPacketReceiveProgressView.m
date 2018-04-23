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

@end

@implementation YYRedPacketReceiveProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _progressWidthConstaint.constant = 0;
        _progressLabel.text = @"";
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
