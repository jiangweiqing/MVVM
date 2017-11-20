//
//  ViewController.m
//  MVVM
//
//  Created by jiang on 2017/11/20.
//  Copyright © 2017年 jiang. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"
#import <Masonry.h>
#import <MJRefresh.h>
@interface ViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ViewModel *vm;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
}
- (void)addTableView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.vm = [[ViewModel alloc] initWithTableView:self.tableView];
    self.tableView.delegate = self.vm;
    self.tableView.dataSource = self.vm;
    __weak typeof(self) weakSelf = self;
    self.vm.dBlock = ^(id model){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}
- (void)loadData{
    [self.vm refreshDataCompletion:^{
        NSLog(@"########刷新完成########");
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSInteger errorCode) {
        
    }];
}
- (void)loadMoreData{
    [self.vm loadMoreDataCompletion:^(BOOL scuess) {
        if (scuess) {
            
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSInteger errorCode) {
        
    }];
}
- (void)dealloc{
    NSLog(@"____________DEALLOC______________");
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.rowHeight = 50;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
