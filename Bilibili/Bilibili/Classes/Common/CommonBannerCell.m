//
//  CommonBannerCell.m
//  Bilibili
//
//  Created by qianfeng on 16/11/25.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import "CommonBannerCell.h"
#import "RecommendModel.h"

@interface CommonBannerCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//数据
@property (nonatomic, strong)RCDataModel *dataModel;
//定义3个轮播视图
@property (nonatomic, strong)UIImageView *preImageView;
@property (nonatomic, strong)UIImageView *curImageView;
@property (nonatomic, strong)UIImageView *nextImageView;
//获取scrollView的高度
@property (nonatomic, assign)CGFloat viewHeight;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)NSTimer *timer;
//存放图片URL
@property (nonatomic, strong)NSArray *imageArray;

@end

@implementation CommonBannerCell

- (CGFloat)viewHeight {
    return self.frame.size.height;
}

- (void)setDataModel:(RCDataModel *)dataModel {
    
    [self configUI];//配置基础页面
    if (dataModel.banner.top.count > 1) {
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (RCBannerDetail *subBanner in dataModel.banner.top) {
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
    //配置基础页面
    //定义手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    //添加前一个视图
    self.preImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.viewHeight)];
    [self.scrollView addSubview:self.preImageView];
    //添加当前视图
    self.curImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.viewHeight)];
    
    self.curImageView.userInteractionEnabled = YES;
    [self.curImageView addGestureRecognizer:tap];
    [self.scrollView addSubview:self.curImageView];
    //添加后一个视图
    self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.viewHeight)];
    [self.scrollView addSubview:self.nextImageView];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*3, self.viewHeight);
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.scrollView.delegate = self;
    self.pageControl.currentPageIndicatorTintColor = XYPinkColor;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[1]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
}

- (void)timeRun {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.scrollView.contentOffset = CGPointMake(kScreenWidth*2, 0);
    } completion:^(BOOL finished) {
        [weakSelf scrollViewDidEndDecelerating:weakSelf.scrollView];
    }];
}

- (void)tapAction {
    NSLog(@"点击了1下！");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CommonBannerCell *)createBannerViewFor:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath dataModel:(RCDataModel *)dataModel {
    static NSString *cellId = @"commonBannerCellId";
    CommonBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonBannerCell" owner:nil options:nil] lastObject];
    }
    //数据
    cell.dataModel = dataModel;
    return cell;
}

#pragma mark - scrollView的代理方法

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger count = self.imageArray.count;
    //滑动停止并重新计时
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeRun) userInfo:nil repeats:NO];
    if (self.scrollView.contentOffset.x == 2*kScreenWidth) {
        self.currentPage = (self.currentPage+1)%count;
    }else if (self.scrollView.contentOffset.x == 0) {
        self.currentPage = (self.currentPage-1)%count;
    }
    [self.curImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[self.currentPage]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
    [self.preImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[(self.currentPage-1+count)%count]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
    [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[(self.currentPage+1)%count]] placeholderImage:[UIImage imageNamed:@"tad_placeholder"]];
    self.pageControl.currentPage = self.currentPage;
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
}

@end
