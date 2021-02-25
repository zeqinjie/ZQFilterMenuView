//
//  ZQTabMenuMoreView.h
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//

#import <UIKit/UIKit.h>
#import "ZQItemModel.h"
#import "ZQTabControl.h"
@class ZQTabMenuEnsureView;
@class ZQTabMenuMoreFilterData;
@class ZQFilterMenuMoreViewConfig;
@class ZQFilterMenuEnsureViewConfig;
@class ZQFilterMenuRangeViewConfig;
@class ZQTabMenuPriceView;
@interface ZQTabMenuMoreView : UIView
// 选择的回调
@property (nonatomic, copy) void (^selectBlock) (ZQTabMenuMoreView *view, ZQTabMenuMoreFilterData *selectData);

//输入框选中
@property (nonatomic, copy) void (^inputSelectBlock)(ZQTabMenuMoreView *view, NSInteger tag, NSString *title, NSDictionary *idDic);

@property (nonatomic, strong) NSArray <ZQItemModel *>*listDataSource;
@property (nonatomic, weak) ZQTabControl *tabControl;
// 底部按钮视图
@property (nonatomic, strong) ZQTabMenuEnsureView *ensureView;
//底部输入框视图
@property (nonatomic, strong) ZQTabMenuPriceView *inputView;
// 筛选数据
@property (nonatomic, strong) ZQTabMenuMoreFilterData *fliterData;
/** 是否是自定义输入 */
@property (nonatomic, assign) BOOL isCustomizeEnter;
/// 将要出现时候调用,需实现
- (void)tabMenuViewWillAppear;
/// 消失时候的调用,需实现
- (void)tabMenuViewWillDisappear;
/// 设置选中状态
- (void)setTabControlTitle;

- (instancetype)initWithMoreViewConfig:(ZQFilterMenuMoreViewConfig *)moreViewConfig
                      ensureViewConfig:(ZQFilterMenuEnsureViewConfig *)ensureViewConfig;

- (instancetype)initWithMoreViewConfig:(ZQFilterMenuMoreViewConfig *)moreViewConfig
                       rangeViewConfig:(ZQFilterMenuRangeViewConfig *)rangeViewConfig;
@end


