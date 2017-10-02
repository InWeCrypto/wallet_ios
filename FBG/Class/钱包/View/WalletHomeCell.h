//
//  WalletHomeCell.h
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletInfoGntModel.h"

@interface WalletHomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *otherPriceLB;

@property (nonatomic, strong) WalletInfoGntModel * model;

@end
