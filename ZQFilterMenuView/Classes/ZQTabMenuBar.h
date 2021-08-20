//
//  ZQTabMenuBar.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import <UIKit/UIKit.h>
#import "ZQFilterMenuConfig.h"

@class ZQTabControl, ZQTabMenuBar;

@protocol ZQTabMenuBarDelegate <NSObject>
/// 视图将要出现回调
- (void)tabMenuViewWillAppear:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;
/// 视图将要隐藏回调
- (void)tabMenuViewWillDisappear:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;
/// 返回 footer 视图
- (UIView *)tabMenuViewFooterView:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;

@optional
/// 指定弹出菜单添加的父视图
- (UIView *)tabMenuViewToSuperview:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;
/// 返回section footerView
- (UIView *)tabMenuViewSectionFooterView:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;;
/// 返回section footerView 高度
- (CGFloat)tabMenuViewSectionFooterViewHeight:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;
/// 返回section headerView
- (UIView *)tabMenuViewSectionHeaderView:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;;
/// 返回section headerView 高度
- (CGFloat)tabMenuViewSectionHeaderViewHeight:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;
/// 点击了哪个 tabControl
- (void)tabMenuView:(ZQTabMenuBar *)view didClickTabControl:(ZQTabControl *)tabControl;
@end


@interface ZQTabMenuBar : UIView

@property (nonatomic, strong) NSArray <ZQTabControl *>*tabControls;
@property (nonatomic, weak) id<ZQTabMenuBarDelegate>delegate;


/// 初始化 ZQTabMenuBar
/// @param tabControls tabControls 控件
/// @param config 配置对象
- (instancetype)initWithTabControls:(NSArray<ZQTabControl *>*)tabControls
                             config:(ZQFilterMenuBarConfig *)config;


/// 去掉当前展示的menu的所有选择项
- (void)clearShowMenuAllSelected;

/// 重新刷新当前展示的menu
- (void)reloadMenus;

/// 刷新指定下标的表
- (void)reloadMenusIndex:(NSInteger)index;

/// 隐藏所有菜单
- (void)dismiss;

/// 模拟点击 tableView cell 非真正选择
/// @param index 选中第几个 tabControl
/// @param indexPaths 下标数据源对象; 数组里存储的是多个数组[NSIndexPath]，代表每一列; NSIndexPath 代表点击的 indexPath
- (void)didSelectedMenusIndex:(NSInteger)index
          tableViewIndexPaths:(NSArray<NSArray<NSIndexPath *> *> *)indexPaths;

/// 模拟点击多选确定按钮点击
/// @param index 选中第几个 tabControl
- (void)didSelectedMenusEnsureClickIndex:(NSInteger)index;

/// 是否禁止确定
/// @param index 下标
/// @param ensureClickDisable 禁止确定，默认不禁止
- (void)setEnsureSelectedMenusIndex:(NSInteger)index
                 ensureClickDisable:(BOOL)ensureClickDisable;
@end
