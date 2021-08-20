//
//  ZQFliterMenuBarView.m
//  ZQFilterMenuView_Example
//
//  Created by zhengzeqin on 2020/6/27.
//  Copyright © 2020 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import "ZQFliterMenuBarView.h"
#import "ZQFliterMenuBarViewModel.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ZQFliterMenuBarView ()<ZQTabMenuBarDelegate>
/// 数据
@property (strong, nonatomic) ZQFliterMenuBarViewModel *viewModel;
/// mebuBar
@property (strong, nonatomic) ZQTabMenuBar *tabMenuBar;
/// 区域
@property (strong, nonatomic) ZQTabControl *locationControl;
/// 户型
@property (strong, nonatomic) ZQTabControl *typeControl;
/// 价格
@property (strong, nonatomic) ZQTabControl *priceControl;
/// 更多
@property (strong, nonatomic) ZQTabControl *moreControl;
/// 更多 自定义视图
@property (strong, nonatomic) ZQTabMenuMoreView *moreView;
/// 价格输入框
@property (strong, nonatomic) ZQTabMenuPriceView *priceInputView;
/// 控制按钮
@property (strong, nonatomic) NSMutableArray<ZQTabControl *> *controlBars;
/** ensureView 的配置 */
@property (nonatomic, strong) ZQFilterMenuEnsureViewConfig *ensureViewConfig;

@end
@implementation ZQFliterMenuBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = [[ZQFliterMenuBarViewModel alloc]init];
        [self configureFilterData];
        [self creatUI];
    }
    return self;
}

- (NSMutableArray <ZQTabControl *> *)controlBars{
    if (!_controlBars) {
        _controlBars = [NSMutableArray array];
    }
    return _controlBars;;
}

- (ZQFilterMenuEnsureViewConfig *)ensureViewConfig {
    if (!_ensureViewConfig) {
        ZQFilterMenuEnsureViewConfig *ensureConfig = [ZQFilterMenuEnsureViewConfig new];
        ensureConfig.backgroundColor = [UIColor blueColor];
        ensureConfig.resetBtnTitle = @"重置";
        ensureConfig.resetBtnFont = [UIFont systemFontOfSize:20];
        ensureConfig.resetBtnTitleColor = [UIColor redColor];
        ensureConfig.resetBtnBgColor = [UIColor yellowColor];
        ensureConfig.confirmBtnTitle = @"确定";
        ensureConfig.confirmBtnFont = [UIFont systemFontOfSize:20];
        ensureConfig.confirmBtnTitleColor = [UIColor greenColor];
        ensureConfig.confirmBtnBgColor = [UIColor orangeColor];
        _ensureViewConfig = ensureConfig;
    }
    return _ensureViewConfig;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *resultView = [super hitTest:point withEvent:event];
    if (resultView != nil) {
        return resultView;
    }else{
        for (UIView *subView in self.subviews.reverseObjectEnumerator) {
            CGPoint convertPoint = [subView convertPoint:point fromView:self];
            UIView *hitView = [subView hitTest:convertPoint withEvent:event];
            if (hitView != nil) {
                return hitView;
            }
        }
    }
    return nil;
}

#pragma mark - Data
- (void)configureFilterData{
    [self.viewModel configureData];
}

#pragma mark - UI
- (void)creatUI{
    [self creatMoreView];
    [self creatFilterView];
    [self creatInputPriceView];
}

- (void)creatMoreView{
    CGFloat moreViewH = (SCREEN_HEIGHT - 54) * 0.5;
    ZQFilterMenuMoreViewConfig *moreConfig = [ZQFilterMenuMoreViewConfig new];
    moreConfig.backgroundColor = [UIColor greenColor];
    moreConfig.moreSectionHeaderTitleColor = [UIColor orangeColor];
    moreConfig.moreCellTitleNormalColor = [UIColor blueColor];
    moreConfig.moreCellNormalBgColor = [UIColor yellowColor];
    moreConfig.moreCellNormalBorderColor = [UIColor redColor];
    moreConfig.moreCellTitleSelectedColor = [UIColor whiteColor];
    moreConfig.moreCellSelectedBgColor = [UIColor orangeColor];
    moreConfig.moreCellSelectedBorderColor = [UIColor blueColor];

    self.moreView = [[ZQTabMenuMoreView alloc] initWithMoreViewConfig:moreConfig ensureViewConfig:self.ensureViewConfig];
    self.moreView.frame = CGRectMake(0, 0, SCREEN_WIDTH, moreViewH);
    self.moreView.tag = 3;
    self.moreView.listDataSource = self.viewModel.moreDataSource;
    self.moreView.selectBlock = ^(ZQTabMenuMoreView *view, ZQTabMenuMoreFilterData *selectData) {
        NSLog(@"更多多选 selectDic : %@ moreSeletedDic : %@",selectData.lastMoreSeletedDic,selectData.moreSeletedDic);
    };
}

