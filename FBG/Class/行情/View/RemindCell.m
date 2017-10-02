//
//  RemindCell.m
//  FBG
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "RemindCell.h"

@implementation RemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.uppTF.layer.cornerRadius = 8;
    self.downTF.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RemindModel *)model
{
    _model = model;
    
    self.titleLB.text = model.name;
    self.nameLB.text = model.source;
    if ([UserSignData share].user.walletUnitType == 1)
    {
        self.priceLB.text = [NSString stringWithFormat:@"￥%.2f",[model.relationCap.price_cny floatValue]];
    }
    else
    {
        self.priceLB.text = [NSString stringWithFormat:@"￥%.2f",[model.relationCap.price_usd floatValue]];
    }
    self.uppTF.text = model.relation_notification.upper_limit;
    self.downTF.text = model.relation_notification.lower_limit;
    if (model.isDelate)
    {
        self.seletedImage.hidden = NO;
        
        if (model.relation_notification_count == 0)
        {
            self.seletedImage.image = [UIImage imageNamed:@"list_btn_default"];
        }
        else
        {
            self.seletedImage.image = [UIImage imageNamed:@"list_btn_selected"];
        }
    }
    else
    {
        self.seletedImage.hidden = YES;
    }
    
    if (model.isEdit)
    {
        self.uppTF.userInteractionEnabled = YES;
        self.downTF.userInteractionEnabled = YES;
    }
    else
    {
        self.uppTF.userInteractionEnabled = NO;
        self.downTF.userInteractionEnabled = NO;
    }
}

- (IBAction)upTFend:(id)sender
{
    [self changePrice];
}

- (IBAction)lowTFend:(id)sender
{
    [self changePrice];
}

- (void)changePrice
{
    if ([self.delegate respondsToSelector:@selector(priceChangeUpper_limit:lower_limit:cell:)])
    {
        [self.delegate priceChangeUpper_limit:self.uppTF.text lower_limit:self.downTF.text cell:self];
    }
}

@end
