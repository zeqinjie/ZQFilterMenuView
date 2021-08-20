//
//  ZQTabMenuBar.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import "ZQTabMenuBar.h"
#import "ZQTabControl.h"
#import "ZQTabMenuView.h"
#import "ZQSeperateLine.h"
#import "ZQFliterModelHeader.h"
#import "UIColor+Util.h"
@interface ZQTabMenuBar () <ZQTabMenuViewDelegate>

@property (nonatomic, assign) CGRect orginFrame;
@property (nonatomic, assign) CGRect showFilterFrame;
@property (nonatomic, strong) ZQSeperateLine *bottomLine;
@property (nonatomic, strong) NSMutableArray *menus;
//当前展示按钮
@property (nonatomic, weak) ZQTabControl *currentTab;
//当前展示menu
@property (nonatomic, weak) ZQTabMenuView *showMenuView;
/** 配置对象 */
@property (nonatomic, strong, readwrite) ZQFilterMenuBarConfig *config;

@end


@implementation ZQTabMenuBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __block CGFloat width = (self.frame.size.width - self.config.lrGap * 2 )/self.tabControls.count;
    __block CGFloat x = self.config.lrGap;
    [self.tabControls enumerateObjectsUsingBlock:^(ZQTabControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.config.widthArr && self.config.widthArr.count > idx) {
            width = [self.config.widthArr[idx] floatValue];
        }
        ZQTabControl *tabControl = obj;
        tabControl.frame = CGRectMake(x, 0, width, self.frame.size.height);
        x += width;
        [tabControl adjustFrame];
    }];
    if (!self.orginFrame.size.width) {
        self.orginFrame = self.frame;
    }
    self.showFilterFrame = CGRectMake(0, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    CGFloat lineHeight = self.config.bottomLineHeight;
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - lineHeight, self.frame.size.width, lineHeight);
}

- (instancetype)initWithTabControls:(NSArray<ZQTabControl *>*)tabControls
                             config:(ZQFilterMenuBarConfig *)config {
    if (self = [super init]) {
        _tabControls = tabControls;
        _config = config;
        [self initItems];
        self.bottomLine.hidden = !config.isShowBottomLine;
        self.bottomLine.backgroundColor = config.bottomLineColor;
        self.backgroundColor = config.backgroundColor;
    }
    return self;
}

- (void)initItems {
    ZQWS(weakSelf);
    [self.tabControls enumerateObjectsUsingBlock:^(ZQTabControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf addSubview:obj];
        
        [obj addTarget:self action:@selector(tabControlDidClick:) forControlEvents:UIControlEventTouchUpInside];
        void (^didDismissTabMenuBar)(void) = ^{
            [weakSelf dismiss];
        };
        
        [obj setValue:didDismissTabMenuBar forKeyPath:@"didDismissTabMenuBar"];
        
        ZQTabMenuView *menuView = [[ZQTabMenuView alloc] initWithTabControl:obj];
        menuView.delegate = weakSelf;
        [weakSelf.menus addObject:menuView];
        
    }];
}

- (void)setTabControls:(NSArray<ZQTabControl *> *)tabControls {
    if (_tabControls.count) {
        return;
    }
    _tabControls = tabControls;
    [self initItems];
}

- (void)tabControlDidClick:(ZQTabControl *)tabControl
{
    [self.tabControls enumerateObjectsUsingBlock:^(ZQTabControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:tabControl]) {
            obj.selected = NO;
        }
    }];
    self.currentTab = tabControl;
    NSUInteger index = [self.tabControls indexOfObject:tabControl];
    ZQTabMenuView *showMenuView = self.menus[index];
    [self.menus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZQTabMenuView *menuView = obj;
        if (![menuView isEqual:showMenuView]) {
            [menuView dismiss];
        }
    }];
    self.showMenuView = showMenuView;
    [showMenuView displayTabMenuViewWithMenuBar:self withTopOffsetY:self.config.menuTopOffsetY];
    if ([self.delegate respondsToSelector:@selector(tabMenuView:didClickTabControl:)]) {
        [self.delegate tabMenuView:self didClickTabControl:tabControl];
    }
}

#pragma mark - Private Method
- (void)adjustFrameWithShowDetail:(BOOL)show {
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = self.showFilterFrame;
            self.currentTab.selected = YES;
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = self.orginFrame;
            self.currentTab.selected = NO;
        }];
    }
}

#pragma mark - Public Method
- (void)clearShowMenuAllSelected{
    [self.showMenuView resetAllSelectData];
    [self reloadMenus];
}

- (void)reloadMenus {
    [self.showMenuView reloadAllList];
}

