//
//  ICOListCell.h
//  FBG
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICOOrderListModel.h"

@interface ICOListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titileLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;

@property (nonatomic, strong) ICOOrderListModel * model;

@end
