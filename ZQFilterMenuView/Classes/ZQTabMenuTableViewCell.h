//
//  ZQTabMenuTableViewCell.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import <UIKit/UIKit.h>
#import "ZQItemModel.h"
#import "ZQFilterMenuConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQTabMenuTableViewCell : UITableViewCell

/// 配置对象
@property (nonatomic, strong) ZQFilterMenuControlConfig *config;
/// 标题按钮
@property (nonatomic, strong) UILabel *titleLabel;
/// 多选按钮
@property (nonatomic, strong) UIButton *checkButton;
/// 配置对象
@property (nonatomic, strong) ZQItemModel *model;
/// 是否选中
@property (nonatomic, assign) BOOL isChoice;
/// tableView下标
@property (nonatomic, assign) NSInteger listViewIndex;

@end

NS_ASSUME_NONNULL_END
