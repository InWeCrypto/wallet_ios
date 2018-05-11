//
//  YYRedPacketChooseWalletTableViewCell.m
//  FBG
//
//  Created by yy on 2018/5/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketChooseWalletTableViewCell.h"

@interface YYRedPacketChooseWalletTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end

@implementation YYRedPacketChooseWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (void)setModel:(DBHWalletManagerForNeoModelList *)model currentWalletID:(NSInteger)currentWalletID {
    self.addrLabel.text = model.address;
    self.nameLabel.text = model.name;
    
    if (currentWalletID == model.listIdentifier) {
        self.selectedBtn.selected = YES;
    } else {
        self.selectedBtn.selected = NO;
    }
}

@end
