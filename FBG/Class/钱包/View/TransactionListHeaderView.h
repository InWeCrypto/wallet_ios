//
//  TransactionListHeaderView.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/25.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *cnyPriceLB;

@end
