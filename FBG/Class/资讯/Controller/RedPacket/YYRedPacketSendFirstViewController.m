//
//  YYRedPacketSendFirstViewController.m
//  FBG
//
//  Created by yy on 2018/4/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFirstViewController.h"
#import "YYRedPacketSendFirstSection0Cell.h"
#import "YYRedPacketSendFirstSection1Cell.h"
#import "DBHInputPasswordPromptView.h"

@interface YYRedPacketSendFirstViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *authBtn;

@property (nonatomic, strong) UIView *maxUseView;
@property (nonatomic, strong) UILabel *maxTitleLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;
@property (nonatomic, strong) UILabel *noLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *selectedWalletId;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;

@end

@implementation YYRedPacketSendFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"redpacket_navigation"] forBarMetrics:UIBarMetricsDefault];
}

- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
    self.navigationController.navigationBar.tintColor = WHITE_COLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(20)}];
    
    WEAKSELF
    [self.view addSubview:self.headerView];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@(3));
    }];
    
    [self.view addSubview:self.noLabel];
    [self.noLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(-20));
        make.centerX.equalTo(weakSelf.view);
        make.left.greaterThanOrEqualTo(weakSelf.view);
    }];
    
    [self.view addSubview:self.maxUseView];
    [self.maxUseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.noLabel.mas_top).offset(AUTOLAYOUTSIZE(-20));
        make.left.greaterThanOrEqualTo(weakSelf.view);
    }];
    
    [self.maxUseView addSubview:self.maxTitleLabel];
    [self.maxTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.centerY.equalTo(weakSelf.maxUseView);
    }];
    
    [self.maxUseView addSubview:self.maxValueLabel];
    [self.maxValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.centerY.equalTo(weakSelf.maxUseView);
        make.left.equalTo(weakSelf.maxTitleLabel.mas_right);
    }];
    
    [self.view addSubview:self.authBtn];
    [self.authBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(-100));
        make.bottom.equalTo(weakSelf.maxUseView.mas_top).offset(AUTOLAYOUTSIZE(-16));
        make.height.offset(AUTOLAYOUTSIZE(40));
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    
    tableView.tableHeaderView = nil;
    tableView.sectionHeaderHeight = 0;
    
    tableView.tableFooterView = nil;
    tableView.sectionFooterHeight = 0;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketSendFirstSection0Cell class]) bundle:nil] forCellReuseIdentifier:REDPACKET_SEND_SECTION0_CELL_ID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYRedPacketSendFirstSection1Cell class]) bundle:nil] forCellReuseIdentifier:REDPACKET_SEND_SECTION1_CELL_ID];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = tableView;
    [self.view addSubview:_tableView];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.bottom.equalTo(weakSelf.authBtn.mas_top).offset(AUTOLAYOUTSIZE(-10));
    }];
    
}

#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        YYRedPacketSendFirstSection0Cell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SEND_SECTION0_CELL_ID forIndexPath:indexPath];
        return cell;
    }
    
    YYRedPacketSendFirstSection1Cell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SEND_SECTION1_CELL_ID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row != 0 && row < self.dataSource.count) {
//        NSDictionary *dict = self.dataSource[row];
//        NSString *boxId = dict[ZKT_BOX_ID]; //选中的中控记录下唯一标示
//
//        if (![boxId isEqualToString:_selectedWalletId]) { //改变了
//            //DLog(@"改变了");
//            _selectedWalletId = boxId;
//        } else {
//            //DLog(@"还是原来的");
//            _selectedWalletId = nil;
//        }
//        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return REDPACKET_SEND_SECTION0_CELL_HEIGHT;
    }
    return REDPACKET_SEND_SECTION1_CELL_HEIGHT;
}

- (void)respondsToAuthBtn {
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.inputPasswordPromptView animationShow];
    });
}

- (UIView *)headerView {
    if (!_headerView) {
        //进度条
        UIView *progress = [[UIView alloc] init];
        progress.backgroundColor = COLORFROM16(0xF1F1F1, 1);
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithHexString:@"029857"].CGColor;
        [progress.layer addSublayer:layer];
        
        layer.opacity = 1;
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.25, 3);
        
        _headerView = progress;
    }
    return _headerView;
}

- (UIView *)maxUseView {
    if (!_maxUseView) {
        _maxUseView = [[UIView alloc] init];
    }
    return _maxUseView;
}

- (UILabel *)maxTitleLabel {
    if (!_maxTitleLabel) {
        _maxTitleLabel = [[UILabel alloc] init];
        _maxTitleLabel.font = FONT(12);
        _maxTitleLabel.text = DBHGetStringWithKeyFromTable(@"Maximum Available Quantity:", nil);
        _maxTitleLabel.textColor = COLORFROM16(0xA6A4A4, 1);
    }
    return _maxTitleLabel;
}

- (UILabel *)maxValueLabel {
    if (!_maxValueLabel) {
        _maxValueLabel = [[UILabel alloc] init];
        _maxValueLabel.font = FONT(12);
        _maxValueLabel.text = @"0.00000000";
        _maxValueLabel.textColor = COLORFROM16(0xF9480E, 1);
    }
    return _maxValueLabel;
}

- (UILabel *)noLabel {
    if (!_noLabel) {
        _noLabel = [[UILabel alloc] init];
        _noLabel.font = FONT(12);
        _noLabel.text = @"  ";
        _noLabel.textColor = COLORFROM16(0xB5B4B3, 1);
    }
    return _noLabel;
}

- (UIButton *)authBtn {
    if (!_authBtn) {
        _authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_authBtn setTitle:DBHGetStringWithKeyFromTable(@"Start Authorize", nil) forState:UIControlStateNormal];
        [_authBtn addTarget:self action:@selector(respondsToAuthBtn) forControlEvents:UIControlEventTouchUpInside];
        _authBtn.titleLabel.font = FONT(14);
        [_authBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [_authBtn setBackgroundColor:COLORFROM16(0xEA6204, 1)];
        [_authBtn setCorner:3];
    }
    return _authBtn;
}

- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        _inputPasswordPromptView.placeHolder = DBHGetStringWithKeyFromTable(@"Please Input Wallet Password", nil);
//        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            //TODO
        }];
    }
    return _inputPasswordPromptView;
}

@end
