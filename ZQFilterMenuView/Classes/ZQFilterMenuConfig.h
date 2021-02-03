//
//  ZQFilterMenuConfig.h
//  TWHouseUIKit
//
//  Created by zhengzeqin on 2020/7/30.
//

#import <Foundation/Foundation.h>
#import "ZQTabControl.h"
@class ZQFilterMenuEnsureViewConfig;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ZQFilterMenuBarConfig
@interface ZQFilterMenuBarConfig : NSObject

/** 背景色 （默认：白色）*/
@property (nonatomic, strong) UIColor *backgroundColor;
/** 底部分割线的颜色 （默认：f5f5f5）*/
@property (nonatomic, strong) UIColor *bottomLineColor;
/** 是否显示底部分割线 （默认：YES）*/
@property (nonatomic, assign) BOOL isShowBottomLine;
/** 底部分割线的高度（默认：0.6） */
@property (nonatomic, assign) CGFloat bottomLineHeight;
/** 获取对应的宽度，如果是 nil 则为平均宽 */
@property (nonatomic, strong) NSArray<NSNumber *> *widthArr;
/** 左右间隙 默认 0*/
@property (nonatomic, assign) CGFloat lrGap;
@end

#pragma mark - ZQFilterMenuControlConfig
@interface ZQFilterMenuControlConfig : NSObject

/** 类型 */
@property (nonatomic, assign) TabControlType type;
/** ensureViewConfig type为TabControlTypeMutiple时会用到 */
@property (nonatomic, strong) ZQFilterMenuEnsureViewConfig *ensureViewConfig;

/** =================================== control  =================================== */
/** 背景色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 菜单标题 */
@property (nonatomic, copy) NSString *title;
/** 菜单标题字体 默认14 */
@property (nonatomic, strong) UIFont *titleFont;
/** 菜单标题颜色(未勾选，默认：222222) */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** 菜单标题颜色(已勾选，默认：ff8000) */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 菜单勾选图标(未勾选，默认：twhouse_menu_down) */
@property (nonatomic, strong) UIImage *indicatorNormalImg;
/** 菜单勾选图标(已勾选，默认：twhouse_menu_up)  */
@property (nonatomic, strong) UIImage *indicatorSelectedImg;
/** 限制输入title字数长度（默认：0，不限制） */
@property (nonatomic, assign) NSInteger titleLength;

/** =================================== menuView  =================================== */
/** menuview的展示高度系数 默认是0.5 */
@property (nonatomic, assign) CGFloat menuViewHeigthRatio;
/** menuview的最大高度（默认：0，则不限制高度） */
@property (nonatomic, assign) CGFloat menuViewLargthHeight;
/** menuview的背景色（默认：白色） */
@property (nonatomic, strong) UIColor *menuViewBackgroundColor;
/** menuview中tableview的分割线颜色（默认：e6e6e6） */
@property (nonatomic, strong) UIColor *menuViewTableViewSeparatorColor;
/** menuview中tableview的分割线颜色数组（如果取不到就默认为menuViewTableViewSeparatorColor） */
@property (nonatomic, strong) NSArray<UIColor *> *menuViewTableViewSeparatorColors;
/** menuview中tableview的背景颜色（默认：白色） */
@property (nonatomic, strong) UIColor *menuViewTableViewBgColor;
/** menuview中tableview的背景颜色数组（如果取不到就默认为menuViewTableViewBgColor） */
@property (nonatomic, strong) NSArray<UIColor *> *menuViewTableViewBgColors;

/** =================================== menuCell  =================================== */
/** 字体对齐方式 */
@property (nonatomic, assign) NSTextAlignment menuCellAligment;
/** menuCell字体 默认14 */
@property (nonatomic, strong) UIFont *menuCellFont;
/** menuCell 默认高度 44 */
@property (nonatomic, assign) CGFloat menuCellHeigth;
/** menuCell标题颜色(未勾选，默认：222222) */
@property (nonatomic, strong) UIColor *menuCellTitleNormalColor;
/** menuCell标题颜色(已勾选，默认：ff8000) */
@property (nonatomic, strong) UIColor *menuCellTitleSelectedColor;
/** menuCell勾选图标(未勾选，默认：twhouse_menu_unsel) */
@property (nonatomic, strong) UIImage *menuCellIndicatorNormalImg;
/** menuCell勾选图标(已勾选，默认：twhouse_menu_sel)  */
@property (nonatomic, strong) UIImage *menuCellIndicatorSelectedImg;

@end

#pragma mark - ZQFilterMenuMoreViewConfig
@interface ZQFilterMenuMoreViewConfig : NSObject

/** 背景色（默认：白色） */
@property (nonatomic, strong) UIColor *backgroundColor;

/** more section header 标题颜色(默认：333333) */
@property (nonatomic, strong) UIColor *moreSectionHeaderTitleColor;

