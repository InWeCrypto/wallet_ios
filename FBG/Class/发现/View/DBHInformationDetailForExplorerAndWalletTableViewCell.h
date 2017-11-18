//
//  DBHInformationDetailForExplorerAndWalletTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/16.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickExplorerOrWalletBlock)(NSString *url);

@interface DBHInformationDetailForExplorerAndWalletTableViewCell : UITableViewCell

/**
 explorer
 */
@property (nonatomic, copy) NSArray *leftDataSource;

/**
 wallet
 */
@property (nonatomic, copy) NSArray *rightDataSource;


/**
 点击回调
 */
- (void)clickExplorerOrWalletBlock:(ClickExplorerOrWalletBlock)clickExplorerOrWalletBlock;

@end
