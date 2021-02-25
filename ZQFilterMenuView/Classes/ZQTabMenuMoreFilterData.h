//
//  ZQTabMenuMoreFilterData.h
//  house591
//
//  Created by zhengzeqin on 2020/5/27.
//

#import <Foundation/Foundation.h>
#import "ZQItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQTabMenuMoreFilterData : NSObject


/// 所有选择的数据 model
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray<ZQItemModel *> *> *moreSeletedDic;
/// 记录上次的选择，不包括选择的
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *lastMoreSeletedDic;
/// 记录上次的选择,包括未选择的
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *lastMoreSeletedAllDic;
/// 设置数据源对象
- (void)setListDataSource:(NSArray<ZQItemModel *> *)listDataSource;
/// 恢复上一次选中
- (void)resetChoiceReloadDataSource:(NSArray<ZQItemModel *> *)listDataSource;
/// 移除所有选中的数据
- (void)removeAllSelectData;
/// 设置最后选中数据
- (void)setLastSelectedDataSource:(NSArray <ZQItemModel*>*)listDataSource;
/// 是否选中
- (BOOL)isHadSelected;
/// 移除非複選對象 选中对象不移除
- (void)removeAllExtenFixModel:(NSMutableArray<ZQItemModel *> *)arr selectModel:(ZQItemModel *)selectModel;
/// 複選對象操作
- (void)selectModel:(ZQItemModel *)model arr:(NSMutableArray<ZQItemModel *> *)arr;
///移除不限对象
- (void)removeUnlimitedModelWithArr:(NSMutableArray<ZQItemModel *> *)arr;
///獲取選中後的所有標題, 字符串返回部分默认分隔符 separator 是空格。 含 title && dic
- (NSDictionary *)getSelectedAllTitleDicSeparator:(NSString *_Nullable)separator;
///获取选择的个数
- (NSInteger)getSelectCount;
@end

NS_ASSUME_NONNULL_END
