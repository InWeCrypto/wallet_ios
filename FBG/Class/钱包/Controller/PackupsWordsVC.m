//
//  PackupsWordsVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/29.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "PackupsWordsVC.h"
#import "SurePackupsWordVC.h"

@interface PackupsWordsVC ()

@property (weak, nonatomic) IBOutlet UITextView *mnemonicTextView;

@end

@implementation PackupsWordsVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"备份助记词";
    self.mnemonicTextView.text = self.mnemonic;
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)sureButtonCilick:(id)sender
{
    //我记好了，下一步
    SurePackupsWordVC * vc = [[SurePackupsWordVC alloc] init];
    vc.mnemonic = self.mnemonic;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter





@end
