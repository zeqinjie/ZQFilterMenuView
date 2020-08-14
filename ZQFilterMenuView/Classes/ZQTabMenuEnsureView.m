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
#import "ZQFilterMenuConfig.h"
@interface ZQTabMenuEnsureView()
@property (strong, nonatomic) UIButton *resetBtn;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (nonatomic, strong) ZQSeperateLine *topLine;
@property (nonatomic, strong) ZQFilterMenuEnsureViewConfig *config;
@end

@implementation ZQTabMenuEnsureView

- (instancetype)initWithConfig:(ZQFilterMenuEnsureViewConfig *)config {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.config = config;
        if (self.config.isHiddenResetBtn) {
            [self cretaeConfirmBtnUI];
        } else {
            [self creatUI];
        }
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
    self.backgroundColor = self.config.backgroundColor;
    //重置按鈕
    UIButton *resetBtn = [self creatButtonTitle:self.config.resetBtnTitle
                                          color:self.config.resetBtnTitleColor
                                           font:self.config.resetBtnFont
                                         target:self
                                         action:@selector(btnAction:)];
    resetBtn.backgroundColor = self.config.resetBtnBgColor;
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
    UIButton *confirmBtn = [self creatButtonTitle:self.config.confirmBtnTitle
                                            color:self.config.confirmBtnTitleColor
                                             font:self.config.confirmBtnFont
                                           target:self
                                           action:@selector(btnAction:)];
    confirmBtn.backgroundColor = self.config.confirmBtnBgColor;
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

//單獨確認UI
- (void)cretaeConfirmBtnUI {
    CGFloat width = (ZQScreenWidth - GAP * 2)/2;
    CGFloat heigth = 47;
    CGFloat y = (self.frame.size.height - heigth)/2;
    //確定按鈕
    UIButton *confirmBtn = [self creatButtonTitle:self.config.confirmBtnTitle
                                            color:self.config.confirmBtnTitleColor
                                             font:self.config.confirmBtnFont
                                           target:self
                                           action:@selector(btnAction:)];
    confirmBtn.backgroundColor = self.config.confirmBtnBgColor;
    confirmBtn.tag = 2;
    [self addSubview:confirmBtn];
    confirmBtn.frame = CGRectMake(GAP, y, width, heigth);
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-GAP);
        make.left.mas_equalTo(GAP);
        make.height.mas_equalTo(heigth);
        make.width.mas_equalTo(width);
    }];
    self.confirmBtn = confirmBtn;
    [self addSubview:self.topLine];
}

#pragma mark - Private Method
- (UIButton *)creatButtonTitle:(NSString *)title
                         color:(UIColor *)color
                          font:(UIFont *)font
                        target:(id)target
                        action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(title)[btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = font;
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

