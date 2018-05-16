//
//  YYRedPacketPreviewViewController.h
//  FBG
//
//  Created by yy on 2018/4/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"


typedef enum _previewvc_from {
    PreViewVCFromSendRedPacket = 0,
    PreViewVCFromDetail,
    PreViewVCFromProtocol // 红包协议
}PreViewVCFrom ;

@interface YYRedPacketPreviewViewController : DBHBaseViewController

- (void)loadUrl:(NSString *)url;
@property (nonatomic, strong) YYRedPacketDetailModel *detailModel;
@property (nonatomic, assign) BOOL hideShareBtn;
@property (nonatomic, assign) PreViewVCFrom from;

@end
