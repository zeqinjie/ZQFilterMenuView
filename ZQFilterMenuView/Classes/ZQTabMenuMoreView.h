//
//  ZQTabMenuMoreView.h
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//

#import <UIKit/UIKit.h>
#import "ZQItemModel.h"
#import "ZQTabControl.h"
#import "ZQTabMenuPriceView.h"
@class ZQTabMenuEnsureView;
@class ZQTabMenuMoreFilterData;
@class ZQFilterMenuMoreViewConfig;
@class ZQFilterMenuEnsureViewConfig;
@class ZQFilterMenuRangeViewConfig;
@interface ZQTabMenuMoreView : UIView
/// 点击确定按钮时  选择的回调
@property (nonatomic, copy) void (^selectBlock) (ZQTabMenuMoreView *view, ZQTabMenuMoreFilterData *selectData);
/// 每次 点击选中/取消选中条目时 获取实时选中项数据的回调   还未点击确定按钮
@property (nonatomic, copy) void (^getCurrentSelectingBlock) (ZQTabMenuMoreView *view, BOOL isSelect, ZQItemModel *model, ZQTabMenuMoreFilterData *selectData);

/// 输入框选中
@property (nonatomic, copy) void (^inputSelectBlock)(ZQTabMenuMoreView *view, NSInteger tag, NSString *title, NSDictionary *idDic);
@property (nonatomic, copy) void (^ensureInputTypeBlock)(ZQTabMenuPriceViewInputIncorrectType incorrectType); // 确认点击时输入的状态回调

@property (nonatomic, strong) NSArray <ZQItemModel *>*listDataSource;
@property (nonatomic, weak) ZQTabControl *tabControl;
/// 底部按钮视图
@property (nonatomic, strong) ZQTabMenuEnsureView *ensureView;
/// 底部输入框视图
@property (nonatomic, strong) ZQTabMenuPriceView *inputView;
/// 筛选数据
@property (nonatomic, strong) ZQTabMenuMoreFilterData *fliterData;
/** 是否是自定义输入 */
@property (nonatomic, assign) BOOL isCustomizeEnter;

/// 将要出现时候调用,需实现
- (void)tabMenuViewWillAppear;

/// 消失时候的调用,需实现
- (void)tabMenuViewWillDisappear;

/// 设置选中状态
- (void)setTabControlTitle;

/// 初始化更多控件
/// @param moreViewConfig 更多控件的配置对象
/// @param ensureViewConfig 确定按钮配置对象
- (instancetype)initWithMoreViewConfig:(ZQFilterMenuMoreViewConfig *)moreViewConfig
                      ensureViewConfig:(ZQFilterMenuEnsureViewConfig *)ensureViewConfig;

/// 初始化更多控件
/// @param moreViewConfig 更多控件的配置对象
/// @param rangeViewConfig 输入框范围的控件 （价格）
- (instancetype)initWithMoreViewConfig:(ZQFilterMenuMoreViewConfig *)moreViewConfig
                       rangeViewConfig:(ZQFilterMenuRangeViewConfig *)rangeViewConfig;
@end


