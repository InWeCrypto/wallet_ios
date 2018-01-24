//
//  DBHChangePasswordViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHChangePasswordViewController.h"

#import "DBHChangePasswordTableViewCell.h"

static NSString *const kDBHChangePasswordTableViewCellIdentifier = @"kDBHChangePasswordTableViewCellIdentifier";

@interface DBHChangePasswordViewController ()<UITableViewDataSource, UITableViewDelegate> {
    dispatch_source_t _timer;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger nowTimestamp;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHChangePasswordViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Change Password", nil);
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSaveBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHChangePasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHChangePasswordTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    
    WEAKSELF
    [cell getVerificationCodeBlock:^{
        // 获取验证码
        [weakSelf getVerificationCode];
    }];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(11.5);
}

#pragma mark ------ Data ------
/**
 获取验证码
 */
- (void)getVerificationCode {
    WEAKSELF
    [PPNetworkHelper POST:[NSString stringWithFormat:@"send_code/%@", [UserSignData share].user.email] baseUrlType:3 parameters:nil hudString:[NSString stringWithFormat:@"%@...", NSLocalizedString(@"Get Verification Code", nil)] success:^(id responseObject) {
        [weakSelf keepTime];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 修改密码
 */
- (void)updatePassword {
    DBHChangePasswordTableViewCell *verificationCodeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    DBHChangePasswordTableViewCell *newPasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    DBHChangePasswordTableViewCell *surePasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSDictionary *paramters = @{@"email":[UserSignData share].user.email,
                                @"code":verificationCodeCell.valueTextField.text,
                                @"password":newPasswordCell.valueTextField.text,
                                @"password_confirmation":surePasswordCell.valueTextField.text};
    
    WEAKSELF
    [PPNetworkHelper POST:@"forgot_password" baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        [LCProgressHUD showSuccess:NSLocalizedString(@"Password reset successful", nil)];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 保存
 */
- (void)respondsToSaveBarButtonItem {
    DBHChangePasswordTableViewCell *verificationCodeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    DBHChangePasswordTableViewCell *newPasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    DBHChangePasswordTableViewCell *surePasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (!verificationCodeCell.valueTextField.text.length) {
        [LCProgressHUD showFailure:NSLocalizedString(@"Please input a verification code", nil)];
        return;
    }
    if (!newPasswordCell.valueTextField.text.length) {
        [LCProgressHUD showFailure:NSLocalizedString(@"Please input a password", nil)];
        return;
    }
    if (!surePasswordCell.valueTextField.text.length) {
        [LCProgressHUD showFailure:NSLocalizedString(@"Please enter your password again", nil)];
        return;
    }
    if (![newPasswordCell.valueTextField.text isEqualToString:surePasswordCell.valueTextField.text]) {
        [LCProgressHUD showFailure:NSLocalizedString(@"The two passwords differ", nil)];
        return;
    }
    
    [self updatePassword];
}

#pragma mark ------ Private Methods ------
/**
 发送验证码计时
 */
- (void)keepTime {
    // 记录当前时间
    NSDate *currenDate = [NSDate date];
    self.nowTimestamp = (long)[currenDate timeIntervalSince1970];
    
    // 创建一个派发队列 优先级是默认
    WEAKSELF
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        NSDate *currenDate = [NSDate date];
        NSInteger timestamp = [currenDate timeIntervalSince1970];
        timestamp = 60 - timestamp + self.nowTimestamp;
        
        DBHChangePasswordTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (timestamp <= 0) { // 倒计时结束 关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置按钮的样式
                cell.emailVerificationCodeButton.backgroundColor = COLORFROM16(0xFF841C, 1);
                [cell.emailVerificationCodeButton setTitle:NSLocalizedString(@"Retrieves", nil) forState:UIControlStateNormal];
//                [cell.emailVerificationCodeButton setTitleColor:COLORFROM16(0x008C55, 1) forState:UIControlStateNormal];
                cell.emailVerificationCodeButton.userInteractionEnabled = YES;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置按钮显示读秒效果
                cell.emailVerificationCodeButton.backgroundColor = COLORFROM16(0x999999, 1);
                [cell.emailVerificationCodeButton setTitle:[NSString stringWithFormat:@"(%lds)", timestamp] forState:UIControlStateNormal];
//                [cell.emailVerificationCodeButton setTitleColor:COLORFROM16(0x999999, 1) forState:UIControlStateNormal];
                cell.emailVerificationCodeButton.userInteractionEnabled = NO;
            });
        }
    });
    dispatch_resume(_timer);
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(51);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHChangePasswordTableViewCell class] forCellReuseIdentifier:kDBHChangePasswordTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"Verification code", @"New Password", @"Sure Password"];
    }
    return _titleArray;
}

@end
