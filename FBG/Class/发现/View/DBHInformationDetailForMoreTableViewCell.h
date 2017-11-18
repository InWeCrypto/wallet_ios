//
//  DBHInformationDetailForMoreTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMoreButtonBlock)(NSString *url);

@interface DBHInformationDetailForMoreTableViewCell : UITableViewCell

/**
 数据源
 */
@property (nonatomic, copy) NSArray *dataSouce;

/**
 点击回调
 */
- (void)clickMoreButtonBlock:(ClickMoreButtonBlock)clickMoreButtonBlock;

@end
