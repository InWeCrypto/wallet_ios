//
//  YYRedPacketDetailHeaderView.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DETAIL_HEADERVIEW_HEIGHT 39.5

@interface YYRedPacketDetailHeaderView : UIView

- (void)setModel:(YYRedPacketDetailModel *)model redbagCellType:(RedBagCellType)cellType;

@end
