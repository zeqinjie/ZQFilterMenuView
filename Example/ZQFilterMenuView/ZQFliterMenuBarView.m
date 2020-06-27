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

@interface ZQFliterMenuBarView ()
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
/// 更多自定义视图
@property (strong, nonatomic) ZQTabMenuMoreView *moreView;
/// 价格输入框
@property (strong, nonatomic) ZQTabMenuPriceView *priceInputView;

@property (strong, nonatomic) NSMutableArray<ZQTabControl *> *controlBars;
@end
@implementation ZQFliterMenuBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
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

#pragma mark - Data
- (void)configureFilterData{
    
}

#pragma mark - UI
- (void)creatUI{
    [self creatMoreView];
    [self creatFilterView];
    [self creatInputPriceView];
}

- (void)creatMoreView{
    CGFloat moreViewH = (SCREEN_HEIGHT - 54) * 0.5;
    self.moreView = [[ZQTabMenuMoreView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, moreViewH)];
    self.moreView.tag = 3;
    self.moreView.ListDataSource = self.viewModel.moreDataSource;
    self.moreView.selectBlock = ^(ZQTabMenuMoreView *view, NSMutableDictionary *selectDic, NSMutableDictionary *moreSeletedDic) {
        
    };
}

- (void)creatFilterView{
    // 区域
    self.locationControl = [self creatControl:@"区域"
                                          tag:0
                                  controlType:TabControlTypeMutiple
                            controlCustomView:nil
                                     aligment:NSTextAlignmentLeft];
    self.locationControl.ListDataSource = self.viewModel.locationDataSource;
    [self.controlBars addObject:self.locationControl];
    
    // 类型
    self.typeControl = [self creatControl:@"类型"
                                      tag:1
                              controlType:TabControlTypeDefault
                        controlCustomView:nil
                                 aligment:NSTextAlignmentCenter];
    self.typeControl.ListDataSource = self.viewModel.typeDataSource;
    [self.controlBars addObject:self.typeControl];
    
    // 类型
    self.priceControl = [self creatControl:@"价格"
                                      tag:2
                              controlType:TabControlTypeDefault
                        controlCustomView:nil
                                 aligment:NSTextAlignmentCenter];
    self.priceControl.ListDataSource = self.viewModel.priceDataSource;
    [self.controlBars addObject:self.priceControl];
    
    // 更多
    self.moreControl = [self creatControl:@"更多"
                                      tag:3
                              controlType:TabControlTypeCustom
                        controlCustomView:nil
                                 aligment:NSTextAlignmentCenter];
    [self.controlBars addObject:self.moreControl];
    
    //加入
    self.tabMenuBar = [[ZQTabMenuBar alloc]initWithTabControls:self.controlBars];
    self.tabMenuBar.frame = self.bounds;
    self.tabMenuBar.backgroundColor = [UIColor whiteColor];
    self.tabMenuBar.delegate = self;
    [self addSubview:self.tabMenuBar];
    
}

- (void)creatInputPriceView{
    
}

- (ZQTabControl *)creatControl:(NSString *)controlTitle
                           tag:(NSInteger)tag
                   controlType:(TabControlType)controlType
             controlCustomView:(UIView *)controlCustomView
                      aligment:(NSTextAlignment)aligment{
    ZQTabControl *tabControl = [ZQTabControl tabControlWithTitle:controlTitle type:controlType];
    tabControl.menuAligment = aligment;
    tabControl.menuTitleLength = 4;
    tabControl.menuFontSize = 15;
    tabControl.fontSize = 15;
    tabControl.menuViewHeigthRatio = 0.5;
    tabControl.tag = tag;
    tabControl.menuLargthHeigth = 400;
    tabControl.didSelectedMenuAllData = ^(ZQTabControl *tabControl, NSInteger flag, ZQFliterSelectData *selectData, ZQItemModel *selectModel) {
//        NSLog(@"");
    };
    if (controlCustomView) {
        tabControl.displayCustomWithMenu = ^UIView *{
            return controlCustomView;
        };
    }
    return tabControl;
}
@end
