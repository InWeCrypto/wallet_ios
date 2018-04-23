//
//  YYRedPacketSendFirstSection1Cell.m
//  FBG
//
//  Created by yy on 2018/4/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFirstSection1Cell.h"

@interface YYRedPacketSendFirstSection1Cell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation YYRedPacketSendFirstSection1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(id)data selectedIdentifier:(NSString *)selectedIdentifier {
//    if (selectedIdentifier.length > 0 && [selectedIdentifier isEqualToString:data.boxId]) { //被选择的
//        _selectBtn.selected = YES;
//    } else {
//        _selectBtn.selected = NO;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
