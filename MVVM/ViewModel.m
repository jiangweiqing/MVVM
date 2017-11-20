//
//  ViewModel.m
//  TopScrollView
//
//  Created by jiang on 2017/11/20.
//  Copyright © 2017年 jiang. All rights reserved.
//

#import "ViewModel.h"
#import "BaseModel.h"
@interface ViewModel (){
    NSInteger _pageNumber;
    NSInteger _pageSize;
    UITableView *_tableView;
    NSInteger _totalCount;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewModel
- (instancetype)initWithTableView:(UITableView *)tableView{
    if (self = [super init]) {
        _tableView = tableView;
        _pageSize = 20;
        _pageNumber = 1;
    }
    return self;
}
- (void)loadDataWithPage:(NSInteger)page completion:(void(^)(NSDictionary *dic))completion failer:(void(^)(NSInteger errorCode))failure{
    sleep(2);
    BOOL load = YES;
    if (load) {
        if (completion) {
//            _totalCount = [dic[@"count"] integerValue];数据列表中的totalCount
            completion(@{});
        }
    }else{
        if (failure) {
            failure(100);
        }
    }
}
- (void)refreshDataCompletion:(void (^)(void))completion failure:(void (^)(NSInteger))failure{
    NSInteger page = 1;
    [self loadDataWithPage:page completion:^(NSDictionary *dic) {
        if (completion) {
            completion();
        }
//        _pageNumber = 1;
//        [self.dataArray removeAllObjects];
//        self.dataArray = [BaseModel mj_objectArrayWithKeyValuesArray:dic];
    } failer:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}
- (void)loadMoreDataCompletion:(void (^)(BOOL))completion failure:(void (^)(NSInteger))failure{
    NSInteger page = _pageNumber + 1;
    [self loadDataWithPage:page completion:^(NSDictionary *dic) {
        if (completion) {
//            NSMutableArray *array = [BaseModel mj_objectArrayWithKeyValuesArray:dic];
//            [self.dataArray addObjectsFromArray:array];
            [_tableView reloadData];
#pragma 判断当前数据总数已经超过总的数据数目
            if (self.dataArray.count < _totalCount) {
                completion(@YES);//tableview还能进行上拉加载
#pragma 返回数据标识code，VC中提示
            }else{
                completion(@NO);//tableview不能进行上啦加载了
            }
        }
    } failer:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"____tabeviewDidSelect_____");
    if (self.dBlock) {
        self.dBlock(self.dataArray[indexPath.row]);
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:20];
        for (int i = 0; i<20; i++) {
            NSString *str = [NSString stringWithFormat:@"TableView Cell Number is %d",i];
            [_dataArray addObject:str];
        }
    }
    return _dataArray;
}
- (void)setDBlock:(DidSelectBlock)dBlock{
    if (!_dBlock) {
        _dBlock = [dBlock copy];
    }
}

@end
