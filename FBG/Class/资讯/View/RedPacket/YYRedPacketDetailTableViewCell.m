//
//  YYRedPacketDetailTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailTableViewCell.h"

@interface YYRedPacketDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@end

@implementation YYRedPacketDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsLastCellInSection:(BOOL)isLastCellInSection {
    if (_isLastCellInSection == isLastCellInSection) {
        return;
    }
    
    _isLastCellInSection = isLastCellInSection;
    self.bottomLineView.hidden = isLastCellInSection;
}

@end
