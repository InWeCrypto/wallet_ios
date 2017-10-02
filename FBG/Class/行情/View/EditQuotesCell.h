//
//  EditQuotesCell.h
//  FBG
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuotationModel.h"

@interface EditQuotesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;

@property (nonatomic, strong) QuotationModel * model;

@end
