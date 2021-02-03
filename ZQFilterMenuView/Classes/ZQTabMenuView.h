//
//  ZQTabMenuView.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import <UIKit/UIKit.h>
#import "ZQItemModel.h"
#import "ZQFilterMenuConfig.h"
@class ZQTabControl, ZQTabMenuView;

@protocol ZQTabMenuViewDelegate <NSObject>

@required
- (void)tabMenuViewWillAppear:(ZQTabMenuView *)view;
- (void)tabMenuViewWillDisappear:(ZQTabMenuView *)view;
- (UIView *)tabMenuViewFooterView:(ZQTabMenuView *)view;
- (UIView *)tabMenuViewToSuperview; //指定弹出菜单添加的父视图
@optional

@end


@interface ZQTabMenuView : UIView
@property (nonatomic, strong) ZQTabControl *tabControl;

@property (nonatomic, weak) id<ZQTabMenuViewDelegate>delegate;

- (instancetype)initWithTabControl:(ZQTabControl *)tabControl;

/// 菜单添加到父视图
/// @param menuBar 菜单栏View
/// @param offsetY 额外偏移量
- (void)displayTabMenuViewWithMenuBar:(UIView *)menuBar withTopOffsetY:(CGFloat)offsetY;

/**
 重置数据

 @param dataSource 数据源
 @param row -1值不做选中
 */
//- (void)resetOldSelectWithDataSource:(NSArray *)dataSource selectRow:(NSInteger)row;

///重置所有选择项，包括子对象数组
- (void)resetAllSelectData;

- (void)reloadAllList;

- (void)dismiss;

//刷新选中数据UI
- (void)reloadSeletedListDataSource;
@end
