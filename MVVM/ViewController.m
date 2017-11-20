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
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.vm.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = self.vm.dataArray[indexPath.row];
    return cell;
}
- (void)dealloc{
    NSLog(@"____________DEALLOC______________");
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
