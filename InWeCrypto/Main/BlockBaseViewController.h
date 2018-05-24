//
//  BlockBaseViewController.h
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/21.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import "BaseViewController.h"

@interface BlockBaseViewController : BaseViewController
-(void)completionSelectBlock:(void(^)(id))finishBlock;
typedef void(^SelectBaseBlock)(id);
@property (nonatomic, copy)SelectBaseBlock selectblock;
@end
