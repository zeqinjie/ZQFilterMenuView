//
//  ZQFilterMenuConfig.m
//  TWHouseUIKit
//
//  Created by linxunfeng on 2020/7/30.
//

#import "ZQFilterMenuConfig.h"
#import "ZQFilterMenuTool.h"
#import <ZQFoundationKit/UIColor+Util.h>

#pragma mark - ZQFilterMenuBarConfig
@implementation ZQFilterMenuBarConfig

- (instancetype)init {
    if (self = [super init]) {
        // 初始化配置
        self.backgroundColor = [UIColor whiteColor];
        self.bottomLineColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.isShowBottomLine = YES;
        self.bottomLineHeight = 0.6;
    }
    return self;
}

@end

#pragma mark - ZQFilterMenuControlConfig
@implementation ZQFilterMenuControlConfig

- (instancetype)init {
    if (self = [super init]) {
        // 初始化配置
        self.ensureViewConfig = [ZQFilterMenuEnsureViewConfig new];
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titleNormalColor = [UIColor colorWithHexString:@"222222"];
        self.titleSelectedColor = [UIColor colorWithHexString:@"ff8000"];
        self.indicatorNormalImg = [ZQFilterMenuTool imageNamed:@"twhouse_menu_down"];
        self.indicatorSelectedImg = [ZQFilterMenuTool imageNamed:@"twhouse_menu_up"];
        
        self.menuViewHeigthRatio = 0.5;
        self.menuViewBackgroundColor = [UIColor whiteColor];
        self.menuViewTableViewSeparatorColor = [UIColor colorWithHexString:@"e6e6e6"];
        self.menuViewTableViewSeparatorColors = [NSArray array];
        self.menuViewTableViewBgColor = [UIColor whiteColor];
        self.menuViewTableViewBgColors = @[
            [UIColor whiteColor],
            [UIColor colorWithHexString:@"fafafa"],
            [UIColor colorWithHexString:@"f5f5f5"]
        ];
        
        self.menuCellFont = [UIFont systemFontOfSize:14];
        self.menuCellHeigth = 44;
        self.menuCellTitleNormalColor = [UIColor colorWithHexString:@"222222"];
        self.menuCellTitleSelectedColor = [UIColor colorWithHexString:@"ff8000"];
        self.menuCellIndicatorNormalImg = [ZQFilterMenuTool imageNamed:@"twhouse_menu_unsel"];
        self.menuCellIndicatorSelectedImg = [ZQFilterMenuTool imageNamed:@"twhouse_menu_sel"];
    }
    return self;
}

@end

#pragma mark - ZQFilterMenuMoreViewConfig
@implementation ZQFilterMenuMoreViewConfig

- (instancetype)init {
    if (self = [super init]) {
        // 初始化配置
        self.backgroundColor = [UIColor whiteColor];
        
        self.moreCellTitleNormalColor = [UIColor colorWithHexString:@"222222"];
        self.moreCellNormalBgColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.moreCellNormalBorderColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        self.moreCellTitleSelectedColor = [UIColor colorWithHexString:@"ff8000"];
        self.moreCellSelectedBgColor = [UIColor colorWithHexString:@"faf5f2"];
        self.moreCellSelectedBorderColor = [UIColor colorWithHexString:@"ff8000"];
        self.sectionHeaderHegiht = 60;
        self.cellItemHeight = 34;
    }
    return self;
}

@end

#pragma mark - ZQFilterMenuEnsureViewConfig
@implementation ZQFilterMenuEnsureViewConfig

- (instancetype)init {
    if (self = [super init]) {
        // 初始化配置
        self.backgroundColor = [UIColor whiteColor];
        
        self.resetBtnTitle = @"重置";
        self.resetBtnFont = [UIFont systemFontOfSize:16];
        self.resetBtnTitleColor = [UIColor colorWithHexString:@"999999"];
        self.resetBtnBgColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        self.confirmBtnTitle = @"確定";
        self.confirmBtnFont = [UIFont systemFontOfSize:16];
        self.confirmBtnTitleColor = [UIColor whiteColor];
        self.confirmBtnBgColor = [UIColor colorWithHexString:@"ff8000"];
    }
    return self;
}

@end


#pragma mark - ZQFilterMenuRangeViewConfig
@implementation ZQFilterMenuRangeViewConfig

- (instancetype)init {
    if (self = [super init]) {
        // 初始化配置
        self.backgroundColor = [UIColor whiteColor];
        self.topLineColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.topLineHeight = 0.5;
        self.minValueTitle = @"最低價";
        self.maxValueTitle = @"最高價";
        self.rangeTextFieldFont = [UIFont systemFontOfSize:15];
        self.rangeTextFieldColor = [UIColor colorWithHexString:@"222222"];
        self.rangeTextFieldPlaceholderColor = [UIColor colorWithHexString:@"cccccc"];
        self.rangeTextFieldBorderWidth = 1;
        self.rangeTextFieldBorderColor = [UIColor colorWithHexString:@"e6e6e6"];
        self.rangeLineColor = [UIColor colorWithHexString:@"979797"];
        self.unitLabelTitle = @"元";
        self.unitLabelColor = [UIColor colorWithHexString:@"666666"];
        self.unitLabelFont = [UIFont systemFontOfSize:16];
        self.confirmBtnTitle = @"確定";
        self.confirmBtnTitleColor = [UIColor whiteColor];
        self.confirmBtnBgColor = [UIColor colorWithHexString:@"ff8000"];
        self.confirmBtnFont = [UIFont systemFontOfSize:16];
        self.textFieldHeight = 36;
        self.textFieldWidth =  87;
        self.confirmButtonHeight = 36;
        self.confirmButtonWidth = 87;
    }
    return self;
}

@end
