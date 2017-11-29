//
//  DBHSearchView.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/21.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KeywordsUpdateBlock)(NSString *keywords);

@interface DBHSearchView : UIView

@property (nonatomic, strong) UITextField *searchTextField;

/**
 关键字改变回调
 */
- (void)keywordsUpdateBlock:(KeywordsUpdateBlock)keywordsUpdateBlock;

@end
