//
//  ICOInfoVC.m
//  FBG
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ICOInfoVC.h"
#import "ICOOrderListModel.h"

@interface ICOInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *infoTiLB;
@property (weak, nonatomic) IBOutlet UILabel *reWalletAddressTiLB;
@property (weak, nonatomic) IBOutlet UILabel *orderAddressTiLB;
@property (weak, nonatomic) IBOutlet UILabel *orderDateTiLB;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleTiLB;

@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *reWalletAddressLB;
@property (weak, nonatomic) IBOutlet UILabel *orderAddressLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLB;

@end

@implementation ICOInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ico订单详情";
    
    [PPNetworkHelper GET:[NSString stringWithFormat:@"ico-order/%@",self.id] parameters:nil hudString:@"获取中..." success:^(id responseObject)
    {
        ICOOrderListModel * model = [[ICOOrderListModel alloc] initWithDictionary:[responseObject objectForKey:@"record"]];
        model.title = [[[responseObject objectForKey:@"record"] objectForKey:@"ico"] objectForKey:@"title"];
        model.cny = [[[responseObject objectForKey:@"record"] objectForKey:@"ico"] objectForKey:@"cny"];
        
        self.priceLB.text = [NSString stringWithFormat:@"-%@",model.fee];
        self.typeLB.text = [NSString stringWithFormat:@"众筹币种:%@",model.cny];
        self.reWalletAddressLB.text = model.pay_address;
        self.orderAddressLB.text = model.receive_address;
        self.dateLB.text = model.created_at;
        self.orderTitleLB.text = model.title;
        self.orderCodeLB.text = [NSString stringWithFormat:@"交易单号:%@",model.trade_no];
        
    } failure:^(NSString *error)
    {
        [LCProgressHUD showFailure:error];
    }];
}



@end
