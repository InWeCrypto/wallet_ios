//
//  DBHExtractTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/12/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UnfreezeBlock)();

@class WalletInfoGntModel;

@interface DBHExtractTableViewCell : UITableViewCell

@property (nonatomic, strong) WalletInfoGntModel *model;

/**
 解冻回调
 */
- (void)unfreezeBlock:(UnfreezeBlock)unfreezeBlock;

@end
