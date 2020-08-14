//
//  ZQFliterMenuBarViewModel.m
//  ZQFilterMenuView_Example
//
//  Created by 郑泽钦 on 2020/6/27.
//  Copyright © 2020 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import "ZQFliterMenuBarViewModel.h"
#import "ZQFliterMenuBarViewTool.h"
@implementation ZQFliterMenuBarViewModel

// 数据配置
- (void)configureData{
    [self setLocationDataSource];
    [self setTypeDataSource];
    [self setPriceDataSource];
    [self setMoreDataSource];
}

// 设置区域
- (void)setLocationDataSource{
    NSArray *locationIds = @[@"location",@"underground"];
    NSArray *locationTitles = @[@"区域",@"地铁"];
    NSArray *plistKeys = @[@"region",@"subway"];
    NSArray *secondPlistKeys = @[@"region_station",@"subway_station"];
    
    NSMutableArray *locationDataSource = [NSMutableArray array];
    for (NSInteger i = 0; i < locationIds.count; i++) {
        NSString *idStr = locationIds[i];
        NSString *titleStr = locationTitles[i];
        ZQItemModel *model = [ZQItemModel modelWithText:titleStr currentID:idStr isSelect:i == 0];
        NSArray *modelArr = [self creatMenuModels:plistKeys[i]
                                        secondKey:secondPlistKeys[i]
                                  firstSelectMode:0
                                 secondSelectMode:1
                                  firstSelectedId:@"0"
                                 secondSelectedId:@"0"
                                       faterModel:model];
        model.dataSource = modelArr;
        [locationDataSource addObject:model];
    }
    self.locationDataSource = locationDataSource;
}

// 设置类型
- (void)setTypeDataSource{
    self.typeDataSource = [self creatMenuModels:@"type"
                                       secondKey:nil
                                 firstSelectMode:0
                                secondSelectMode:0
                                 firstSelectedId:@"0"
                                secondSelectedId:nil
                                      faterModel:nil];
}

// 设置价格
- (void)setPriceDataSource{
    self.priceDataSource = [self creatMenuModels:@"price"
                                       secondKey:nil
                                 firstSelectMode:0
                                secondSelectMode:0
                                 firstSelectedId:@"0"
                                secondSelectedId:nil
                                      faterModel:nil];
}

/// 更多
- (void)setMoreDataSource{
    NSMutableArray *moreDataSource = [NSMutableArray array];
    
    ZQItemModel *specModel = [self getMoreChildDataSourceModel:@"特色" idStr:@"more_spec" firstKey:@"more_spec"];
    specModel.selectMode = 1;//设置都为复选 ，支持单个复选 只需涉及模型里的子数据源为1即可
    [moreDataSource addObject:specModel];
    
    ZQItemModel *areaModel = [self getMoreChildDataSourceModel:@"面积" idStr:@"more_area" firstKey:@"more_area"];
    [moreDataSource addObject:areaModel];
    
    ZQItemModel *ageModel = [self getMoreChildDataSourceModel:@"房龄" idStr:@"more_age" firstKey:@"more_age"];
    [moreDataSource addObject:ageModel];
    
    ZQItemModel *typeModel = [self getMoreChildDataSourceModel:@"类型" idStr:@"more_type" firstKey:@"more_type"];
    [moreDataSource addObject:typeModel];
    
    self.moreDataSource = moreDataSource;
}

#pragma mark - Private Method
- (NSArray<ZQItemModel *> *)creatMenuModels:(NSString *)firstKey
                                  secondKey:(NSString *)secondKey
                            firstSelectMode:(NSInteger)firstSelectMode
                           secondSelectMode:(NSInteger)secondSelectMode
                            firstSelectedId:(NSString *)firstSelectedId
                           secondSelectedId:(NSString *)secondSelectedId
                                 faterModel:(ZQItemModel *)faterModel{
    NSMutableArray *modelArr = [NSMutableArray array];
    //第一級
    NSArray *firstArr = [ZQFliterMenuBarViewTool getSortArrayConfigKey:firstKey];
    
    //是否显示第三级别
    BOOL isShowSecond = secondKey != nil;
    
    //第二級
    NSDictionary *secondDic = [ZQFliterMenuBarViewTool getConfigPlistKey:secondKey];
    NSDictionary *secondArrDic = [ZQFliterMenuBarViewTool getChildArrDictionaryConfigDic:secondDic];
    
    //遍历数据源
    for (NSInteger i = 0; i < firstArr.count; i++) {
        NSArray *secondArr = firstArr[i];
        NSString *idStr = [secondArr firstObject];
        ZQItemModel *secondModel = [self creatMenuModel:secondArr selectedId:firstSelectedId selectMode:firstSelectMode];
        secondModel.plistKey = firstKey;
        secondModel.fatherModel = faterModel;
        [modelArr addObject:secondModel];
        if (isShowSecond) {
            //第三级别
            NSMutableArray *secondModelArr = [NSMutableArray array];
            NSArray *sectionArr = secondArrDic[idStr];
            for (NSInteger j = 0; j < sectionArr.count; j++) {
                NSArray *thirdArr = sectionArr[j];
                ZQItemModel *thirdModel = [self creatMenuModel:thirdArr selectedId:secondSelectedId selectMode:secondSelectMode];
                thirdModel.plistKey = secondKey;
                thirdModel.fatherModel = secondModel;
                [secondModelArr addObject:thirdModel];
            }
            secondModel.dataSource = secondModelArr;
        }
    }
    return modelArr;
}

- (ZQItemModel *)creatMenuModel:(NSArray *)arr selectedId:(NSString *)selectedId selectMode:(NSInteger)selectMode{
    NSString *idStr = arr.firstObject;
    NSString *titleStr = arr.lastObject;
    BOOL isSelcted = NO;
    if (selectMode == 1) { //多选  注意多选的是,号隔开字段
        isSelcted = [ZQFliterMenuBarViewTool string:selectedId componentString:@"," isContainsStr:idStr];
    } else {//单选
        isSelcted = [idStr isEqualToString:selectedId];
    }
    ZQItemModel *model = [ZQItemModel modelWithText:titleStr currentID:idStr isSelect:isSelcted];
    model.selectMode = selectMode;
    if ([idStr isEqualToString:@"0"]) { //不限的默认全单选 后续跟进业务进行调整
        model.selectMode = 0;
    }
    return model;
}

- (ZQItemModel *)getMoreChildDataSourceModel:(NSString *)titleStr
                                       idStr:(NSString *)idStr
                                    firstKey:(NSString *)firstKey{
    ZQItemModel *model = [ZQItemModel modelWithText:titleStr currentID:idStr isSelect:NO];
    model.dataSource = [self creatMenuModels:firstKey secondKey:nil firstSelectMode:0 secondSelectMode:0 firstSelectedId:@"" secondSelectedId:@"" faterModel:nil];
    return model;
}

@end
