//
//  DBHSearchViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSearchViewController.h"

#import "DBHSearchTitleView.h"

@interface DBHSearchViewController ()

@property (nonatomic, strong) DBHSearchTitleView *searchTitleView;

@end

@implementation DBHSearchViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = self.searchTitleView;
}

#pragma mark ------ Getters And Setters ------
- (DBHSearchTitleView *)searchTitleView {
    if (!_searchTitleView) {
        _searchTitleView = [[DBHSearchTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
//        _searchTitleView.intrinsicContentSize = CGSizeMake(SCREENWIDTH, 44);
    }
    return _searchTitleView;
}

@end
