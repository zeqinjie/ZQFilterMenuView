//
//  ZQTabMenuMoreCollCell.h
//  house591
//
//  Created by zhengzeqin on 2019/11/14.
//

#import <UIKit/UIKit.h>

@interface ZQTabMenuMoreCollCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (assign, nonatomic) BOOL isChoice;
//选择颜色
@property (nonatomic, strong) UIColor *styleColor;
//选中背景颜色
@property (nonatomic, strong) UIColor *didSelectBgColor;
//未选中背景颜色
@property (nonatomic, strong) UIColor *didUnSelectBgColor;
@end


