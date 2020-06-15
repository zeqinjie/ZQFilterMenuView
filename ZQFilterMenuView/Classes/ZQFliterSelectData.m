//
//  ZQFliterSelectData.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import "ZQFliterSelectData.h"
#import "ZQFliterModelHeader.h"
#import <objc/runtime.h>
#define kMAXCount  3 //最大多少列
#define kMutitTitle @"多選"
@implementation ZQFliterSelectData
- (NSMutableArray<NSNumber *> *)selectIndexArr{
    if (!_selectIndexArr) {
        _selectIndexArr = [NSMutableArray array];
    }
    return _selectIndexArr;
}

- (NSMutableDictionary<NSNumber*, ZQFliterSelectData*> *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
        //初始化没有选中的列数对象 用于存放三组选中的数据对象
        for (NSInteger i = 0 ; i < kMAXCount; i++) {
            ZQFliterSelectData *childSelectData = [[ZQFliterSelectData alloc]init];
            [_dict setObject:childSelectData forKey:@(i)];
        }
    }
    return _dict;
}

- (NSMutableDictionary<NSNumber*,ZQItemModel*> *)selectModelDic{
    if (!_selectModelDic) {
        _selectModelDic = [NSMutableDictionary dictionary];
    }
    return _selectModelDic;
}
#pragma mark - Father Method
///获取对应tableview 下的数据源
- (NSArray<ZQItemModel *> *)getListDataSource:(NSArray *)listDataSource listViewIndex:(NSInteger)listViewIndex{
    NSArray *lastArr = listDataSource;//获取当前组的数据
    for (NSInteger i = 0; i < listViewIndex; i++) {// listViewIndex >= 1 的时候会进入,
        if (i == listViewIndex-1) {//获取上一列的数据源 1
            ZQFliterSelectData *childSelectData = self.dict[@(i)];//获取上一组数据 如果listViewIndex = 1  则取下标i = 0
            NSNumber *selectIndex = childSelectData.selectIndexArr.firstObject;//获取上一组选中index
            if (selectIndex) {//第一次选中的对象
                ZQItemModel *selectModel = childSelectData.selectModelDic[selectIndex];//获取选中上一组的model
                if (selectModel) {
                    lastArr = selectModel.dataSource;//返回选中的子数据源组
                }else{//如果没有选择任何项 默认展示第一项的数据源
                    lastArr = [self getFirstListDataSource:lastArr listViewIndex:listViewIndex];
                }
                break;
            }else{
                lastArr = [self getFirstListDataSource:lastArr listViewIndex:listViewIndex];
            }
        }
    }
    
    return lastArr;
}

/// 如果上一组数据源没有选择，则取上一组的第一项数据源作为当前数据源返回  fix bug 待思考处理 by zzq
/// @param listDataSource 上一组的数据源
/// @param listViewIndex 当前展示的tableViewt.tag 即时第几列
- (NSArray *)getFirstListDataSource:(NSArray *)listDataSource listViewIndex:(NSInteger)listViewIndex{
    NSArray *lastArr = listDataSource;
    ZQItemModel *selectModel = lastArr.firstObject;
    lastArr = selectModel.dataSource;
    return lastArr;
}

///獲取三組選中的下標
- (NSArray <NSNumber *> *)getAllSelectIndexArr:(BOOL)isFirst{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0 ; i < kMAXCount; i++) {
        ZQFliterSelectData *childSelectData = self.dict[@(i)];
        if (childSelectData) {
            [childSelectData sortSelectIndexArrArr];
            NSNumber *index = childSelectData.selectIndexArr.firstObject;
            if (index) {
                [arr addObject:index];
            }else{//没有选择默认选中第一项
                if(isFirst) {
                    [arr addObject:@(0)];
                }else{
                    [arr addObject:@(-1)];
                }
            }
        }else{//没有选择默认选中第一项
            if(isFirst) {
                [arr addObject:@(0)];
            }else{
                [arr addObject:@(-1)];
            }
        }
    }
    return arr;
}

