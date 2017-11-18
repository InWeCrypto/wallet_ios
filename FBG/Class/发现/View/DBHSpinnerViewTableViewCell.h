//
//  DBHSpinnerViewTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/17.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHSpinnerViewTableViewCell : UITableViewCell

/**
 标题
 */
@property (nonatomic, copy) NSString *title;


/**
 是否隐藏分隔线
 */
@property (nonatomic, assign) BOOL isHiddenBottomLineView;

@end
