//
//  WalletHeaderView.h
//  FBG
//
//  Created by mac on 2017/7/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletHeaderView : UIView

//@property (weak, nonatomic) IBOutlet UIButton *moreButton;
//@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *totleLB;
@property (weak, nonatomic) IBOutlet UILabel *ETH_etherLB;
@property (weak, nonatomic) IBOutlet UILabel *ETH_cnyLB;
@property (weak, nonatomic) IBOutlet UILabel *BTC_etherLB;
@property (weak, nonatomic) IBOutlet UILabel *BTC_cnyLB;

@end
