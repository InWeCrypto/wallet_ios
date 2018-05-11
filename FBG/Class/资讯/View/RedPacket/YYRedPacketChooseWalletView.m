//
//  YYRedPacketChooseWalletView.m
//  FBG
//
//  Created by yy on 2018/5/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketChooseWalletView.h"
#import "YYRedPacketChooseWalletTableViewCell.h"

@interface YYRedPacketChooseWalletView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *selectedModel;

@end

@implementation YYRedPacketChooseWalletView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        [self initUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketChooseWalletTableViewCell class]) bundle:nil] forCellReuseIdentifier:CHOOSE_WALLET_CELL_ID];
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Choose Wallet", nil);
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Only Support ETH Wallet Now", nil);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 67;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.sureBtn setCorner:2];
//    [self.sureBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
//    [self.sureBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    [self.sureBtn setTitle:DBHGetStringWithKeyFromTable(@"  Confirm  ", nil) forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        [self respondsToExitBtn:nil];
    }
}

#pragma mark ----- Setters And Getters ---------
/**
 动画显示
 */
- (void)animationShow {
    WEAKSELF
    self.bottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYRedPacketChooseWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHOOSE_WALLET_CELL_ID forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        [cell setModel:self.dataSource[indexPath.row] currentWalletID:self.selectedModel.listIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    
    if (row < self.dataSource.count) {
        DBHWalletManagerForNeoModelList *model = self.dataSource[row];
        if (model.listIdentifier != self.selectedModel.listIdentifier) {
            self.selectedModel = model;
            [tableView reloadData];
        }
    }
}

#pragma mark ----- Setters And Getters ---------
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    if (dataSource.count > 0) {
        DBHWalletManagerForNeoModelList *model = dataSource.firstObject;
        _selectedModel = model; // 默认第一个
    }
    [self.tableView reloadData];
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToSureBtn:(UIButton *)sender {
    if (!self.selectedModel) {
        return;
    }
    
    [self respondsToExitBtn:nil];
    if (self.block) {
        self.block(self.selectedModel);
    }
}

- (IBAction)respondsToExitBtn:(UIButton *)sender {
    WEAKSELF
    self.bottomConstraint.constant = -375;
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
