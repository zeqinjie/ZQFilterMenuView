//
//  ZQTabMenuPriceFooterView.h
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//
#import <UIKit/UIKit.h>
#import "ZQTabControl.h"
@class ZQFilterMenuRangeViewConfig;
typedef NS_ENUM(NSInteger ,ZQTabMenuPriceViewInputIncorrectType) {
    ZQTabMenuPriceViewInputIncorrectTypeIncorrect, // 正确输入
    ZQTabMenuPriceViewInputIncorrectTypeNoInput, // 没有输入值
    ZQTabMenuPriceViewInputIncorrectTypeMaxIncorrect, // 输入最大值需大於最小值
    ZQTabMenuPriceViewInputIncorrectTypeMinIncorrect, // 输入最小值需小余最大值
};

typedef void(^ZQTabInputValueBlock)(NSInteger tag, NSString *title, NSDictionary *idDic);
@interface ZQTabMenuPriceView : UIView
@property (nonatomic, copy) ZQTabInputValueBlock inputValueBlock; // 确认点击有值的回调
@property (nonatomic, copy) void (^ensureInputTypeBlock)(ZQTabMenuPriceViewInputIncorrectType incorrectType); // 确认点击时输入的状态回调
@property (nonatomic, weak) ZQTabControl *tabControl;
@property (nonatomic, copy) NSString *lastValidMinText; //最后有效最小值
@property (nonatomic, copy) NSString *lastValidMaxText; //最后有效最大值
@property (nonatomic, copy) void (^startEditBlock)(void); //开始编辑Block
- (void)setMaxprice:(NSString *)maxprice minprice:(NSString *)minprice;

- (instancetype)initWithConfig:(ZQFilterMenuRangeViewConfig *)config;

///重置输入内容
- (void)resetInputText;

/// 恢复或者清空最后一次输入的有效值
- (void)validlastTextRestoreOrClear:(BOOL)isRestore;

@end

