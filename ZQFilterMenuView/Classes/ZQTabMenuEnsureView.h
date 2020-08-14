//
//  ZQTabMenuEnsureView.h
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import <UIKit/UIKit.h>
@class ZQFilterMenuEnsureViewConfig;

NS_ASSUME_NONNULL_BEGIN

@interface ZQTabMenuEnsureView : UIView
@property (nonatomic, copy) void(^clickAction)(NSInteger tag);

- (instancetype)initWithConfig:(ZQFilterMenuEnsureViewConfig *)config;

@end

NS_ASSUME_NONNULL_END
