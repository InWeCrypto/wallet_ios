//
//  YYRedPacketChoosePayStyleView.h
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYRedPacketChoosePayStyleView : UIView

typedef void(^SelectedWalletModelBlock)(id model); //YYTODO

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) SelectedWalletModelBlock block;

- (void)animationShow;

@end
