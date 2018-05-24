//
//  BlockBaseViewController.m
//  InWeCrypto
//
//  Created by 赵旭瑞 on 2018/5/21.
//  Copyright © 2018年 赵旭瑞. All rights reserved.
//

#import "BlockBaseViewController.h"

@interface BlockBaseViewController ()

@end

@implementation BlockBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)completionSelectBlock:(void (^)(id))finishBlock{
    self.selectblock=finishBlock;
}
-(void)keyToRightButton:(UIButton *)button{
    if(self.selectblock){
        self.selectblock(@{@"BOOL":@"YES"});
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
