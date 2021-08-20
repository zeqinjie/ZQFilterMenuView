//
//  ZQTabMenuView.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import <UIKit/UIKit.h>
#import "ZQItemModel.h"
#import "ZQFliterSelectData.h"
#import "ZQFilterMenuConfig.h"
@class ZQTabControl, ZQTabMenuView;

@protocol ZQTabMenuViewDelegate <NSObject>

@required
/// 将要出现代理
- (void)tabMenuViewWillAppear:(ZQTabMenuView *)view;
/// 将要消失代理
- (void)tabMenuViewWillDisappear:(ZQTabMenuView *)view;

@optional
/// footer view 代理
- (UIView *)tabMenuViewFooterView:(ZQTabMenuView *)view;
/// section footerView 代理
- (UIView *)tabMenuViewSectionFooterView:(ZQTabMenuView *)view;
/// section footerView 高度代理
- (CGFloat)tabMenuViewSectionFooterViewHeight:(ZQTabMenuView *)view;
/// section headerView 代理
- (UIView *)tabMenuViewSectionHeaderView:(ZQTabMenuView *)view;
/// section headerView 高度代理
- (CGFloat)tabMenuViewSectionHeaderViewHeight:(ZQTabMenuView *)view;
/// 指定弹出菜单添加的父视图
- (UIView *)tabMenuViewToSuperview;

@end


@interface ZQTabMenuView : UIView
@property (nonatomic, strong) ZQTabControl *tabControl;

@property (nonatomic, weak) id<ZQTabMenuViewDelegate>delegate;

/// 禁止前选中回调， 原使用 block 返回 bool, 不过涉及异步操作，暂时为属性 ensureClickDisable 控制
@property (nonatomic, copy) ZQTabEnsureClickDisable ensureClickDisableBlock;
/// 是否禁止确定 默认不禁止
@property (nonatomic, assign) BOOL ensureClickDisable;

/// 初始化 ZQTabControl 控件
- (instancetype)initWithTabControl:(ZQTabControl *)tabControl;

/// 菜单添加到父视图
/// @param menuBar 菜单栏View
/// @param offsetY 额外偏移量
- (void)displayTabMenuViewWithMenuBar:(UIView *)menuBar withTopOffsetY:(CGFloat)offsetY;

/// 重置所有选择项，包括子对象数组
- (void)resetAllSelectData;

/// 刷新所有 tableView
- (void)reloadAllList;

/// 隐藏
- (void)dismiss;

/// 刷新选中数据UI
- (void)reloadSeletedListDataSource;

/// 模拟点击 tableView cell
/// @param indexPaths 下标数据源对象; 数组里存储的是多个数组[NSIndexPath]，代表每一列的; NSIndexPath 代表点击的 indexPath
- (void)didSelectTableViewIndexPaths:(NSArray<NSArray<NSIndexPath *> *> *)indexPaths;

///  是否已展示 menuView
- (BOOL)isHadShow;

/// 多选的按钮确认操作
- (void)ensureAction;

@end
