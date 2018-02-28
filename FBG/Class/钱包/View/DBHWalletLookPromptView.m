//
//  DBHWalletLookPromptView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletLookPromptView.h"

#import "DBHWalletLookPromptViewTableViewCell.h"

#import "DBHWalletManagerForNeoModelList.h"

static NSString *const kDBHWalletLookPromptViewTableViewCellIdentifier = @"kDBHWalletLookPromptViewTableViewCellIdentifier";

@interface DBHWalletLookPromptView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) SelectedBlock selectedBlock;

@end

@implementation DBHWalletLookPromptView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x000000, 0.4);
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
        [self setUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        [self respondsToQuitButton];
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.quitButton];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.numberLabel];
    [self.boxView addSubview:self.tableView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(373.5));
    }];
    [self.quitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(44));
        make.top.right.equalTo(weakSelf.boxView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(15));
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(25));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11.5));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHWalletLookPromptViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHWalletLookPromptViewTableViewCellIdentifier forIndexPath:indexPath];
    cell.tokenName = self.tokenName;
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self respondsToQuitButton];
    self.selectedBlock(self.dataSource[indexPath.row]);
}

#pragma mark ------ Event Responds ------
/**
 退出
 */
- (void)respondsToQuitButton {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(373.5));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ Public Methods ------
/**
 动画显示
 */
- (void)animationShow {
    [self sortData];
    WEAKSELF
    [self.boxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
- (void)selectedBlock:(SelectedBlock)selectedBlock {
    self.selectedBlock = selectedBlock;
}

#pragma mark ------ Private Methods ------
/**
 排序
 */
- (void)sortData {
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        DBHWalletManagerForNeoModelList *model = self.dataSource[i];
        if (model.tokenStatistics[self.tokenName] == nil && ![self.tokenName isEqualToString:@"NEO"] && ![self.tokenName isEqualToString:@"NEO"] && ![self.tokenName isEqualToString:@"ETH"]) {
            [self.dataSource removeObjectAtIndex:i];
            i--;
        }
    }
    
    if (self.dataSource.count < 2) {
        [self.tableView reloadData];
        
        return;
    }
    
    for (NSInteger i = 0; i < self.dataSource.count - 1; i++) {
        for (NSInteger j = 0; j < self.dataSource.count - i - 1; j++) {
            DBHWalletManagerForNeoModelList *currentModel = self.dataSource[j];
            DBHWalletManagerForNeoModelList *nextModel = self.dataSource[j + 1];
            NSString *currentBalance = currentModel.tokenStatistics[self.tokenName];
            NSString *nextBalance = nextModel.tokenStatistics[self.tokenName];
            if (currentBalance.floatValue < nextBalance.floatValue) {
                [self.dataSource exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark ------ Getters And Setters ------
- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor whiteColor];
    }
    return _boxView;
}
- (UIButton *)quitButton {
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setImage:[UIImage imageNamed:@"关闭-3"] forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(respondsToQuitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(18);
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Wallet Lists", nil);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = BOLDFONT(10);
        _numberLabel.text = DBHGetStringWithKeyFromTable(@"Amount Available", nil);
        _numberLabel.textColor = COLORFROM16(0xC1BEBE, 1);
    }
    return _numberLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(60);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHWalletLookPromptViewTableViewCell class] forCellReuseIdentifier:kDBHWalletLookPromptViewTableViewCellIdentifier];
    }
    return _tableView;
}

@end
