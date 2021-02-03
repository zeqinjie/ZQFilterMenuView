//
//  ZQFliterSelectData.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  记录选中的数据源模型，用于存取

#import <Foundation/Foundation.h>
#import "ZQItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQFliterSelectData : NSObject

///****************父数据源的
#pragma mark - Father Property
@property (nonatomic, strong) NSArray<ZQItemModel *> *fatherDataSource;
///每组下标下选中的数据源 0  1  2
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, ZQFliterSelectData*> *dict;

///****************子数据源中使用 复选用的上
#pragma mark - Son Property
///當前选中組的數據源

///选择的下标index 数组   //注意如果是父类组件话存儲的第一次选中的index的第一个下标
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectIndexArr;
///选择的下标index 及 模型
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, ZQItemModel*> *selectModelDic;

#pragma mark - Father Method

/// 获取当前对应tableview的数据源
/// @param listDataSource 数据源
/// @param listViewIndex 当前tableview tag
- (NSArray<ZQItemModel *> *)getListDataSource:(NSArray *)listDataSource listViewIndex:(NSInteger)listViewIndex;

/// 如果上一组数据源没有选择，则取上一组的第一项数据源作为当前数据源返回
/// @param listDataSource 上一组的数据源
/// @param listViewIndex 当前展示的tableViewt.tag 即时第几列
- (NSArray *)getFirstListDataSource:(NSArray *)listDataSource listViewIndex:(NSInteger)listViewIndex;

///獲取三組選中的下標，如果没有选中，默认是第一项 isFirst
- (NSArray <NSNumber *> *)getAllSelectIndexArr:(BOOL)isFirst;

/// 获取选择的多少列
- (NSInteger)getChoiceCount;

/// 需要展示多少列
- (NSInteger)getShowListViewCount;

/// 移除子数据模型的所有数据
- (void)removeSonSelectDataAllSelectModel;
/// 从-1即是从第0列开始清除
- (void)removeSonSelectDataAllSelectModelSelectIndex:(NSInteger)selectIndex;
/// 更新并初始化子选择数据model
/// @param listDataSource 数据源
/// @param selectIndex 下标
- (NSString *)reloadSeletedListDataSource:(NSArray<ZQItemModel *> *)listDataSource
                              selectIndex:(NSInteger)selectIndex;

/// 更新数据选择项
/// @param listDataSource 数据源
/// @param orginSelectData 重置数据源 非必传，重置需要,否则只是更新model 的 selected
/// @param selectIndex listIndex 默认设置-1 开始
/// @param flag 0 默认方式，如果为1 如果只选中第一列任何一项，则重置为第一项区域
- (void)updateSeletedListDataSource:(NSArray<ZQItemModel *> *)listDataSource
                    orginSelectData:(nullable ZQFliterSelectData *)orginSelectData
                        selectIndex:(NSInteger)selectIndex
                               flag:(NSInteger)flag;


/// 一直清空下一组数据源
/// @param listViewIndex 当前tableview 的tag。第一列
/// @param lastDataSource 数据源
- (void)resetSelectLastModelDataSource:(NSArray<ZQItemModel *> *)lastDataSource
                         listViewIndex:(NSInteger)listViewIndex;


/// 添加第几组数据源 选择为第一项
/// @param listDataSource 数据源
/// @param index 第几组
- (ZQItemModel *)addFirstSelectedModelDataSource:(NSArray<ZQItemModel *> *)listDataSource
                                           index:(NSInteger)index;

/// 获取显示标题
- (NSString *)getActionDisplayText;


/// 获取当前选择的参数
- (NSDictionary *)getSelectParameDic;

///獲取選中後的所有標題
- (NSDictionary *)getSeltedAllTitleDic;

#pragma mark - Child Method

/// 是否选中数据
- (BOOL)isChoiceModel:(ZQItemModel *)selectModel;
/// 选中的个数
- (NSInteger)hadSelectedCount;
/// 移除所有选中并添加选中的
- (void)removeAllSelectModelAndAddModel:(ZQItemModel *)selectModel row:(NSInteger)row;
/// 清空所有
- (void)removeAllSelectModel;

/// 移除選擇中数据
/// @param model 选中对象
- (void)removeSelectModel:(ZQItemModel *)model;

/// 加入数据源
/// @param model 选中对象
/// @param row 下标需>0
- (void)addSelectModel:(ZQItemModel *)model row:(NSInteger)row;


#pragma mark - Class Method
/// 是否有子数据源
/// @param dataSource 当前数据源
+ (BOOL)isHaveChildModel:(NSArray<ZQItemModel *> *)dataSource;

/// 重置所有选择项，包括子对象数组 需要的数据源
/// @param dataSource 数据源
/// @param row 选中的下标 >-1 才能设置
/// @param type 重置类型  type = 0 所有数据源重置  1 如果是子的不限默认选中
/// @param selectIndex listIndex 必须传-1 方便递归计算
+ (void)resetAllSelectDataSource:(NSArray<ZQItemModel *> *)dataSource
                            type:(NSInteger)type
                             row:(NSInteger)row
                     selectIndex:(NSInteger)selectIndex;
@end

NS_ASSUME_NONNULL_END
