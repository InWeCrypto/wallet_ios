//
//  QuotationCell.h
//  FBG
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuotationModel.h"

@interface QuotationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *usdLB;
@property (weak, nonatomic) IBOutlet UILabel *rmbLB;
@property (weak, nonatomic) IBOutlet UILabel *changeLB;
@property (weak, nonatomic) IBOutlet UILabel *hightLB;
@property (weak, nonatomic) IBOutlet UILabel *lowLB;
@property (weak, nonatomic) IBOutlet UILabel *numberLB;

@property (nonatomic, strong) QuotationModel * model;
@end
