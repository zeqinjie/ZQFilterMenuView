//
//  ZQTabControl.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TabControlType) {
    TabControlTypeDefault = 0,  //默认列表形式
    TabControlTypeMutiple, //默认列表形式同时底部有个确认view 多选
    TabControlTypeCustom  //自定义形式
};

@class ZQItemModel,ZQFliterSelectData,ZQTabControl;
typedef void(^ZQTabDidSelectedMenuAllDataBlock)(ZQTabControl *tabControl,NSInteger flag, ZQFliterSelectData *selectData, ZQItemModel *selectModel);
typedef UIView *(^ZQTabDisplayCustomWithMenu)(void);
@interface ZQTabControl : UIButton
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) TabControlType tabControlType;
@property (nonatomic, copy) ZQTabDisplayCustomWithMenu displayCustomWithMenu;
@property (nonatomic, strong) NSArray <ZQItemModel *>*ListDataSource;

/**
第几选中的回调
*/
@property (nonatomic, copy) ZQTabDidSelectedMenuAllDataBlock didSelectedMenuAllData;

@property (nonatomic, assign) CGFloat fontSize;
/// **************** menuview 的部分
/**
 字体对齐方式
 */
@property (nonatomic, assign) NSTextAlignment menuAligment;
/**
 字体大小
 */
@property (nonatomic, assign) CGFloat menuFontSize;
/**
 是否需要默认选中第二行第一项 默认是不需要
 */
@property (nonatomic, assign) BOOL menuSecondListFirSelected;
/**
 限制输入title字数长度
 */
@property (nonatomic, assign) NSInteger menuTitleLength;

/**
 cell 默认高度 44
 */
@property (nonatomic, assign) CGFloat menuCellHeigth;
/**
 最大高度
 */
@property (nonatomic, assign) CGFloat menuLargthHeigth;

/// 字体选中颜色 默认ff8000
@property (nonatomic, strong) UIColor *selTitleColor;
///  默认颜色
@property (nonatomic, strong) UIColor *titleColor;

/**
 menuview的展示高度系数 默认是0.5
 */
@property (nonatomic, assign) CGFloat menuViewHeigthRatio;


+ (instancetype)tabControlWithTitle:(NSString *)title type:(TabControlType)type;

/**
 控件初始化title
 */
- (NSString *)getControlTitle;
- (void)adjustFrame;

/** 用于调整 自定义视图选中时文字的显示 */
- (void)adjustTitle:(NSString *)title textColor:(UIColor *)color;
//隐藏
- (void)dismissTabMenuBar;

/** 按钮样式调整为图片*/
- (void)showPicNorImgStr:(NSString *)norImgStr selImgStr:(NSString *)selImgStr;

/// 设置默认及选择图片
- (void)setNorImgStr:(NSString *)norImgStr selImgStr:(NSString *)selImgStr;

/// 设置选中titile的
/// @param isSelect 是否选中
/// @param title 标题
/// @param selTitle 选中标题
- (void)setControlTitleStatus:(BOOL)isSelect title:(NSString *)title selTitle:(NSString *)selTitle;
/// 设置titile
- (void)setControlTitle:(NSString *)title;
@end