- (void)reloadMenusIndex:(NSInteger)index{
    ZQTabMenuView *menuView = self.menus[index];
    [menuView.tabControl adjustTitle:menuView.tabControl.title textColor:menuView.tabControl.config.titleNormalColor];
    [menuView reloadSeletedListDataSource];
}

- (void)dismiss {
    //  将其他的菜单移除
    [self.menus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZQTabMenuView *menuView = obj;
        [menuView dismiss];
    }];
}

/// 模拟点击 tableView cell 非真正选择
/// @param indexPaths 下标数据源对象
- (void)didSelectedMenusIndex:(NSInteger)index
          tableViewIndexPaths:(NSArray<NSArray<NSIndexPath *> *> *)indexPaths {
    ZQTabMenuView *menuView = self.menus[index];
    ZQTabControl *tabControl = self.tabControls[index];
    self.currentTab = tabControl;
    if (![menuView isHadShow]) { // 已经展示了的不需要再展开 menu
        [self tabControlDidClick:tabControl];
    }
    [menuView didSelectTableViewIndexPaths:indexPaths];
}

/// 模拟点击多选确定按钮点击
- (void)didSelectedMenusEnsureClickIndex:(NSInteger)index {
    ZQTabMenuView *menuView = self.menus[index];
    [menuView ensureAction];
}

- (void)setEnsureSelectedMenusIndex:(NSInteger)index
                 ensureClickDisable:(BOOL)ensureClickDisable {
    ZQTabMenuView *menuView = self.menus[index];
    menuView.ensureClickDisable = ensureClickDisable;
}

#pragma mark - ZQTabMenuBarDelegate

- (void)tabMenuViewWillAppear:(ZQTabMenuView *)view {
    [self adjustFrameWithShowDetail:YES];
    if ([self.delegate respondsToSelector:@selector(tabMenuViewWillAppear:tabControl:)]) {
        [self.delegate tabMenuViewWillAppear:self tabControl:self.currentTab];
    }
}

- (void)tabMenuViewWillDisappear:(ZQTabMenuView *)view {
    [self adjustFrameWithShowDetail:NO];
    if ([self.delegate respondsToSelector:@selector(tabMenuViewWillDisappear:tabControl:)]) {
        [self.delegate tabMenuViewWillDisappear:self tabControl:self.currentTab];
    }
}

- (UIView *)tabMenuViewFooterView:(ZQTabMenuView *)view{
    if ([self.delegate respondsToSelector:@selector(tabMenuViewFooterView:tabControl:)]) {
        return [self.delegate tabMenuViewFooterView:self tabControl:self.currentTab];
    }
    return nil;
}

- (UIView *)tabMenuViewSectionFooterView:(ZQTabMenuBar *)view {
    if ([self.delegate respondsToSelector:@selector(tabMenuViewSectionFooterView:tabControl:)]) {
        return [self.delegate tabMenuViewSectionFooterView:self tabControl:self.currentTab];
    }
    return nil;
}

- (CGFloat)tabMenuViewSectionFooterViewHeight:(ZQTabMenuView *)view {
    if ([self.delegate respondsToSelector:@selector(tabMenuViewSectionFooterViewHeight:tabControl:)]) {
        return [self.delegate tabMenuViewSectionFooterViewHeight:self tabControl:self.currentTab];
    }
    return 0;
}

- (UIView *)tabMenuViewSectionHeaderView:(ZQTabMenuView *)view {
    if ([self.delegate respondsToSelector:@selector(tabMenuViewSectionHeaderView:tabControl:)]) {
        return [self.delegate tabMenuViewSectionHeaderView:self tabControl:self.currentTab];
    }
    return nil;
}

- (CGFloat)tabMenuViewSectionHeaderViewHeight:(ZQTabMenuView *)view {
    if ([self.delegate respondsToSelector:@selector(tabMenuViewSectionHeaderViewHeight:tabControl:)]) {
        return [self.delegate tabMenuViewSectionHeaderViewHeight:self tabControl:self.currentTab];
    }
    return 0;
}

- (UIView *)tabMenuViewToSuperview{ //指定弹出菜单添加的父视图
    if ([self.delegate respondsToSelector:@selector(tabMenuViewToSuperview:tabControl:)]) {
        return [self.delegate tabMenuViewToSuperview:self tabControl:self.currentTab];
    }
    return nil;
}

#pragma mark - Getter
- (ZQSeperateLine *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[ZQSeperateLine alloc] init];
    }
    return _bottomLine;
}

- (NSMutableArray *)menus {
    if (!_menus) {
        _menus = [NSMutableArray arrayWithCapacity:0];
    }
    return _menus;
}

@end
