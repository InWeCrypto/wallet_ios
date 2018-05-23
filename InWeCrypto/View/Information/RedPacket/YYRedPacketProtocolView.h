//
//  YYRedPacketProtocolView.h
//  FBG
//
//  Created by yy on 2018/5/14.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock) ();

@interface YYRedPacketProtocolView : UIView

@property (nonatomic, copy) ClickBlock block;

@end
