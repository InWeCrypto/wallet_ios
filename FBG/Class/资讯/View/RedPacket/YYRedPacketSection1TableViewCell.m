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
@property (weak, nonatomic) IBOutlet YYRedPacketReceiveProgressView *progessView;

@end

@implementation YYRedPacketSection1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
