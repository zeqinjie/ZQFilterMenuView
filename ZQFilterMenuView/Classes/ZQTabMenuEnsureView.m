//
//  ZQTabMenuEnsureView.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import "ZQTabMenuEnsureView.h"
#import "ZQSeperateLine.h"
#import "ZQFliterModelHeader.h"
#import <ZQFoundationKit/UIColor+Util.h>
#import <Masonry/Masonry.h>
@interface ZQTabMenuEnsureView()
@property (strong, nonatomic) UIButton *resetBtn;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (nonatomic, strong) ZQSeperateLine *topLine;
@end

@implementation ZQTabMenuEnsureView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         [self creatUI];
    }
    return self;
}

- (ZQSeperateLine *)topLine {
    if (!_topLine) {
        _topLine = [[ZQSeperateLine alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    }
    return _topLine;
}


#define GAP  20
- (void)creatUI{
    CGFloat width = (ZQScreenWidth - GAP * 3)/2;
    CGFloat heigth = 47;
    CGFloat y = (self.frame.size.height - heigth)/2;
    self.backgroundColor = [UIColor whiteColor];
    //重置按鈕
    UIButton *resetBtn = [self creatButtonTitle:@"重置" color:[UIColor colorWithHexString:@"999999"] fontSize:16 target:self action:@selector(btnAction:)];
    resetBtn.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    resetBtn.tag = 1;
    [self addSubview:resetBtn];
    resetBtn.frame = CGRectMake(GAP, y, width, heigth);
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GAP);
        make.height.mas_equalTo(heigth);
        make.width.mas_equalTo(width);
        make.centerY.equalTo(self);
    }];
    self.resetBtn = resetBtn;
    
    //確定按鈕
    UIButton *confirmBtn = [self creatButtonTitle:@"確定" color:[UIColor whiteColor] fontSize:16 target:self action:@selector(btnAction:)];
    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"ff8000"];
    confirmBtn.tag = 2;
    [self addSubview:confirmBtn];
    confirmBtn.frame = CGRectMake(resetBtn.frame.size.width + resetBtn.frame.origin.x + GAP, y, width, heigth);
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-GAP);
        make.height.bottom.width.equalTo(resetBtn);
    }];
    self.confirmBtn = confirmBtn;
    [self addSubview:self.topLine];
}

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
    self.confirmBtn.backgroundColor = styleColor;
    [self.resetBtn setTitleColor:styleColor forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:styleColor forState:UIControlStateSelected];
}


#pragma mark - Private Method
- (UIButton *)creatButtonTitle:(NSString *)title
                         color:(UIColor *)color
                      fontSize:(CGFloat)size
                        target:(id)target
                        action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(title)[btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 2;
    if(color)[btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}

#pragma mark - Action
- (void)btnAction:(UIButton *)btn{
    if (self.clickAction) {
        self.clickAction(btn.tag);
    }
}

@end
