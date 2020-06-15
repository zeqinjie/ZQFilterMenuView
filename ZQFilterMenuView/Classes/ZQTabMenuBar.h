//
//  ZQTabMenuBar.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import <UIKit/UIKit.h>

@class ZQTabControl, ZQTabMenuBar;

@protocol ZQTabMenuBarDelegate <NSObject>

- (void)tabMenuViewWillAppear:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;
- (void)tabMenuViewWillDisappear:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;
- (UIView *)tabMenuViewFooterView:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl;

@optional
- (UIView *)tabMenuViewToSuperview; //指定弹出菜单添加的父视图 wyg 添加
@end


@interface ZQTabMenuBar : UIView

@property (nonatomic, strong) NSArray <ZQTabControl *>*tabControls;
@property (nonatomic, weak) id<ZQTabMenuBarDelegate>delegate;
@property (nonatomic, assign) BOOL isShowBottomLine;
@property (nonatomic, assign) CGFloat menuTopOffsetY; //菜单弹出距离顶部偏移量
- (instancetype)initWithTabControls:(NSArray<ZQTabControl *>*)tabControls;
- (instancetype)initWithTabControls:(NSArray<ZQTabControl *>*)tabControls
                         styleColor:(UIColor *)styleColor;

//去掉当前展示的menu的所有选择项
- (void)clearShowMenuAllSelected;
//重新刷新当前展示的menu
- (void)reloadMenus;
// 刷新指定下标的表
- (void)reloadMenusIndex:(NSInteger)index;
//隐藏所有菜单
- (void)dismiss;
@end
