//
//  ZQTabControl.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//
//

#import "ZQTabControl.h"
#import "ZQTabMenuBar.h"
#import "UIColor+Util.h"
#import "ZQFilterMenuTool.h"
#import "ZQFilterMenuConfig.h"
@interface ZQTabControl ()

@property (nonatomic, copy, readwrite) NSString *title;
/** 私有属性用于自定义视图 主动移除筛选列表  */
@property (nonatomic, copy) void (^didDismissTabMenuBar)(void);
// 是否已经选择赋值
@property (nonatomic, assign) BOOL isHadChoice;
// 是否只显示选择图片
@property (nonatomic, assign) BOOL isShowPic;
/** 配置对象 */
@property (nonatomic, strong, readwrite) ZQFilterMenuControlConfig *config;
/// 非选中图片
@property (nonatomic, strong) NSString *norImgStr;
/// 选中图片
@property (nonatomic, strong) NSString *selImgStr;

@end

@implementation ZQTabControl

+ (instancetype)tabControlWithConfig:(ZQFilterMenuControlConfig *)config
{
    ZQTabControl *tabControl = [[ZQTabControl alloc] init];
    tabControl.config = config;
    tabControl.title = config.title;
    [tabControl setTitle:config.title forState:UIControlStateNormal];
    tabControl.titleLabel.font = config.titleFont;
    tabControl.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [tabControl setTitleColor:config.titleNormalColor forState:UIControlStateNormal];
    [tabControl setImage:config.indicatorNormalImg forState:UIControlStateNormal];
    [tabControl setImage:config.indicatorSelectedImg forState:UIControlStateSelected];
    return tabControl;
}

- (NSString *)getControlTitle{
    return self.title;
}

- (TabControlType)tabControlType {
    return self.config.type;
}

- (void)adjustFrame {
    if (!_isShowPic) {
        CGFloat offset = 2;
        CGFloat toAddSpacing = self.config.iconAndTitleSpacing + offset;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width + offset, 0, self.imageView.bounds.size.width + toAddSpacing)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width + toAddSpacing, 0, -self.titleLabel.bounds.size.width + offset)];
    }
}

- (void)adjustTitle:(NSString *)title textColor:(UIColor *)color {
    if (![title isKindOfClass:[NSString class]]) return;
    if (self.config.titleLength == 0) {
        [self setTitle:title forState:UIControlStateNormal];
    }else{
        [self setTitle:[self subString:title count:self.config.titleLength] forState:UIControlStateNormal];
    }
    [self setTitleColor:color forState:UIControlStateNormal];
    [self adjustFrame];
    [self dismissTabMenuBar];
}

- (void)dismissTabMenuBar{
    // 移除筛选列表
    if(self.didDismissTabMenuBar){
        self.didDismissTabMenuBar();
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if (_isShowPic) {
        // 重置值
        if (title.length == 0) {
            [self setImage:[UIImage imageNamed:self.norImgStr] forState:UIControlStateNormal];
        } else {
            [self setImage:[UIImage imageNamed:self.selImgStr] forState:UIControlStateNormal];
        }
    }else{
        [super setTitle:title forState:state];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    // 解决微软的暗黑模式适配库对标题颜色的影响
    if (UIControlStateNormal != state) {
        return;
    }
    [super setTitleColor:color forState:state];
}

- (void)showPicNorImgStr:(NSString *)norImgStr selImgStr:(NSString *)selImgStr{
    if (norImgStr.length && selImgStr.length) {
        _isShowPic = YES;
        [self setNorImgStr:norImgStr selImgStr:selImgStr];
    }
}

- (void)setNorImgStr:(NSString *)norImgStr selImgStr:(NSString *)selImgStr{
    if (norImgStr.length && selImgStr.length) {
        self.norImgStr = norImgStr;
        self.selImgStr = selImgStr;
        if (_isShowPic) {
            [self setImage:[UIImage imageNamed:norImgStr] forState:UIControlStateNormal];
            [self setImage:nil forState:UIControlStateSelected];
        } else {
            [self setImage:[UIImage imageNamed:norImgStr] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:selImgStr] forState:UIControlStateSelected];
        }
    }
}

/// 设置titleColor
- (void)setControlTitleStatus:(BOOL)isSelect title:(NSString *)title selTitle:(NSString *)selTitle{
    [self adjustTitle:(isSelect ? selTitle : title) textColor:isSelect ? self.config.titleSelectedColor : self.config.titleNormalColor];
}

- (void)setControlTitle:(NSString *)title{
    BOOL isSelect = ![title isEqualToString:self.title];
    [self setControlTitleStatus:isSelect title:self.title selTitle:title];
}

- (NSString *)subString:(NSString *)str count:(NSInteger)count{
    if (str.length > count) {
        return [NSString stringWithFormat:@"%@...",[str substringToIndex:count]];
    }
    return str;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
