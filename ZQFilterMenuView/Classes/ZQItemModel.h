//
//  ZQItemModel.h
//  house591
//
//  Created by zhengzeqin on 2019/11/11.
//  
//

#import <Foundation/Foundation.h>

@interface ZQItemModel : NSObject
/// plist文件中的key
@property (nonatomic, strong) NSString *plistKey;
/// 选择模式，0 单选 1 复选    ///// 子數據中 2 是復合選項  3 不限和其他类型不能共存特殊处理
@property (nonatomic, assign) NSInteger selectMode;
@property (nonatomic, copy) NSString *displayText;// 筛选条上显示的文字
@property (nonatomic, copy) NSString *currentID;// 当前筛选条的id;
@property (nonatomic, assign) BOOL seleceted;// 是否显示选中。
//存储 ZQItemModel对象
@property (nonatomic, strong) NSArray<ZQItemModel*> *dataSource;// 多级列表时，存储下一级的数据。
@property (nonatomic, assign) BOOL isHaveSecondSource;// 是否有下一级的数据

//在数据源里的下标
@property (nonatomic, strong) NSIndexPath *indexPath;
//父子项
@property (nonatomic, weak) ZQItemModel *fatherModel;
@property (nonatomic, strong) NSMutableArray<ZQItemModel*> *selectSonDataModels;//存放选中的子数据源

///是否选中不限
- (BOOL)isShowUnlimited;
/// 递归获取祖父model
- (ZQItemModel *)getGrandFatherModel;
/// 初始化
+ (instancetype)modelWithText:(NSString *)text currentID:(NSString *)currentID isSelect:(BOOL)select;


@end
