//
//  DBHInformationDetailForTwitterTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTwitterBlock)();

@interface DBHInformationDetailForTwitterTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *twitter;

/**
 点击twitter回调
 */
- (void)clickTwitterBlock:(ClickTwitterBlock)clickTwitterBlock;

@end