/** moreCell标题颜色(未选中，默认：222222) */
@property (nonatomic, strong) UIColor *moreCellTitleNormalColor;
/** moreCell背影色(未选中，默认：f5f5f5) */
@property (nonatomic, strong) UIColor *moreCellNormalBgColor;
/** moreCell边框颜色(未选中，默认：f5f5f5) */
@property (nonatomic, strong) UIColor *moreCellNormalBorderColor;
/** moreCell标题颜色(已选中，默认：ff8000) */
@property (nonatomic, strong) UIColor *moreCellTitleSelectedColor;
/** moreCell背影色(已选中，默认：faf5f2)  */
@property (nonatomic, strong) UIColor *moreCellSelectedBgColor;
/** moreCell边框颜色(已选中，默认：ff8000) */
@property (nonatomic, strong) UIColor *moreCellSelectedBorderColor;
/** sectionHeader 高度 (默认60) */
@property (nonatomic, assign) CGFloat sectionHeaderHegiht;
/** 选中item重置输入框内容 (默认不重置) */
@property (nonatomic, assign) BOOL isSeltedRestInput;
/** 输入内容重置item选中 (默认不重置) */
@property (nonatomic, assign) BOOL isInputRestSelted;
/** moreCell 的高度(默认: 34) */
@property (nonatomic, assign) CGFloat cellItemHeight;

@end

#pragma mark - ZQFilterMenuEnsureViewConfig
@interface ZQFilterMenuEnsureViewConfig : NSObject

/** ensureView的背景色（默认：白色） */
@property (nonatomic, strong) UIColor *backgroundColor;

/** ensureView的重置按钮标题（默认：重置） */
@property (nonatomic, copy) NSString *resetBtnTitle;
/** ensureView的重置按钮Font（默认：16） */
@property (nonatomic, strong) UIFont *resetBtnFont;
/** ensureView的重置按钮标题颜色（默认：999999）*/
@property (nonatomic, strong) UIColor *resetBtnTitleColor;
/** ensureView的重置按钮背景色（默认：f5f5f5） */
@property (nonatomic, strong) UIColor *resetBtnBgColor;

/** ensureView的重置按钮标题（默认：確定） */
@property (nonatomic, copy) NSString *confirmBtnTitle;
/** ensureView的确定按钮Font（默认：16） */
@property (nonatomic, strong) UIFont *confirmBtnFont;
/** ensureView的确定按钮标题颜色（默认：白色） */
@property (nonatomic, strong) UIColor *confirmBtnTitleColor;
/** ensureView的确定按钮背景色（默认：ff8000） */
@property (nonatomic, strong) UIColor *confirmBtnBgColor;
/** 是否隱藏重置按鈕 (默認不隱藏) */
@property (nonatomic, assign) BOOL isHiddenResetBtn;

@end

#pragma mark - ZQFilterMenuRangeViewConfig
@interface ZQFilterMenuRangeViewConfig : NSObject

/** priceView的背景色（默认：白色） */
@property (nonatomic, strong) UIColor *backgroundColor;
/** topLine的颜色（默认：f5f5f5） */
@property (nonatomic, strong) UIColor *topLineColor;
/** topLine的高度(默认： 0.5) */
@property (nonatomic, assign) CGFloat topLineHeight;
/** 最小值标题（默认：最低價） */
@property (nonatomic, copy) NSString *minValueTitle;
/** 最大值标题（默认：最高價） */
@property (nonatomic, copy) NSString *maxValueTitle;
/** 范围输入框数值的字体（默认：15） */
@property (nonatomic, strong) UIFont *rangeTextFieldFont;
/** 范围输入框数值的颜色（默认：222222） */
@property (nonatomic, strong) UIColor *rangeTextFieldColor;
/** 范围输入框占位数值的颜色（默认：cccccc） */
@property (nonatomic, strong) UIColor *rangeTextFieldPlaceholderColor;
/** 范围输入框的边框大小（默认：1） */
@property (nonatomic, assign) CGFloat rangeTextFieldBorderWidth;
/** 范围输入框的边框颜色（默认：e6e6e6） */
@property (nonatomic, strong) UIColor *rangeTextFieldBorderColor;
/** 范围中间分割线的颜色（默认：979797） */
@property (nonatomic, strong) UIColor *rangeLineColor;
/** 单位标题（默认：元） */
@property (nonatomic, copy) NSString *unitLabelTitle;
/** 单位的颜色（默认：666666） */
@property (nonatomic, strong) UIColor *unitLabelColor;
/** 单位的字体（默认：16） */
@property (nonatomic, strong) UIFont *unitLabelFont;
/** 确定按钮标题（默认：確定） */
@property (nonatomic, copy) NSString *confirmBtnTitle;
/** 确定按钮标题颜色（默认：白色） */
@property (nonatomic, strong) UIColor *confirmBtnTitleColor;
/** 确定按钮背景颜色（默认：ff8000） */
@property (nonatomic, strong) UIColor *confirmBtnBgColor;
/** 确定按钮字体（默认：16） */
@property (nonatomic, strong) UIFont *confirmBtnFont;
/** 输入文本高度（默认：36） */
@property (nonatomic, assign) CGFloat textFieldHeight;
/** 输入文本宽度（默认：87） */
@property (nonatomic, assign) CGFloat textFieldWidth;
/** 确定按钮高度（默认：36） */
@property (nonatomic, assign) CGFloat confirmButtonHeight;
/** 确定按钮宽度（默认：87） */
@property (nonatomic, assign) CGFloat confirmButtonWidth;

@end

NS_ASSUME_NONNULL_END
