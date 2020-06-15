//
//  ZQTabMenuMoreView.h
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//

#import <UIKit/UIKit.h>
#import "ZQItemModel.h"
#import "ZQTabControl.h"
@interface ZQTabMenuMoreView : UIView
@property (nonatomic, copy) void (^selectBlock)(ZQTabMenuMoreView *view,NSMutableDictionary *selectDic,NSMutableDictionary *moreSeletedDic);
//选择颜色
@property (nonatomic, strong) UIColor *styleColor;
//选中背景颜色
@property (nonatomic, strong) UIColor *didSelectBgColor;
//未选中背景颜色
@property (nonatomic, strong) UIColor *didUnSelectBgColor;
@property (nonatomic, strong) NSArray <ZQItemModel *>*ListDataSource;
@property (nonatomic, weak) ZQTabControl *tabControl;
- (void)tabMenuViewWillAppear;
- (void)tabMenuViewWillDisappear;
/// 设置选中状态
- (void)setTabControlTitle;
@end


