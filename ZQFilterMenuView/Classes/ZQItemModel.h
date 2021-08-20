//
//  ZQItemModel.h
//  house591
//
//  Created by zhengzeqin on 2019/11/11.
//  
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger ,ZQItemModelSelectMode) {
    ZQItemModelSelectModeSingle = 0,   // 单选 0
    ZQItemModelSelectModeMultiple = 1, // 复选 1
    ZQItemModelSelectModeUnlimit = 3, // 不限和其他类型不能共存特殊处理 3
};
@interface ZQItemModel : NSObject
/// plist文件中的key
@property (nonatomic, strong) NSString *plistKey;
@property (nonatomic, assign) ZQItemModelSelectMode selectMode;
@property (nonatomic, copy) NSString *displayText;// 筛选条上显示的文字
@property (nonatomic, copy) NSString *currentID;// 当前筛选条的id;
@property (nonatomic, assign) BOOL seleceted;// 是否显示选中
/// 存储 ZQItemModel对象, 多级列表时，存储下一级的数据,  包含隐藏数据
@property (nonatomic, strong) NSArray<ZQItemModel*> *dataSource;
/// 存储 ZQItemModel对象, 多级列表时，存储下一级的数据,  剔除需要隐藏的数据
@property (nonatomic, strong, readonly) NSArray<ZQItemModel*> *showDataSource;
/// 是否有下一级的数据
@property (nonatomic, assign) BOOL isHaveSecondSource;
//在数据源里的下标
@property (nonatomic, strong) NSIndexPath *indexPath;
/// 父子项
@property (nonatomic, weak) ZQItemModel *fatherModel;
/// 存放选中的子数据源
@property (nonatomic, strong) NSMutableArray<ZQItemModel*> *selectSonDataModels;
/// 设置不限 id 默认为 0
@property (nonatomic, strong) NSString *unlimited;
/// 是否隐藏
@property (nonatomic, assign) BOOL isHide;
/// 是否重置之后默认选中
@property (nonatomic, assign) BOOL isResetDefaultSelect;
///是否选中不限
- (BOOL)isShowUnlimited;
/// 递归获取祖父model
- (ZQItemModel *)getGrandFatherModel;
/// 更新showDataSource
- (void)refreshShowDataSource;
/// 根据传入的子模型id数组，设置点击重置之后的默认选中项
- (void)setDataSourceResetDefualtSelectStateWithIDArr:(NSArray *)ids;
/// 初始化
+ (instancetype)modelWithText:(NSString *)text currentID:(NSString *)currentID isSelect:(BOOL)select;

@end
