//
//  DBHInformationForNewsCollectionViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHInformationForNewsCollectionViewCell.h"

#import "NSTimer+Extension.h"

#import "DBHNewsShufflingFigureView.h"

#import "DBHInformationForNewsCollectionModelData.h"

#define SCROLLVIEWWIDTH AUTOLAYOUTSIZE(230)
#define SCROLLVIEWHEIGHT AUTOLAYOUTSIZE(59)

@interface DBHInformationForNewsCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UILabel *newsLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *projectLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) ClickMoreButtonBlock clickMoreButtonBlock;
@property (nonatomic, copy) ClickNewsBlock clickNewsBlock;
@property (nonatomic, strong) NSMutableArray *newsShufflingFigureViewArray;

@end

@implementation DBHInformationForNewsCollectionViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.orangeView];
    [self.contentView addSubview:self.newsLabel];
    [self.contentView addSubview:self.leftButton];
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.rightButton];
    [self.contentView addSubview:self.moreButton];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.projectLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(59));
        make.top.offset(AUTOLAYOUTSIZE(9.5));
        make.centerX.equalTo(weakSelf.contentView);
    }];
    [self.orangeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(5));
        make.height.equalTo(weakSelf.boxView);
        make.left.centerY.equalTo(weakSelf.boxView);
    }];
    [self.newsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:@"NEWS" fontSize:AUTOLAYOUTSIZE(11)]);
        make.left.equalTo(weakSelf.orangeView.mas_right).offset(AUTOLAYOUTSIZE(7));
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(26));
        make.height.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.boxView);
        make.left.equalTo(weakSelf.newsLabel.mas_right);
    }];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftButton.mas_right);
        make.width.offset(AUTOLAYOUTSIZE(230));
        make.height.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.leftButton);
        make.right.equalTo(weakSelf.moreButton.mas_left).offset(- AUTOLAYOUTSIZE(6.5));
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.moreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(38.5));
        make.height.equalTo(weakSelf.boxView);
        make.right.centerY.equalTo(weakSelf.boxView);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.offset(- AUTOLAYOUTSIZE(15));
    }];
    [self.projectLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([self getWidthWithString:@"NEWS" font:[UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)] + AUTOLAYOUTSIZE(6));
        make.center.equalTo(weakSelf.lineView);
    }];
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

#pragma mark ------ Event Responds ------
/**
 上一条新闻
 */
- (void)respondsToLeftButton {
    if (_dataSource.count <= 1) {
        return;
    }
    NSInteger page = (NSInteger)(self.scrollView.contentOffset.x / SCROLLVIEWWIDTH);
    CGFloat x = page * SCROLLVIEWWIDTH - SCROLLVIEWWIDTH;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    if (!x) {
        [self.scrollView setContentOffset:CGPointMake((self.dataSource.count - 1) * SCROLLVIEWWIDTH, 0)];
    }
}
/**
 下一条新闻
 */
- (void)respondsToRightButton {
    if (_dataSource.count > 1) {
        [self nextPage];
    }
}
/**
 更多
 */
- (void)respondsToMoreButton {
    self.clickMoreButtonBlock();
}
- (void)respondsToTapGR:(UITapGestureRecognizer *)tapGR {
    NSInteger tag = tapGR.view.tag;
    DBHInformationForNewsCollectionModelData *model = _dataSource[tag - 400];
    
    NSString *url;
    if ([model.url containsString:@"http"]) {
        url = model.url;
    } else {
        url = [NSString stringWithFormat:@"https://dev.inwecrypto.com/%@", model.url];
    }
    
    self.clickNewsBlock(url);
}

#pragma mark ------ Public Methods ------
- (void)clickMoreButtonBlock:(ClickMoreButtonBlock)clickMoreButtonBlock {
    self.clickMoreButtonBlock = clickMoreButtonBlock;
}
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
    NSInteger page = (NSInteger)(self.scrollView.contentOffset.x / SCROLLVIEWWIDTH);
    CGFloat x = page * SCROLLVIEWWIDTH + SCROLLVIEWWIDTH;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    if (x == (self.dataSource.count) * SCROLLVIEWWIDTH) {
        [self.scrollView setContentOffset:CGPointMake(SCROLLVIEWWIDTH, 0)];
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    self.scrollView.contentSize = CGSizeMake(SCROLLVIEWWIDTH * (_dataSource.count + (_dataSource.count > 1 ? 2 : 0)), 0);
    
    for (NSInteger i = 0; i < _dataSource.count + (_dataSource.count > 1 ? 2 : 0); i++) {
        NSInteger index = 0;
        if (_dataSource.count > 1) {
            if (!i) {
                index = _dataSource.count - 1;
            } else if (i == _dataSource.count - 1) {
                index = 0;
            } else {
                index = i - 1;
            }
        }
        DBHInformationForNewsCollectionModelData *model = _dataSource[index];
        
        DBHNewsShufflingFigureView *newsShufflingFigureView;
        newsShufflingFigureView = [self.scrollView viewWithTag:400 + i];
        if (!newsShufflingFigureView) {
            newsShufflingFigureView = [[DBHNewsShufflingFigureView alloc] initWithFrame:CGRectMake(i * SCROLLVIEWWIDTH, 0, SCROLLVIEWWIDTH, SCROLLVIEWHEIGHT)];
            newsShufflingFigureView.tag = 400 + i;
            newsShufflingFigureView.userInteractionEnabled = YES;
            newsShufflingFigureView.title = model.title;
            newsShufflingFigureView.content = model.desc;
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGR:)];
            [newsShufflingFigureView addGestureRecognizer:tapGR];
            
            [self.scrollView addSubview:newsShufflingFigureView];
        } else {
            newsShufflingFigureView.title = model.title;
            newsShufflingFigureView.content = model.desc;
        }
    }
    
    if (_dataSource.count > 1) {
        [self startTimer];
    }
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = [UIColor colorWithHexString:@"161F26"];
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
        _newsLabel.textColor = [UIColor colorWithHexString:@"97BDDB"];
    }
    return _newsLabel;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"ARROWleft"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(respondsToLeftButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"ARROWRIGHT"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(respondsToRightButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.backgroundColor = [UIColor colorWithHexString:@"DA521C"];
        [_moreButton setImage:[UIImage imageNamed:@"ARROWmore"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(respondsToMoreButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"506987"];
    }
    return _lineView;
}
- (UILabel *)projectLabel {
    if (!_projectLabel) {
        _projectLabel = [[UILabel alloc] init];
        _projectLabel.backgroundColor = [UIColor colorWithHexString:@"171C27"];
        _projectLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(13)];
        _projectLabel.text = @"项目";
        _projectLabel.textColor = [UIColor colorWithHexString:@"97BDDB"];
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
