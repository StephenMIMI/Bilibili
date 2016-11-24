//
//  XYBannerView.m
//  Bilibili
//
//  Created by qianfeng on 16/11/24.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import "XYBannerView.h"
#import "RecommendModel.h"

@interface XYBannerView()<UIScrollViewDelegate>

//滚动视图
@property (nonatomic, strong)UIScrollView *scrollView;
//pageControl
@property (nonatomic, strong)UIPageControl *pageControl;
//数据
@property (nonatomic, strong)RCBanner *bannerArray;
//定义3个轮播视图
@property (nonatomic, strong)UIImageView *preImageView;
@property (nonatomic, strong)UIImageView *curImageView;
@property (nonatomic, strong)UIImageView *nextImageView;
//获取scrollView的高度
@property (nonatomic, assign)CGFloat viewWidth;
@property (nonatomic, assign)CGFloat viewHeight;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)NSArray *imageArray;

@end

@implementation XYBannerView

- (CGFloat)viewWidth {
    return self.frame.size.width;
}

- (CGFloat)viewHeight {
    return self.frame.size.height;
}

//懒加载
- (UIScrollView *)scrollView {
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _scrollView;
}

//懒加载
- (UIPageControl *)pageControl {
    if (nil == _pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    }
    return _pageControl;
}

- (void)setBannerArray:(RCBanner *)bannerArray {
    
    //配置基础页面
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = false;
    self.scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:self.scrollView];
    //添加scrollView约束
    __weak typeof(self) weakSelf = self;
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf);
//    }];

    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self configUI];
    if (bannerArray.top.count > 1) {
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (RCBannerDetail *subBanner in bannerArray.top) {
            if (subBanner.image != nil) {
                [tmpArray addObject:subBanner.image];
            }
        }
        self.imageArray = tmpArray;
        //只有2个以上的图片才会创建
        [self fillData];
    }
}

- (void)configUI {
    //定义手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    //添加前一个视图
    self.preImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    [self.scrollView addSubview:self.preImageView];
    //添加当前视图
    self.curImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight)];
    self.curImageView.userInteractionEnabled = YES;
    [self.curImageView addGestureRecognizer:tap];
    [self.scrollView addSubview:self.curImageView];
    //添加后一个视图
    self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewWidth*2, 0, self.viewWidth, self.viewHeight)];
    [self.scrollView addSubview:self.nextImageView];
    
    self.scrollView.contentSize = CGSizeMake(self.viewWidth*3, self.viewHeight);
    self.scrollView.contentOffset = CGPointMake(self.viewHeight, 0);
}

- (void)fillData {
    //设置页数
    self.pageControl.numberOfPages = self.imageArray.count;
    self.currentPage = 0;
    self.pageControl.currentPage = self.currentPage;
    //添加定时器
    self.timer = [[NSTimer alloc] init];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeRun) userInfo:nil repeats:NO];
    
    NSInteger count = self.imageArray.count;
    //设置图片
    [self.preImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[count-1]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
    [self.curImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
    [self.preImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[1]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
}

- (void)timeRun {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.viewWidth*2, 0);
    } completion:^(BOOL finished) {
        [weakSelf scrollViewDidEndDecelerating:weakSelf.scrollView];
    }];
}

- (void)tapAction {
    NSLog(@"点击了1下！");
}

//返回scrollView
+ (XYBannerView *)createBannerViewFor:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath bannerArray:(RCBanner *)bannerArray {
    
    XYBannerView *banner = [[XYBannerView alloc] init];
    //数据
    banner.bannerArray = bannerArray;
    return banner;
}

#pragma mark - scrollView的代理方法

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger count = self.imageArray.count;
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeRun) userInfo:nil repeats:NO];
    if (self.scrollView.contentOffset.x == 2*self.viewWidth) {
        self.currentPage = (self.currentPage+1)%count;
    }else if (self.scrollView.contentOffset.x == 0) {
        self.currentPage = (self.currentPage-1)%count;
    }
    
    [self.curImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[self.currentPage]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
    [self.preImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[(self.currentPage-1+count)%count]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
    [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[(self.currentPage+1)%count]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
    self.pageControl.currentPage = self.currentPage;
    self.scrollView.contentOffset = CGPointMake(self.viewWidth, 0);
}
@end
