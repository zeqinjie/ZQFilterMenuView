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
    TabControlTypeMultiple, //默认列表形式同时底部有个确认view 多选
    TabControlTypeCustom  //自定义形式
};

@class ZQItemModel,ZQFliterSelectData,ZQTabControl,ZQFilterMenuControlConfig;
typedef void(^ZQTabDidSelectedMenuAllDataBlock)(ZQTabControl *tabControl, ZQFliterSelectData *selectData, ZQItemModel *selectModel);
typedef void(^ZQTabDidFinishedSelectedMenuAllDataBlock)(ZQTabControl *tabControl, ZQFliterSelectData *selectData, ZQItemModel *selectModel);
typedef UIView *(^ZQTabDisplayCustomWithMenu)(void);
typedef  void (^ZQTabEnsureClickDisable)(ZQTabControl *tabControl, ZQFliterSelectData *selectData);

@interface ZQTabControl : UIButton
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) ZQFilterMenuControlConfig *config;
@property (nonatomic, assign, readonly) TabControlType tabControlType;
@property (nonatomic, copy) ZQTabDisplayCustomWithMenu displayCustomWithMenu;
@property (nonatomic, strong) NSArray <ZQItemModel *>*listDataSource;

/// 是否能禁止确定
@property (nonatomic, copy) ZQTabEnsureClickDisable ensureClickDisableBlock;
/**
第几选中的回调
*/
@property (nonatomic, copy) ZQTabDidSelectedMenuAllDataBlock didSelectedMenuAllData;

/// 选中操作事件已处理完毕的回调
@property (nonatomic, copy) ZQTabDidFinishedSelectedMenuAllDataBlock didFinishedSelectedMenuAllDataBlock;

/// **************** menuview 的部分
/**
 是否需要默认选中第二行第一项 默认是不需要
 */
@property (nonatomic, assign) BOOL menuSecondListFirSelected;

+ (instancetype)tabControlWithConfig:(ZQFilterMenuControlConfig *)config;

/**
 控件初始化title
 */
- (NSString *)getControlTitle;
- (void)adjustFrame;

/** 用于调整 自定义视图选中时文字的显示 */
- (void)adjustTitle:(NSString *)title textColor:(UIColor *)color;
/// 隐藏
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
