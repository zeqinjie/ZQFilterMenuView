//
//  ZQTabControl.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import "ZQTabControl.h"
#import "ZQTabMenuBar.h"
#import <ZQFoundationKit/UIColor+Util.h>
#import "TWHouseUIKitTool.h"
@interface ZQTabControl ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) TabControlType tabControlType;
/** 私有属性用于自定义视图 主动移除筛选列表  */
@property (nonatomic, copy) void (^didDismissTabMenuBar)(void);
// 是否已经选择赋值
@property (nonatomic, assign) BOOL isHadChoice;
// 是否只显示选择图片
@property (nonatomic, assign) BOOL isShowPic;

@end

@implementation ZQTabControl

+ (instancetype)tabControlWithTitle:(NSString *)title type:(TabControlType)type
{
    ZQTabControl *tabControl = [[ZQTabControl alloc] init];
    tabControl.title = title;
    tabControl.tabControlType = type;
    tabControl.menuViewHeigthRatio = 0.5;
    tabControl.menuCellHeigth = 44;
    tabControl.selTitleColor = [UIColor colorWithHexString:@"ff8000"];
    tabControl.titleColor = [UIColor colorWithHexString:@"222222"];
    [tabControl setTitle:title forState:UIControlStateNormal];
    tabControl.titleLabel.font = [UIFont systemFontOfSize:14];
    tabControl.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [tabControl setTitleColor:tabControl.titleColor forState:UIControlStateNormal];
    [tabControl setImage:[TWHouseUIKitTool imageNamed:@"twhouse_menu_down"] forState:UIControlStateNormal];
    [tabControl setImage:[TWHouseUIKitTool imageNamed:@"twhouse_menu_up"] forState:UIControlStateSelected];
    return tabControl;
}

- (NSString *)getControlTitle{
    return self.title;
}

- (void)adjustFrame {
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width + 2, 0, self.imageView.bounds.size.width + 10)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width + 10, 0, -self.titleLabel.bounds.size.width + 2)];
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)adjustTitle:(NSString *)title textColor:(UIColor *)color {
    if (![title isKindOfClass:[NSString class]]) return;
    if (_menuTitleLength == 0) {
        [self setTitle:title forState:UIControlStateNormal];
    }else{
        [self setTitle:[self subString:title count:_menuTitleLength] forState:UIControlStateNormal];
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
        _isHadChoice = ![self.title isEqualToString:title];
    }else{
        [super setTitle:title forState:state];
    }
}

- (void)setSelected:(BOOL)selected{
    if (_isShowPic) {
        if (!_isHadChoice) { //是有没有选择的赋值
            [super setSelected:selected];
        }
    }else{
        [super setSelected:selected];
    }
}

- (void)showPicNorImgStr:(NSString *)norImgStr selImgStr:(NSString *)selImgStr{
    if (norImgStr.length && selImgStr.length) {
        _isShowPic = YES;
        [self setNorImgStr:norImgStr selImgStr:selImgStr];
    }
}

- (void)setNorImgStr:(NSString *)norImgStr selImgStr:(NSString *)selImgStr{
    if (norImgStr.length && selImgStr.length) {
        [self setImage:[UIImage imageNamed:norImgStr] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selImgStr] forState:UIControlStateSelected];
    }
}

/// 设置titleColor
- (void)setControlTitleStatus:(BOOL)isSelect title:(NSString *)title selTitle:(NSString *)selTitle{
    [self adjustTitle:(isSelect ? selTitle : title) textColor:isSelect ? self.selTitleColor : self.titleColor];
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
