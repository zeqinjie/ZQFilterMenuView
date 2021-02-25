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

- (NSMutableDictionary *)lastMoreSeletedAllDic {
    if (!_lastMoreSeletedAllDic) {
        _lastMoreSeletedAllDic = [NSMutableDictionary dictionary];
    }
    return _lastMoreSeletedAllDic;
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
        [self.lastMoreSeletedAllDic setObject:seletedIdArr forKey:ZQNullClass(itemModel.currentID)];
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
        if (arr.count) { //保存选择的
            NSMutableArray *resultArr = [NSMutableArray array];
            for (ZQItemModel *model in arr) {
                [resultArr addObject:model.currentID];
            }
            [self.lastMoreSeletedDic setObject:resultArr forKey:ZQNullClass(itemModel.currentID)];
            [self.lastMoreSeletedAllDic setObject:resultArr forKey:ZQNullClass(itemModel.currentID)];
        } else { // 保存未选择的
            [self.lastMoreSeletedAllDic setObject:[NSMutableArray array] forKey:ZQNullClass(itemModel.currentID)];
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
        if (model.selectMode != ZQItemModelSelectModeMultiple && selectModel != model) {
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

///移除不限对象
- (void)removeUnlimitedModelWithArr:(NSMutableArray<ZQItemModel *> *)arr {
    NSMutableArray *removeArr = [NSMutableArray array];
    for (ZQItemModel *model in [arr objectEnumerator]) {
        if ([model isShowUnlimited]) {
            [removeArr addObject:model];
        }
    }
    if (removeArr.count) {
        [arr removeObjectsInArray:removeArr];
    }
}

///獲取選中後的所有標題
- (NSDictionary *)getSelectedAllTitleDicSeparator:(NSString *_Nullable)separator {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    __block NSString *tempStr = @"";
    if (separator == nil) {//默认空格
        separator = @" ";
    }
    [self.moreSeletedDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<ZQItemModel *> * _Nonnull obj, BOOL * _Nonnull stop) {
        __block NSString *str = @"";
        [obj enumerateObjectsUsingBlock:^(ZQItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx == 0) {
                str = [NSString stringWithFormat:@"%@",model.displayText];
                tempStr = str;
            } else {
                str = [NSString stringWithFormat:@"%@%@%@",str,separator,model.displayText];
                tempStr = [NSString stringWithFormat:@"%@%@%@",tempStr,separator,model.displayText];
            }
        }];
        [dic setValue:str forKey:key];
    }];
    return @{@"title": tempStr, @"dic": dic};
}

///获取选择的个数
- (NSInteger)getSelectCount{
    NSInteger count = 0;
    for (NSArray *models in self.moreSeletedDic.allValues) {
        count += models.count;
    }
    return count;
}
@end
