//
//  HomePageTableViewController.m
//  FBG
//
//  Created by 张海勇 on 2017/10/27.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "HomePageTableViewController.h"

@interface HomePageTableViewController ()

@end

@implementation HomePageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_info"] style:UIBarButtonItemStyleDone target:self action:@selector(messageButtonCilick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu"] style:UIBarButtonItemStyleDone target:self action:@selector(moreButtonCilick)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)messageButtonCilick {
    
}

- (void)moreButtonCilick {
    
}


@end
