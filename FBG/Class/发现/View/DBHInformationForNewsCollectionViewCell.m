//
//  DBHInformationForNewsCollectionViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationForNewsCollectionViewCell.h"

#import "NSTimer+Extension.h"

#import "DBHInformationForNewsCollectionViewTableViewCell.h"

#import "DBHInformationForNewsCollectionModelData.h"

static NSString *const kDBHInformationForNewsCollectionViewTableViewCellIdentifier = @"kDBHInformationForNewsCollectionViewTableViewCellIdentifier";

#define SCROLLVIEWWIDTH AUTOLAYOUTSIZE(230)
#define SCROLLVIEWHEIGHT AUTOLAYOUTSIZE(59)

@interface DBHInformationForNewsCollectionViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UILabel *newsLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *projectLabel;

@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) ClickNewsBlock clickNewsBlock;
@property (nonatomic, strong) NSMutableArray *newsShufflingFigureViewArray;

@end

@implementation DBHInformationForNewsCollectionViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.orangeView];
    [self.contentView addSubview:self.newsLabel];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.grayView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.projectLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(42));
        make.top.centerX.equalTo(weakSelf.contentView);
    }];
    [self.orangeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(3));
        make.height.equalTo(weakSelf.boxView);
        make.left.centerY.equalTo(weakSelf.boxView);
    }];
    [self.newsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:@"NEWS" fontSize:AUTOLAYOUTSIZE(11)]);
        make.left.equalTo(weakSelf.orangeView.mas_right).offset(AUTOLAYOUTSIZE(8.5));
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.newsLabel.mas_right);
        make.right.equalTo(weakSelf.contentView);
        make.height.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.grayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.tableView.mas_bottom);
        make.bottom.equalTo(weakSelf.projectLabel.mas_top);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.projectLabel);
    }];
    [self.projectLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([self getWidthWithString:@"NEWS" font:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)] + AUTOLAYOUTSIZE(6));
        make.height.offset(AUTOLAYOUTSIZE(29));
        make.centerX.equalTo(weakSelf.lineView);
        make.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationForNewsCollectionViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHInformationForNewsCollectionViewTableViewCellIdentifier forIndexPath:indexPath];
    
    DBHInformationForNewsCollectionModelData *model = self.dataSource[indexPath.row];
    cell.title = model.title;
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInformationForNewsCollectionModelData *model = _dataSource[indexPath.row];
    
    NSString *url;
    if ([model.url containsString:@"http"]) {
        url = model.url;
    } else {
        url = [NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.url];
    }
    
    self.clickNewsBlock(url);
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    if (x >= (self.dataSource.count - 1) * SCROLLVIEWWIDTH) {
        [scrollView setContentOffset:CGPointMake(SCROLLVIEWWIDTH, 0)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    if (!x) {
        [scrollView setContentOffset:CGPointMake((self.dataSource.count - 1) * SCROLLVIEWWIDTH, 0)];
    } else if (x >= (self.dataSource.count - 1) * SCROLLVIEWWIDTH) {
        [scrollView setContentOffset:CGPointMake(SCROLLVIEWWIDTH, 0)];
    }
    
    [self startTimer];
}

#pragma mark ------ Public Methods ------
- (void)clickNewsBlock:(ClickNewsBlock)clickNewsBlock {
    self.clickNewsBlock = clickNewsBlock;
}

#pragma mark ------ Private Methods ------
/**
 返回文字高度
 */
- (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}
/**
 开始定时器
 */
- (void)startTimer {
    //如果只有一张图片，则直接返回，不开启定时器
    if (self.dataSource.count <= 1)
        return;
    //如果定时器已开启，先停止再重新开启
    if (self.timer)
        [self stopTimer];
    WEAKSELF
    self.timer = [NSTimer dbh_timerWithTimeInterval:4 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf nextPage];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
/**
 关闭定时器
 */
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}
/**
 下一页
 */
- (void)nextPage {
    self.currentRow += 1;
    [self.tableView setContentOffset:CGPointMake(0, (AUTOLAYOUTSIZE(21) * (float)self.currentRow)) animated:NO];
    
    if (self.currentRow >= self.dataSource.count) {
        
        self.currentRow = 0;
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    self.currentRow = 0;
    self.tableView.rowHeight = _dataSource.count > 1 ? AUTOLAYOUTSIZE(21) : AUTOLAYOUTSIZE(42);
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];

    if (_dataSource.count > 1) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor whiteColor];
    }
    return _boxView;
}
- (UIView *)orangeView {
    if (!_orangeView) {
        _orangeView = [[UIView alloc] init];
        _orangeView.backgroundColor = [UIColor colorWithHexString:@"DA521C"];
    }
    return _orangeView;
}
- (UILabel *)newsLabel {
    if (!_newsLabel) {
        _newsLabel = [[UILabel alloc] init];
        _newsLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _newsLabel.text = @"NEWS";
        _newsLabel.textColor = [UIColor colorWithHexString:@"010101"];
    }
    return _newsLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(42);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHInformationForNewsCollectionViewTableViewCell class] forCellReuseIdentifier:kDBHInformationForNewsCollectionViewTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIView *)grayView {
    if (!_grayView) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _grayView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"333333"];
    }
    return _lineView;
}
- (UILabel *)projectLabel {
    if (!_projectLabel) {
        _projectLabel = [[UILabel alloc] init];
        _projectLabel.backgroundColor = [UIColor whiteColor];
        _projectLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _projectLabel.text = @"项目";
        _projectLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _projectLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _projectLabel;
}

- (NSMutableArray *)newsShufflingFigureViewArray {
    if (!_newsShufflingFigureViewArray) {
        _newsShufflingFigureViewArray = [NSMutableArray array];
    }
    return _newsShufflingFigureViewArray;
}

@end
