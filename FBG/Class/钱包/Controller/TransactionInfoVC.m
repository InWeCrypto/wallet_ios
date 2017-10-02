//
//  TransactionInfoVC.m
//  FBG
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "TransactionInfoVC.h"
#import "YsLabel.h"
#import "EBTAttributeLinkClickLabel.h"
#import "KKWebView.h"

@interface TransactionInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *priceNameTiLB;
@property (weak, nonatomic) IBOutlet UILabel *transferAddTiLB;
@property (weak, nonatomic) IBOutlet UILabel *receivablesTiLB;
@property (weak, nonatomic) IBOutlet UILabel *exhangeTiLB;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTiLB;


@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *priceChangeLB;
@property (weak, nonatomic) IBOutlet UIImageView *priceChangeImage;
@property (weak, nonatomic) IBOutlet YsLabel *transferLB;
@property (weak, nonatomic) IBOutlet UILabel *receivablesLB;
@property (weak, nonatomic) IBOutlet UILabel *exhangeLB;
@property (weak, nonatomic) IBOutlet UILabel *arrivalLB;
@property (weak, nonatomic) IBOutlet EBTAttributeLinkClickLabel *orderNumLB;

@end

@implementation TransactionInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isTransfer ? NSLocalizedString(@"Transfer details", nil) : NSLocalizedString(@"Collection details", nil);  //转账详情
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    // 设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.priceChangeLB.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Additional service charge:", nil),@"0.0000000"];
    self.transferAddTiLB.text = NSLocalizedString(@"Transfer party wallet address", nil);
    self.receivablesTiLB.text = NSLocalizedString(@"Payee's wallet address", nil);
    self.exhangeTiLB.text = NSLocalizedString(@"Transaction time", nil);
    self.arrivalTiLB.text = @"备注";
    self.orderNumLB.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Order number:", nil),@"THC987899"];
    
    if (self.isTransfer)
    {
        //转账
        self.priceChangeLB.hidden = NO;
        self.priceChangeImage.hidden = NO;
        self.priceChangeImage.image = [UIImage imageNamed:@"icon_complete"];
        self.priceNameTiLB.text = @"转账金额";
        self.priceLB.text = [NSString stringWithFormat:@"-%.4f",[self.model.fee floatValue]];
    }
    else
    {
        //收款
        self.priceChangeLB.hidden = YES;
        self.priceChangeImage.hidden = YES;
        self.priceNameTiLB.text = @"收款金额";
        self.priceLB.text = [NSString stringWithFormat:@"+%.4f",[self.model.fee floatValue]];
//        self.priceChangeLB.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Additional service charge:", nil),self.model.handle_fee];
    }
    self.priceChangeImage.image = [UIImage imageNamed:@"icon_complete"];
    self.priceChangeLB.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Additional service charge:", nil),self.model.handle_fee];
    self.transferLB.text = self.model.pay_address;
    self.receivablesLB.text = self.model.receive_address;
    self.exhangeLB.text = self.model.created_at;
    self.arrivalLB.text = self.model.remark;
    self.orderNumLB.text = [NSString stringWithFormat:@"订单号:%@",self.model.trade_no];
    
    NSString *text = [NSString stringWithFormat:@"订单号:%@",self.model.trade_no];
    __weak typeof(self)weakSelf = self;
    [self.orderNumLB attributeLinkLabelText:text withLinksAttribute:nil  withActiveLinkAttributes:nil withLinkClickCompleteHandler:^(NSInteger linkedURLTag) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"linkedURLTag =%ld",linkedURLTag);
        
        NSString * url;
        if ([APP_APIEHEAD isEqualToString:@"https://ropsten.unichain.io/api/"])
        {
            //测试
            url = @"https://ropsten.etherscan.io/tx/";
        }
        else
        {
            //正式
            url = @"https://etherscan.io/tx/";
        }
        KKWebView * vc = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",url,strongSelf.model.trade_no]];
        vc.title = @"订单详情";
        [self.navigationController pushViewController:vc animated:YES];
    } withUnderLineTextString:[NSString stringWithFormat:@"订单号:%@",self.model.trade_no],nil];
    
}

- (void)back
{
    //返回
    if (self.isNotPushWithList)
    {
        //跳到钱包首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
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
