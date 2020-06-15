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
@interface ZQTabMenuBar () <ZQTabMenuViewDelegate>

@property (nonatomic, assign) CGRect orginFrame;
@property (nonatomic, assign) CGRect showFilterFrame;
@property (nonatomic, strong) ZQSeperateLine *bottomLine;
@property (nonatomic, strong) NSMutableArray *menus;
//当前展示按钮
@property (nonatomic, weak) ZQTabControl *currentTab;
//当前展示menu
@property (nonatomic, weak) ZQTabMenuView *showMenuView;

@property (nonatomic, strong) UIColor *styleColor;
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
    
    CGFloat width = self.frame.size.width/self.tabControls.count;
    [self.tabControls enumerateObjectsUsingBlock:^(ZQTabControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZQTabControl *tabControl = obj;
        tabControl.frame = CGRectMake(idx * width, 0, width, self.frame.size.height);
        [tabControl adjustFrame];
    }];
    if (!self.orginFrame.size.width) {
        self.orginFrame = self.frame;
    }
    self.showFilterFrame = CGRectMake(0, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.6, self.frame.size.width, 0.6);
    
}

- (instancetype)initWithTabControls:(NSArray<ZQTabControl *>*)tabControls
{
    if (self = [self initWithTabControls:tabControls styleColor:nil]) {
        ////
    }
    return self;
}

- (instancetype)initWithTabControls:(NSArray<ZQTabControl *>*)tabControls
                         styleColor:(UIColor *)styleColor{
    if (self = [super init]) {
        _tabControls = tabControls;
        _styleColor = styleColor;
        [self initItems];
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
        menuView.styleColor = self.styleColor;
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
    [showMenuView displayTabMenuViewWithMenuBar:self withTopOffsetY:self.menuTopOffsetY];
}

- (void)clearShowMenuAllSelected{
    [self.showMenuView resetAllSelectData];
    [self reloadMenus];
}

- (void)reloadMenus {
    [self.showMenuView reloadAllList];
}

- (void)reloadMenusIndex:(NSInteger)index{
    ZQTabMenuView *menuView = self.menus[index];
    [menuView.tabControl adjustTitle:menuView.tabControl.title textColor:menuView.tabControl.titleColor];
    [menuView reloadSeletedListDataSource];
}

- (void)dismiss {
    //  将其他的菜单移除
    [self.menus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZQTabMenuView *menuView = obj;
        [menuView dismiss];
    }];
}

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

- (UIView *)tabMenuViewToSuperview{ //指定弹出菜单添加的父视图
    if ([self.delegate respondsToSelector:@selector(tabMenuViewToSuperview)]) {
        return [self.delegate tabMenuViewToSuperview];
    }
    return nil;
}
#pragma mark - Public Method
- (void)setIsShowBottomLine:(BOOL)isShowBottomLine{
    _isShowBottomLine = isShowBottomLine;
    self.bottomLine.hidden = !isShowBottomLine;
}

#pragma mark - 懒加载
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

- (void)dealloc {
    NSLog(@"%s", __func__);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
