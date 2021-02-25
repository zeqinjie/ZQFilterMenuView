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

- (NSMutableArray<ZQItemModel*> *)selectSonDataModels{
    if (!_selectSonDataModels) {
        _selectSonDataModels = [NSMutableArray array];
    }
    return _selectSonDataModels;
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
