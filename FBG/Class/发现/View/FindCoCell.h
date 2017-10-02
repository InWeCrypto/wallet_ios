//
//  FindCoCell.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindIcoModel.h"

@interface FindCoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (nonatomic, strong) FindIcoModel * model;

@end
