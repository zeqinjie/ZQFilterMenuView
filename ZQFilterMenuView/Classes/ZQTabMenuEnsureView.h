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

/// 变成加载中状态
- (void)setLoadingState;

/// 变成加载完毕状态
- (void)finishLoadingWithTitleStr:(NSString *)infoStr;

/// 重置按钮状态             
- (void)resetBtnState;

// 设置确认按钮文字内容
- (void)setConfirmBtnTitle:(NSString *)titleStr;

@end

NS_ASSUME_NONNULL_END