- (void)creatFilterView{
    // 区域
    self.locationControl = [self creatControl:@"区域"
                                          tag:0
                                  controlType:TabControlTypeMultiple
                            controlCustomView:nil
                                     aligment:NSTextAlignmentLeft];
    self.locationControl.listDataSource = self.viewModel.locationDataSource;
    [self.controlBars addObject:self.locationControl];
    
    // 类型
    self.typeControl = [self creatControl:@"类型"
                                      tag:1
                              controlType:TabControlTypeDefault
                        controlCustomView:nil
                                 aligment:NSTextAlignmentCenter];
    self.typeControl.listDataSource = self.viewModel.typeDataSource;
    [self.controlBars addObject:self.typeControl];
    
    // 类型
    self.priceControl = [self creatControl:@"价格"
                                      tag:2
                              controlType:TabControlTypeDefault
                        controlCustomView:nil
                                 aligment:NSTextAlignmentCenter];
    self.priceControl.listDataSource = self.viewModel.priceDataSource;
    [self.controlBars addObject:self.priceControl];
    
    // 更多
    self.moreControl = [self creatControl:@"更多"
                                      tag:3
                              controlType:TabControlTypeCustom
                        controlCustomView:self.moreView
                                 aligment:NSTextAlignmentCenter];
    [self.controlBars addObject:self.moreControl];
    
    //加入
    ZQFilterMenuBarConfig *menuBarConfig = [[ZQFilterMenuBarConfig alloc] init];
    self.tabMenuBar = [[ZQTabMenuBar alloc] initWithTabControls:self.controlBars config:menuBarConfig];
    
    self.tabMenuBar.frame = self.bounds;
    self.tabMenuBar.backgroundColor = [UIColor systemPinkColor];
    self.tabMenuBar.delegate = self;
    [self addSubview:self.tabMenuBar];
    
}

- (void)creatInputPriceView{
    ZQFilterMenuRangeViewConfig *config = [ZQFilterMenuRangeViewConfig new];
    config.backgroundColor = [UIColor darkGrayColor];
    config.topLineColor = [UIColor redColor];
    config.minValueTitle = @"最小值";
    config.maxValueTitle = @"最大值";
    config.rangeTextFieldFont = [UIFont systemFontOfSize:20];
    config.rangeTextFieldColor = [UIColor redColor];
    config.rangeTextFieldPlaceholderColor = [UIColor whiteColor];
    config.rangeTextFieldBorderWidth = 5;
    config.rangeTextFieldBorderColor = [UIColor yellowColor];
    config.rangeLineColor = [UIColor greenColor];
    config.unitLabelTitle = @"万";
    config.unitLabelColor = [UIColor blueColor];
    config.unitLabelFont = [UIFont systemFontOfSize:20];
    config.confirmBtnTitle = @"确定";
    config.confirmBtnTitleColor = [UIColor systemPinkColor];
    config.confirmBtnBgColor = [UIColor yellowColor];
    config.confirmBtnFont = [UIFont systemFontOfSize:20];
    
    self.priceInputView = [[ZQTabMenuPriceView alloc] initWithConfig:config];
    self.priceInputView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 71);
    
    self.priceInputView.inputValueBlock = ^(NSInteger tag, NSString *title, NSDictionary *idDic) {
        NSLog(@"确定选中 idDic = %@",idDic);
    };
    self.priceInputView.tabControl = self.priceControl;
}

- (ZQTabControl *)creatControl:(NSString *)controlTitle
                           tag:(NSInteger)tag
                   controlType:(TabControlType)controlType
             controlCustomView:(UIView *)controlCustomView
                      aligment:(NSTextAlignment)aligment{
    ZQFilterMenuControlConfig *config = [ZQFilterMenuControlConfig new];
    config.type = controlType; // 类型
    config.titleLength = 5; // 标题字数限制
    config.title = controlTitle; // 标题
    config.titleFont = [UIFont systemFontOfSize:18]; // 字体大小
    config.titleNormalColor = [UIColor whiteColor]; // 字体颜色
    config.titleSelectedColor = [UIColor darkGrayColor]; // 选中后的字体颜色
    
    config.menuViewHeigthRatio = 0.5; // 展示高度系数
    config.menuViewLargthHeight = 400; // 最大高度
    config.menuViewTableViewSeparatorColor = [UIColor whiteColor];
    config.menuViewTableViewBgColors = @[
        [UIColor redColor],
        [UIColor darkGrayColor],
        [UIColor purpleColor]
    ];
    
    config.menuCellAligment = aligment;
    config.menuCellFont = [UIFont systemFontOfSize:15]; // 字体大小
    config.menuCellTitleNormalColor = [UIColor orangeColor]; // 字体颜色
    config.menuCellTitleSelectedColor = [UIColor greenColor]; // 选中后的字体颜色
    if (TabControlTypeMultiple == controlType) {
        config.ensureViewConfig = self.ensureViewConfig;
    }
    
    ZQTabControl *tabControl = [ZQTabControl tabControlWithConfig:config];
    tabControl.tag = tag;
    tabControl.didSelectedMenuAllData = ^(ZQTabControl *tabControl, ZQFliterSelectData *selectData, ZQItemModel *selectModel) {
        NSLog(@"确定选中 selectData = %@",[selectData getSelectParameDic]);
    };
    if (controlCustomView) {
        tabControl.displayCustomWithMenu = ^UIView *{
            return controlCustomView;
        };
    }
    return tabControl;
}

#pragma mark - ZQTabMenuBarDelegate
- (void)tabMenuViewWillAppear:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl{
    if (tabControl == self.moreControl) {
        [self.moreView tabMenuViewWillAppear];
    }
}

- (void)tabMenuViewWillDisappear:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl{
    if (tabControl == self.moreControl) {
        [self.moreView tabMenuViewWillDisappear];
    }
}

- (UIView *)tabMenuViewFooterView:(ZQTabMenuBar *)view tabControl:(ZQTabControl *)tabControl{
    if (tabControl == self.priceControl) {
        return self.priceInputView;
    }
    return nil;
}
@end
