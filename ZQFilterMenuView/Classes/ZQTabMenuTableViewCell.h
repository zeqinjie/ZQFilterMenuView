//
//  ZQTabMenuTableViewCell.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import <UIKit/UIKit.h>
#import "ZQItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQTabMenuTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIColor *styleColor;
@property (nonatomic, assign) CGFloat menuFontSize;
@property (nonatomic, assign) NSTextAlignment menuAligment;

@property (nonatomic, strong) ZQItemModel *model;
@property (nonatomic, assign) BOOL isChoice;
@end

NS_ASSUME_NONNULL_END
