//
//  MonetaryUnitCell.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonetaryUnitModel.h"

@interface MonetaryUnitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@property (nonatomic, strong) MonetaryUnitModel * model;
@end
