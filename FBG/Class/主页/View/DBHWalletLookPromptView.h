//
//  DBHWalletLookPromptView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSInteger index);

@interface DBHWalletLookPromptView : UIView

/**
 查看的代币名称
 */
@property (nonatomic, copy) NSString *tokenName;

/**
 钱包列表
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 动画显示
 */
- (void)animationShow;

/**
 选择回调
 */
- (void)selectedBlock:(SelectedBlock)selectedBlock;

@end
