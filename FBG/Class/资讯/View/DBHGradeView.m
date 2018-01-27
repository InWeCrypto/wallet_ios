//
//  DBHGradeView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHGradeView.h"

@implementation DBHGradeView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmugaikuang_xing"]];
        starImageView.tag = 200 + i;
        
        [self addSubview:starImageView];
        
        WEAKSELF
        [starImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(AUTOLAYOUTSIZE(8.5));
            if (!i) {
                make.left.equalTo(weakSelf);
            } else {
                make.left.equalTo([weakSelf viewWithTag:199 + i].mas_right).offset(AUTOLAYOUTSIZE(3.5));
            }
            make.centerY.equalTo(weakSelf);
        }];
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setGrade:(NSInteger)grade {
    _grade = grade;
    
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starImageView = [self viewWithTag:200 + i];
        starImageView.image = [UIImage imageNamed:i <= _grade - 1 ? @"xiangmugaikuang_xing_s" : @"xiangmugaikuang_xing"];
    }
}

@end
