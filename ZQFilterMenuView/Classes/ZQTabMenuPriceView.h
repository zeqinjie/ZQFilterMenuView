//
//  ZQTabMenuPriceFooterView.h
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//
#import <UIKit/UIKit.h>
#import "ZQTabControl.h"
//NSString *idStr,
typedef void(^ZQTabInputValueBlock)(NSInteger tag,NSString *title,NSDictionary *idDic);
@interface ZQTabMenuPriceView : UIView
@property (nonatomic, copy) ZQTabInputValueBlock inputValueBlock;
@property (nonatomic, strong) NSString *unitStr;
@property (nonatomic, strong) UIColor *styleColor;
@property (nonatomic, weak) ZQTabControl *tabControl;
- (void)setMaxprice:(NSString *)maxprice minprice:(NSString *)minprice;
@end

