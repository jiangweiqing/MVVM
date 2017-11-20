//
//  ViewModel.h
//  TopScrollView
//
//  Created by jiang on 2017/11/20.
//  Copyright © 2017年 jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DidSelectBlock)(id model);

@protocol ViewModelProtocol <NSObject>
@required
@optional
@end

@interface ViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype) initWithTableView:(UITableView *)tableView;
- (instancetype) initWithTableView:(UITableView *)tableView modelClass:(NSString *)className;
- (void)refreshDataCompletion:(void(^)(void))completion failure:(void(^)(NSInteger  errorCode))failure;
- (void)loadMoreDataCompletion:(void(^)(BOOL scuess))completion failure:(void(^)(NSInteger  errorCode))failure;
@end
