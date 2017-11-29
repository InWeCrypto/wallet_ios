//
//  DBHInformationForNewsCollectionViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMoreButtonBlock)();
typedef void(^ClickNewsBlock)(NSString *url);

@interface DBHInformationForNewsCollectionViewCell : UICollectionViewCell

/**
 新闻数据
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 点击更多回调
 */
- (void)clickMoreButtonBlock:(ClickMoreButtonBlock)clickMoreButtonBlock;

/**
 点击新闻回调
 */
- (void)clickNewsBlock:(ClickNewsBlock)clickNewsBlock;

@end
