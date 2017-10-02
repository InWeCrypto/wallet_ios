//
//  AddWalletChoseTypeCell.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletTypeModel.h"

@interface AddWalletChoseTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icoHeadeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@property (nonatomic, strong) WalletTypeModel * model;

@end
