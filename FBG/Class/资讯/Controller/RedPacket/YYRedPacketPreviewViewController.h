//
//  YYRedPacketPreviewViewController.h
//  FBG
//
//  Created by yy on 2018/4/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@interface YYRedPacketPreviewViewController : DBHBaseViewController

@property (nonatomic, strong) YYRedPacketDetailModel *detailModel;
@property (nonatomic, assign) BOOL hideShareBtn;
- (void)loadUrl:(NSString *)url;

@end