/// 获取选择的多少列
- (NSInteger)getChoiceCount{
    NSInteger count = 0;
    for (NSInteger i = 0; i < kMAXCount; i++) {
        ZQFliterSelectData *childSelectData = self.dict[@(i)];
        if (childSelectData && childSelectData.selectModelDic.count) {
            count++;
        }
    }
    return count;
}

- (NSInteger)getShowListViewCount{
    NSInteger count = [self getShowListViewCount:1];
    if (count > kMAXCount) {//限制越界
        count = kMAXCount;
    }
    return count;
}

/// 需要展示多少列 默认传1
- (NSInteger)getShowListViewCount:(NSInteger)count{
    ZQFliterSelectData *childSelectData = self.dict[@(count-1)];
    if (childSelectData.selectModelDic.count) {//第一列一定有选择的 如果没有呢？
        ZQItemModel *selectModel = [childSelectData getFirstSelectModel];//第一列选择数据model
        if (selectModel.dataSource.count) {
            count++;//选中有子数据源，展示二列
            count = [self getShowListViewCount:count];
        }
    }
    return count;
}

/// 移除子数据模型的所有数据
- (void)removeSonSelectDataAllSelectModel{
    [self removeSonSelectDataAllSelectModelSelectIndex:-1];
}

/// 移除子数据模型的所有数据
- (void)removeSonSelectDataAllSelectModelSelectIndex:(NSInteger)selectIndex{
    NSInteger lastListViewIndex = selectIndex+1;
    for (NSInteger i = lastListViewIndex; i < kMAXCount; i++) {
        ZQFliterSelectData *obj = self.dict[@(i)];
        [obj removeAllSelectModel];
    }
}

/// 更新并初始化子选择数据model
/// @param listDataSource 数据源
/// @param selectIndex 下标 必须是-1 方便递归计算
/// return 返回選中的title 如果有選擇否則返回nil
- (NSString *)reloadSeletedListDataSource:(NSArray<ZQItemModel *> *)listDataSource
                              selectIndex:(NSInteger)selectIndex{
    NSString *selectTitle = nil;
    if (listDataSource && listDataSource.count) {
        selectIndex++;
        BOOL isFirstIndex = YES;
        for (NSInteger i = 0;i < listDataSource.count ;i++) {
            ZQItemModel *model = listDataSource[i];
            if (selectIndex < kMAXCount) { //最大支持三个级列表
                if (model.seleceted) {//如果有选中
                    ZQFliterSelectData *childSelectData = self.dict[@(selectIndex)];
                    NSNumber *indexNum = @(i);
                    [childSelectData.selectIndexArr addObject:indexNum]; //把选中下标加入数据源
                    [childSelectData.selectModelDic setObject:model forKey:indexNum];
                    if (isFirstIndex) {//選擇第一項
                        isFirstIndex = NO;
                        [self.selectIndexArr addObject:indexNum];
                        if (![model isShowUnlimited]) {
                            selectTitle = model.displayText;
                        }
                    }
                    NSArray *dataSource = model.dataSource;
                    NSString *childSelectTitle = [self reloadSeletedListDataSource:dataSource selectIndex:selectIndex];
                    if (childSelectTitle) {
                        selectTitle = childSelectTitle;
                    }
                }
            }
        }
    }
    return selectTitle;
}

/// 更新数据选择项
/// @param listDataSource 数据源
/// @param orginSelectData 重置数据源 非必传，重置需要,否则只是更新model 的 selected
/// @param selectIndex listIndex 必须传-1 方便递归计算
/// @param flag 0 默认方式，如果为1 如果只选中第一列任何一项，则重置为第一项区域
- (void)updateSeletedListDataSource:(NSArray<ZQItemModel *> *)listDataSource
                    orginSelectData:(nullable ZQFliterSelectData *)orginSelectData
                        selectIndex:(NSInteger)selectIndex
                               flag:(NSInteger)flag{
    if (listDataSource && listDataSource.count) {
        selectIndex++;
        if (selectIndex < kMAXCount) { //最大支持三个级列表
            ZQFliterSelectData *originChildSelectData = orginSelectData.dict[@(selectIndex)];//重置的数据选择项
            ZQFliterSelectData *childSelectData = self.dict[@(selectIndex)];//当前的选中项
            for (NSInteger i = 0;i < listDataSource.count ;i++) {
                ZQItemModel *model = listDataSource[i];
                if (originChildSelectData) { //存在重置数据源，则重置回最初的数据
                    if ([originChildSelectData isChoiceModel:model]) {
                        [childSelectData addSelectModel:model row:i];
                    }else{
                        [childSelectData removeSelectModel:model];
                    }
                }else{
                    //否则做selected状态更新
                    if ([childSelectData isChoiceModel:model]) {
                        model.seleceted = YES;
                    }else{
                        model.seleceted = NO;
                    }
                }
                NSArray *dataSource = model.dataSource;
                [self updateSeletedListDataSource:dataSource orginSelectData:orginSelectData selectIndex:selectIndex flag:flag];
            }
        }
    }
}

