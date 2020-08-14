//
//  ZQTabMenuMoreCollCell.h
//  house591
//
//  Created by zhengzeqin on 2019/11/14.
//

#import <UIKit/UIKit.h>
@class ZQFilterMenuMoreViewConfig;

@interface ZQTabMenuMoreCollCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (assign, nonatomic) BOOL isChoice;
@property (nonatomic, strong) ZQFilterMenuMoreViewConfig *config;
@end


