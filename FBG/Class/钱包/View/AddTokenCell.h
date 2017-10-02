//
//  AddTokenCell.h
//  FBG
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletInfoGntModel.h"

@interface AddTokenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *seletedImage;

@property (nonatomic, strong) WalletInfoGntModel * model;

@end
