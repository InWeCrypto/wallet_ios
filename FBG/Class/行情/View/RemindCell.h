//
//  RemindCell.h
//  FBG
//
//  Created by mac on 2017/7/28.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindModel.h"

@protocol RemindCellDelegate <NSObject>

- (void)priceChangeUpper_limit:(NSString *)upper_limit lower_limit:(NSString *)lower_limit cell:(UITableViewCell *)cell;

@end

@interface RemindCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UITextField *uppTF;
@property (weak, nonatomic) IBOutlet UITextField *downTF;
@property (weak, nonatomic) IBOutlet UIImageView *seletedImage;

@property (nonatomic, strong) id <RemindCellDelegate> delegate;

@property (nonatomic, strong) RemindModel * model;

@end
