//
//  YYRedPacketReceiveProgressView.h
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYRedPacketReceiveProgressView : UIView

@property (nonatomic, assign) BOOL isShowOpening;
- (void)setProgress:(NSInteger)progress total:(NSInteger)total;

@end
