//
//  ZQTabMenuMoreFilterData.m
//  house591
//
//  Created by zhengzeqin on 2020/5/27.
//

#import "ZQTabMenuMoreFilterData.h"
#import "ZQFliterModelHeader.h"
@interface ZQTabMenuMoreFilterData()

@end

@implementation ZQTabMenuMoreFilterData

- (NSMutableDictionary *)moreSeletedDic{
    if (!_moreSeletedDic) {
        _moreSeletedDic = [NSMutableDictionary dictionary];
    }
    return _moreSeletedDic;
}

- (NSMutableDictionary *)lastMoreSeletedDic{
    if (!_lastMoreSeletedDic) {
        _lastMoreSeletedDic = [NSMutableDictionary dictionary];
    }
    return _lastMoreSeletedDic;
}

#pragma mark - Public Method
/// 设置数据源对象
- (void)setListDataSource:(NSArray<ZQItemModel *> *)listDataSource{
    for (ZQItemModel *itemModel in listDataSource) {
        NSMutableArray *seletedArr = [NSMutableArray array];
        NSMutableArray *seletedIdArr = [NSMutableArray array];
        for (ZQItemModel *childModel in itemModel.dataSource) {
            if (childModel.seleceted) {
                [seletedArr addObject:childModel];
                [seletedIdArr addObject:childModel.currentID];
            }
        }
        [self.moreSeletedDic setObject:seletedArr forKey:ZQNullClass(itemModel.currentID)];
        [self.lastMoreSeletedDic setObject:seletedIdArr forKey:ZQNullClass(itemModel.currentID)];
    }
}

- (void)resetChoiceReloadDataSource:(NSArray<ZQItemModel *> *)listDataSource{
    for (ZQItemModel *itemModel in listDataSource) {
        NSArray<NSString *> *seletedIdArr = self.lastMoreSeletedDic[ZQNullClass(itemModel.currentID)];
        //获取选中数据
        NSMutableArray *seletedModelsArr = self.moreSeletedDic[ZQNullClass(itemModel.currentID)];
        [seletedModelsArr removeAllObjects];
        for (ZQItemModel *model in itemModel.dataSource) {
            if ([seletedIdArr containsObject:model.currentID]) {
                [seletedModelsArr addObject:model];
            }
        }
    }
}

/// 移除所有选中的数据
- (void)removeAllSelectData{
    [self.moreSeletedDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<ZQItemModel *> * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeAllObjects];
    }];
}

/// 设置最后选中数据
- (void)setLastSelectedDataSource:(NSArray <ZQItemModel*>*)listDataSource{
    [self.lastMoreSeletedDic removeAllObjects];
    for (ZQItemModel *itemModel in listDataSource) {
        NSMutableArray *arr = self.moreSeletedDic[ZQNullClass(itemModel.currentID)];
        if (arr.count) {
            NSMutableArray *resultArr = [NSMutableArray array];
            for (ZQItemModel *model in arr) {
                [resultArr addObject:model.currentID];
            }
            [self.lastMoreSeletedDic setObject:resultArr forKey:ZQNullClass(itemModel.currentID)];
        }
    }
}

/// 是否选中
- (BOOL)isHadSelected{
    BOOL isSelected = NO;
    for (NSMutableArray *selectIdArr in self.lastMoreSeletedDic.allValues) {
        if (selectIdArr.count) {
            isSelected = YES;
            break;
        }
    }
    return isSelected;
}

/// 移除非複選對象 选中对象不移除
- (void)removeAllExtenFixModel:(NSMutableArray<ZQItemModel *> *)arr selectModel:(ZQItemModel *)selectModel{
    for (ZQItemModel *model in [arr reverseObjectEnumerator]) {
        if (model.selectMode != 1 && selectModel != model) {
            [arr removeObject:model];
        }
    }
}

/// 複選對象操作
- (void)selectModel:(ZQItemModel *)model arr:(NSMutableArray<ZQItemModel *> *)arr {
    if ([arr containsObject:model]) {
        [arr removeObject:model];
    }else{
        [arr addObject:model];
    }
}
@end
