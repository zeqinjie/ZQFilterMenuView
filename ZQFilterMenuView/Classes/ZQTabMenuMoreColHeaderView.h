//
//  ZQTabMenuMoreSectionHeaderView.h
//  house591
//
//  Created by zhengzeqin on 2019/11/14.
//

#import <UIKit/UIKit.h>
@class ZQFilterMenuMoreViewConfig;

@interface ZQTabMenuMoreColHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ZQFilterMenuMoreViewConfig *config;
@end