/// 一直清空下一组数据源
/// @param listViewIndex 当前tableview 的tag。输入-1 默认从第0列开始
/// @param lastDataSource 数据源
- (void)resetSelectLastModelDataSource:(NSArray<ZQItemModel *> *)lastDataSource
                         listViewIndex:(NSInteger)listViewIndex{
    NSInteger lastListViewIndex = listViewIndex+1;//取下一组数据源
    ZQFliterSelectData *fatherChildData = self.dict[@(listViewIndex)]; //父组选择数据对象
    ZQFliterSelectData *lastChildData = self.dict[@(lastListViewIndex)];//当前选择数据对象
    if (lastChildData) { //下一组数据源清空
        if (lastDataSource.count) {//父有选中数据，且如果当前组有选，且下一组是有数据
            ZQItemModel *lastFirstModel = lastDataSource.firstObject;
            if (fatherChildData.selectModelDic.count && [lastFirstModel isShowUnlimited]) {//  父有选中数据，且如果当前组有选，且下一组是有数据 设置默认选中
                [lastChildData removeAllSelectModelAndAddModel:lastFirstModel row:0];
            }else{
                [lastChildData removeAllSelectModelAndAddModel:lastFirstModel row:-1];
            }
            [self resetSelectLastModelDataSource:lastFirstModel.dataSource
                                   listViewIndex:lastListViewIndex];
        }else{
            [lastChildData removeAllSelectModel];//最后一组数据
        }
    }
}

/// 添加第几组数据源 选择为第一项
/// @param listDataSource 数据源
/// @param index 第几组
- (ZQItemModel *)addFirstSelectedModelDataSource:(NSArray<ZQItemModel *> *)listDataSource
                                           index:(NSInteger)index{
    ZQFliterSelectData *childSelectData = self.dict[@(index)];
    ZQItemModel *firstModel = listDataSource.firstObject;
    [childSelectData addSelectModel:firstModel row:0];
    return firstModel;
}

/// 获取显示标题
- (NSString *)getActionDisplayText{
    NSString *displayText;
    for (NSInteger i = 0; i < kMAXCount; i++) {
        NSInteger j = kMAXCount - i - 1;
        ZQFliterSelectData *childSelectData = self.dict[@(j)];
        if (childSelectData.selectModelDic.count) {
            ZQItemModel *selectModel = [childSelectData getFirstSelectModel];
            if (childSelectData.selectModelDic.count > 1) {//多选
                return kMutitTitle;
            }else{
                if ([selectModel isShowUnlimited]) {
                    return selectModel.faterModel.displayText;
                }else{
                    return selectModel.displayText;
                }
            }
        }
    }
    return displayText;
}

/// 获取当前选择的参数
- (NSDictionary *)getSelectParameDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < kMAXCount; i++) {
        ZQFliterSelectData *childSelectData = self.dict[@(i)];
        if (childSelectData.selectModelDic.allValues.count) {
            NSString *idKey = @"";
            NSMutableArray *idKeyArr = [NSMutableArray array];
            for (ZQItemModel *model in childSelectData.selectModelDic.allValues) {
                idKey = ZQNullClass(model.plistKey);
                [idKeyArr addObject:ZQNullClass(model.currentID)];
            }
            NSString *idStr = [idKeyArr componentsJoinedByString:@","];
            [dic setObject:idStr forKey:idKey];
        }
    }
    return dic;
}

