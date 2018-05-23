//
//  YYRedPacketChooseWalletTableViewCell.h
//  FBG
//
//  Created by yy on 2018/5/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

#define CHOOSE_WALLET_CELL_ID @"CHOOSE_WALLET_CELL"

@interface YYRedPacketChooseWalletTableViewCell : DBHBaseTableViewCell

- (void)setModel:(DBHWalletManagerForNeoModelList *)model currentWalletID:(NSInteger)currentWalletID;

@end
