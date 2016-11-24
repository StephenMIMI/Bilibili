//
//  RecommendViewController.m
//  Bilibili
//
//  Created by qianfeng on 16/11/23.
//  Copyright © 2016年 zhb. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendModel.h"
#import "XYBannerView.h"

@interface RecommendViewController ()<UITableViewDelegate, UITableViewDataSource>

//表格
@property (nonatomic, strong)UITableView *tableView;
//数据
@property (nonatomic, strong)RecommendModel *model;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self downloadListData];
}

//创建表格
- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //约束
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadListData {
    NSString *urlString = @"http://app.bilibili.com/x/v2/show?build=429001";
    [BLDownloader downloadWithURLString:urlString success:^(NSData *data) {
        NSError *error = nil;
        RecommendModel *tmpModel = [[RecommendModel alloc] initWithData:data error:&error];
        if (error) {
            NSLog(@"%@", error);
        }else {
            self.model = tmpModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGFloat row = 0;
    if (section == 0) {
        row = 1;//banner
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 80;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //头部广告视图
        if (self.model != nil) {
            XYBannerView *cell = [XYBannerView createBannerViewFor:tableView atIndexPath:indexPath bannerArray:[self.model.data[0] banner]];
            return cell;
        }
    }
    return [[UITableViewCell alloc] init];
}

@end
