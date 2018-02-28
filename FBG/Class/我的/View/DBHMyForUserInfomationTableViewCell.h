//
//  DBHMyForUserInfomationTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@interface DBHMyForUserInfomationTableViewCell : DBHBaseTableViewCell

/**
 头像
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 昵称
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 账号
 */
@property (nonatomic, strong) UILabel *accountLabel;

@end
