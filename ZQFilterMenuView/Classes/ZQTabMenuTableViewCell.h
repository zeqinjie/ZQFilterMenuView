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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *checkButton;
/** 配置对象 */
@property (nonatomic, strong) ZQFilterMenuControlConfig *config;

@property (nonatomic, strong) ZQItemModel *model;
@property (nonatomic, assign) BOOL isChoice;
@end

NS_ASSUME_NONNULL_END
