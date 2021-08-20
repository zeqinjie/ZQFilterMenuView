//
//  ZQTabMenuEnsureView.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import "ZQTabMenuEnsureView.h"
#import "ZQSeperateLine.h"
#import "ZQFliterModelHeader.h"
#import "UIColor+Util.h"
#import <Masonry/Masonry.h>
#import "ZQFilterMenuConfig.h"
@interface ZQTabMenuEnsureView()
@property (strong, nonatomic) UIButton *resetBtn;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (nonatomic, strong) ZQSeperateLine *topLine;
@property (nonatomic, strong) ZQFilterMenuEnsureViewConfig *config;
@property (nonatomic, strong) UIActivityIndicatorView *ensureLoadingIndicatorView;
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
        _topLine = [[ZQSeperateLine alloc] init];
    }
    return _topLine;
}


- (void)creatUI{
    CGFloat heigth = self.config.btnHeight;
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
    if (self.config.isBtnOnCenterY) {
        [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.config.btnsLeftRightSpace);
            make.height.mas_equalTo(heigth);
            make.centerY.equalTo(self);
        }];
    } else {
        [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.config.btnsLeftRightSpace);
            make.height.mas_equalTo(heigth);
            make.top.equalTo(self).offset(self.config.btnTopSpace);
        }];
    }
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
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.resetBtn.mas_right).offset(self.config.btnGap);
        make.right.mas_equalTo(-self.config.btnsLeftRightSpace);
        make.height.bottom.equalTo(resetBtn);
        make.width.equalTo(resetBtn).dividedBy(self.config.resetBtnRatioToConfirmBtn);
    }];
    self.confirmBtn = confirmBtn;
    if (self.config.isShowTopLine) {
        [self addSubview:self.topLine];
        self.topLine.backgroundColor = self.config.topLineColor;
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(self.config.topLineHeight);
        }];
    }
    [self.confirmBtn addSubview:self.ensureLoadingIndicatorView];
    [self.ensureLoadingIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.confirmBtn);
    }];
}

//單獨確認UI
- (void)cretaeConfirmBtnUI {
    CGFloat width = (ZQScreenWidth - self.config.btnsLeftRightSpace * 2)/2;
    CGFloat heigth = self.config.btnHeight;
    CGFloat y = (self.frame.size.height - heigth)/2;
    self.backgroundColor = self.config.backgroundColor;
    //確定按鈕
    UIButton *confirmBtn = [self creatButtonTitle:self.config.confirmBtnTitle
                                            color:self.config.confirmBtnTitleColor
                                             font:self.config.confirmBtnFont
                                           target:self
                                           action:@selector(btnAction:)];
    confirmBtn.backgroundColor = self.config.confirmBtnBgColor;
    confirmBtn.tag = 2;
    [self addSubview:confirmBtn];
    confirmBtn.frame = CGRectMake(self.config.btnsLeftRightSpace, y, width, heigth);
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-self.config.btnsLeftRightSpace);
        make.left.mas_equalTo(self.config.btnsLeftRightSpace);
        make.height.mas_equalTo(heigth);
        make.width.mas_equalTo(width);
    }];
    self.confirmBtn = confirmBtn;
    if (self.config.isShowTopLine) {
        [self addSubview:self.topLine];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(self.config.topLineHeight);
        }];
    }
}

#pragma mark - Public Method
// 变成加载中状态
- (void)setLoadingState {
    self.resetBtn.userInteractionEnabled = NO;
    self.resetBtn.titleLabel.textColor = self.config.resetBtnTitleColorInloading;
    self.confirmBtn.userInteractionEnabled = NO;
    [self.confirmBtn setTitle:@"" forState:UIControlStateNormal];
    [self.ensureLoadingIndicatorView startAnimating];
}

// 变成加载完毕状态
- (void)finishLoadingWithTitleStr:(NSString *)infoStr {
    [self.ensureLoadingIndicatorView stopAnimating];
    self.resetBtn.userInteractionEnabled = YES;
    self.resetBtn.titleLabel.textColor = self.config.resetBtnTitleColor;
    self.confirmBtn.userInteractionEnabled = YES;
    if (infoStr && infoStr.length > 0) {
        [self.confirmBtn setTitle:infoStr forState:UIControlStateNormal];
    } else {
        [self.confirmBtn setTitle:self.config.confirmBtnTitle forState:UIControlStateNormal];
    }
}

// 重置按钮状态
- (void)resetBtnState {
    [self.ensureLoadingIndicatorView stopAnimating];
    self.resetBtn.userInteractionEnabled = YES;
    self.resetBtn.titleLabel.textColor = self.config.resetBtnTitleColor;
    self.confirmBtn.userInteractionEnabled = YES;
    [self.confirmBtn setTitle:self.config.confirmBtnTitle forState:UIControlStateNormal];
}

// 设置确认按钮文字内容
- (void)setConfirmBtnTitle:(NSString *)titleStr {
    if (!titleStr) {
        return;
    }
    [self.confirmBtn setTitle:titleStr forState:UIControlStateNormal];
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

- (UIActivityIndicatorView *)ensureLoadingIndicatorView {
    if (_ensureLoadingIndicatorView == nil) {
        _ensureLoadingIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.config.ensureLoadingIndicatorViewSize.width, self.config.ensureLoadingIndicatorViewSize.height)];
        if (@available(iOS 13.0, *)) {
            _ensureLoadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        }else{
            _ensureLoadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
        _ensureLoadingIndicatorView.color = self.config.ensureLoadingIndicatorViewColor;
    }
    return _ensureLoadingIndicatorView;
}

#pragma mark - Action
- (void)btnAction:(UIButton *)btn{
    if (self.clickAction) {
        self.clickAction(btn.tag);
    }
}

@end

