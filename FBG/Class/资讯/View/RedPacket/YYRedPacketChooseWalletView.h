//
//  YYRedPacketChooseWalletView.h
//  FBG
//
//  Created by yy on 2018/5/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYRedPacketChooseWalletView : UIView

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) SelectedWalletModelBlock block;

- (void)animationShow;

@end
