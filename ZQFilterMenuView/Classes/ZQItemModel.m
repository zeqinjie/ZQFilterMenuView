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
    if ([self.currentID isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}


ZQLuckyMutableCopyImplementation

@end
