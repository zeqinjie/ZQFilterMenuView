//
//  ZQItemModel.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import "ZQItemModel.h"
#import "ZQFliterModelHeader.h"
#import <objc/runtime.h>

@interface ZQItemModel ()
/// 用于提供数据showDataSource给外部访问, 存储 ZQItemModel对象
@property (nonatomic, strong) NSMutableArray<ZQItemModel*> *privateShowDataSouce;
@end

@implementation ZQItemModel

- (instancetype)init{
    if (self = [super init]) {
        self.unlimited = @"0"; // 默认为 0
    }
    return self;
}

+ (instancetype)modelWithText:(NSString *)text currentID:(NSString *)currentID isSelect:(BOOL)select {
    ZQItemModel *model = [[ZQItemModel alloc] init];
    model.displayText = text;
    model.currentID = currentID;
    model.seleceted = select;
    return model;
}

- (void)setDataSource:(NSArray<ZQItemModel *> *)dataSource {
    _dataSource = dataSource;
    [self refreshShowDataSource];
}

/// 更新showDataSource
- (void)refreshShowDataSource {
    [self.privateShowDataSouce removeAllObjects];
    if (!self.dataSource) {
        return;
    }
    for (ZQItemModel *model in self.dataSource) {
        if (!model.isHide) {
            [self.privateShowDataSouce addObject:model];
        }
    }
}

/// 根据传入的id数组  设置子模型点击重置之后的默认选中项
- (void)setDataSourceResetDefualtSelectStateWithIDArr:(NSArray *)ids {
    if (!self.dataSource || !ids) {
        return;
    }
    for (ZQItemModel *model in self.dataSource) {
        if ([ids containsObject:model.currentID]) {
            model.isResetDefaultSelect = true;
        } else {
            model.isResetDefaultSelect = false;
        }
    }
}

- (NSMutableArray<ZQItemModel*> *)selectSonDataModels{
    if (!_selectSonDataModels) {
        _selectSonDataModels = [NSMutableArray array];
    }
    return _selectSonDataModels;
}

- (NSMutableArray<ZQItemModel *> *)privateShowDataSouce {
    if (!_privateShowDataSouce) {
        _privateShowDataSouce = [NSMutableArray array];
    }
    return _privateShowDataSouce;
}

- (BOOL)isHaveSecondSource{
    if (_dataSource.count) {
        return YES;
    }
    return NO;
}

- (BOOL)isShowUnlimited{
    if ([self.currentID isEqualToString:self.unlimited]) {
        return YES;
    }
    return NO;
}

/// 获取展示
-(NSArray<ZQItemModel *> *)showDataSource {
    return self.privateShowDataSouce;
}

/// 递归获取祖父model
- (ZQItemModel *)getGrandFatherModel{
    return [self getGrandFatherModelWithItemModel:self.fatherModel];
}

- (ZQItemModel *)getGrandFatherModelWithItemModel:(ZQItemModel *)faterModel {
    ZQItemModel *fater = faterModel.fatherModel;
    if (fater == nil) {
        return faterModel;
    } else {
        return [self getGrandFatherModelWithItemModel:fater];
    }
    return nil;
}
ZQLuckyMutableCopyImplementation

@end
