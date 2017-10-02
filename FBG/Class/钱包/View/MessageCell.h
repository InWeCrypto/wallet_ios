//
//  MessageCell.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/9.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (nonatomic, strong) MessageModel * model;

@end
