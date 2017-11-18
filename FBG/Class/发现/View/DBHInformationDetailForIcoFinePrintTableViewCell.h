//
//  DBHInformationDetailForIcoFinePrintTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickOfficialWebsiteBlock)();

@interface DBHInformationDetailForIcoFinePrintTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *icoArray;

/**
 点击官网回调
 */
- (void)clickOfficialWebsiteBlock:(ClickOfficialWebsiteBlock)clickOfficialWebsiteBlock;

@end
