//
//  ICOCell.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICOListModel.h"

@interface ICOCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (nonatomic, strong) ICOListModel * model;

@end
