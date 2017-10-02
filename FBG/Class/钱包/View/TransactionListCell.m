//
//  TransactionListCell.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "TransactionListCell.h"

@implementation TransactionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WalletOrderModel *)model
{
    _model = model;
    //收款的记录，数量用蓝色，转账的记录，数量用红色
    self.titleLB.text = model.trade_no;
    self.timeLB.text = [model.created_at substringFromIndex:5];
    self.infoLB.text = @"正在打包（0/12）";
    self.slider.value =  0.5;
    model.fee = [NSString stringWithFormat:@"%.4f",[[NSString DecimalFuncWithOperatorType:3 first:model.fee secend:@"1000000000000000000" value:4] floatValue]];
    model.handle_fee = [NSString stringWithFormat:@"%f",[[NSString DecimalFuncWithOperatorType:3 first:model.handle_fee secend:@"1000000000000000000" value:8] floatValue]];
    if (model.isReceivables)
    {
        //收款
        self.priceLB.text = [NSString stringWithFormat:@"+%.4f %@",[model.fee floatValue], [model.flag lowercaseString]];
        self.priceLB.textColor = [UIColor colorWithHexString:@"232772"];
        self.headImage.image = [UIImage imageNamed:@"转入"];
    }
    else
    {
        //转账
        self.priceLB.text = [NSString stringWithFormat:@"-%.4f %@",[model.fee floatValue], [model.flag lowercaseString]];
        self.priceLB.textColor = [UIColor redColor];
        self.headImage.image = [UIImage imageNamed:@"转出"];
    }
    
    
    switch (model.status)
    {
            //0交易失败,1准备打包,2打包中,3交易成功
        case 0:
        {
            self.headImage.image = [UIImage imageNamed:@"提示"];
            self.infoLB.text = @"交易失败";
            self.slider.hidden = YES;
            break;
        }
        case 1:
        {
            self.infoLB.text = @"正在打包";
            self.slider.value = 0;
            break;
        }
        case 2:
        {   //（当前块高-订单里的块高 + 1）/最小块高
            int number;
            
            if ([model.maxBlockNumber intValue] - [model.block_number intValue] + 1 < 0)
            {
                //小于0 置为0
                number = 0;
            }
            else
            {
                number = ([model.maxBlockNumber intValue] - [model.block_number intValue] + 1);
            }
            
            if (number >= [model.minBlockNumber intValue])
            {
                //大于1 交易成功
                self.slider.hidden = YES;
                self.infoLB.hidden = YES;
            }
            else
            {
                //小于1 打包过程
                self.infoLB.text = [NSString stringWithFormat:@"已经确认%d/%@",number,model.minBlockNumber];
                self.slider.value = number/[model.minBlockNumber floatValue];
            }
            
            break;
        }
        case 3:
        {
            self.slider.hidden = YES;
            self.infoLB.hidden = YES;
            break;
        }
        default:
            break;
    }
}

@end
