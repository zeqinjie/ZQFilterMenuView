//
//  ZQTabMenuPriceFooterView.h
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//
#import <UIKit/UIKit.h>
#import "ZQTabControl.h"
@class ZQFilterMenuRangeViewConfig;
//NSString *idStr,
typedef void(^ZQTabInputValueBlock)(NSInteger tag,NSString *title,NSDictionary *idDic);
@interface ZQTabMenuPriceView : UIView
@property (nonatomic, copy) ZQTabInputValueBlock inputValueBlock;
@property (nonatomic, copy) void (^incompatibleBlock)(void); //確認點擊不符合Block
@property (nonatomic, weak) ZQTabControl *tabControl;
@property (nonatomic, copy) void (^startEditBlock)(void); //开始编辑Block
- (void)setMaxprice:(NSString *)maxprice minprice:(NSString *)minprice;

- (instancetype)initWithConfig:(ZQFilterMenuRangeViewConfig *)config;

///重置输入内容
- (void)resetInputText;

@end