#pragma mark - Child Method
/// 获取第一个选中数据
- (ZQItemModel *)getFirstSelectModel{
    if (self.selectModelDic.count) {
        NSNumber *index = self.selectIndexArr.firstObject;
        return self.selectModelDic[index];
    }
    return nil;
}

/// 是否选中数据
- (BOOL)isChoiceModel:(ZQItemModel *)selectModel{
    return [self.selectModelDic.allValues containsObject:selectModel];
}

/// 选中的个数
- (NSInteger)hadSelectedCount{
    return self.selectModelDic.allValues.count;
}

/// 移除所有选中并添加选中的
- (void)removeAllSelectModelAndAddModel:(ZQItemModel *)selectModel row:(NSInteger)row{
    [self removeAllSelectModel];
    [self addSelectModel:selectModel row:row];
}

/// 清空所有
- (void)removeAllSelectModel{
    [self.selectModelDic removeAllObjects];
    [self.selectIndexArr removeAllObjects];
}


/// 移除選擇中数据
/// @param model 选中对象
- (void)removeSelectModel:(ZQItemModel *)model{
    if ([self isChoiceModel:model]) { //包含
        __block NSNumber *selectKey = nil;
        [self.selectModelDic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, ZQItemModel * _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj == model) {
                selectKey = key;
                *stop = YES;
            }
        }];
        [self.selectIndexArr removeObject:selectKey];
        [self.selectModelDic removeObjectForKey:selectKey];
        [self sortSelectIndexArrArr];
    }
}

/// 加入数据源
/// @param model 选中对象
/// @param row 下标需>0
- (void)addSelectModel:(ZQItemModel *)model row:(NSInteger)row{
    if (model && row > -1 &&![self isChoiceModel:model]) {
        NSNumber *rowNum = @(row);
        if (![self.selectIndexArr containsObject:rowNum]) {
            [self.selectModelDic setObject:model forKey:rowNum];
            [self.selectIndexArr addObject:rowNum];
        }
        [self sortSelectIndexArrArr];
    }
}

#pragma mark - Private Method
//排序数组
- (void)sortSelectIndexArrArr{
    [self.selectIndexArr sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if (obj1.integerValue < obj2.integerValue ){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedDescending;
        }
    }];
}

#pragma mark - Class Method
/// 当前数据源是否有子数据源
/// @param dataSource 当前数据源
+ (BOOL)isHaveChildModel:(NSArray<ZQItemModel *> *)dataSource{
    for (ZQItemModel *model in dataSource) {
        if (model.dataSource.count) {
            return YES;
        }
    }
    return NO;
}


/// 重置所有选择项，包括子对象数组 需要的数据源
/// @param dataSource 数据源
/// @param row 选中的下标 >-1 才能设置
/// @param type 重置类型  type = 0 所有数据源重置  1 如果是子的不限默认选中
/// @param selectIndex listIndex 必须传-1 方便递归计算
+ (void)resetAllSelectDataSource:(NSArray<ZQItemModel *> *)dataSource
                            type:(NSInteger)type
                             row:(NSInteger)row
                     selectIndex:(NSInteger)selectIndex{
    __block NSInteger i = selectIndex;
    [dataSource enumerateObjectsUsingBlock:^(ZQItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (type == 0) {
            model.seleceted = NO;
        }else{
            if (type != 0) {
                if ([model isShowUnlimited]) {
                    model.seleceted = YES;
                }else{
                    model.seleceted = NO;
                }
            }else{
                model.seleceted = NO;
            }
        }
        if (model.dataSource.count) {
            i++;
            [self resetAllSelectDataSource:model.dataSource type:type row:-1 selectIndex:i];
        }
    }];
    ///不做设置选中
    if (row > -1 && dataSource.count > row) {
        ZQItemModel *selectModel = [dataSource objectAtIndex:row];
        selectModel.seleceted = YES;
    }
}

ZQLuckyMutableCopyImplementation

@end
