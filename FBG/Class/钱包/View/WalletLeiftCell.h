//
//  WalletLeiftCell.h
//  FBG
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletLeftListModel.h"

@interface WalletLeiftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;

@property (nonatomic, strong) WalletLeftListModel * model;

@end
