//
//  WalletInfoHeaderView.h
//  FBG
//
//  Created by mac on 2017/7/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletInfoHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *addTokenButton;
@property (weak, nonatomic) IBOutlet UIImageView *ETHImage;
@property (weak, nonatomic) IBOutlet UILabel *ETHcnyLB;
@property (weak, nonatomic) IBOutlet UIButton *ETHButton;
@property (weak, nonatomic) IBOutlet UILabel *ETHpriceLB;
@end
