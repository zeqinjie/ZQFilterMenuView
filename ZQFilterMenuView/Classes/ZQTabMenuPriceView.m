//
//  ZQTabMenuPriceFooterView.m
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//

#import "ZQTabMenuPriceView.h"
//#import "UIView+ShowHUD.h"
#import "ZQSeperateLine.h"
#import <Masonry/Masonry.h>
#import "UIColor+Util.h"
#import "ZQFliterModelHeader.h"
#import "ZQFilterMenuConfig.h"
@interface ZQTabMenuPriceView()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *minTextField;
@property (nonatomic,strong) UITextField *maxTextField;
@property (nonatomic,strong) UIButton *confirmButton;
@property (strong, nonatomic) UILabel *unitLabel;//單位
@property (nonatomic, strong) ZQSeperateLine *topLine;
@property (nonatomic, strong) ZQFilterMenuRangeViewConfig *config;
@end

@implementation ZQTabMenuPriceView

- (instancetype)initWithConfig:(ZQFilterMenuRangeViewConfig *)config {
    if (self = [super initWithFrame:CGRectZero]) {
        self.config = config;
        [self creatUI];
    }
    return self;
}

- (ZQSeperateLine *)topLine {
    if (!_topLine) {
        _topLine = [[ZQSeperateLine alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.config.topLineHeight)];
        _topLine.backgroundColor = self.config.topLineColor;
    }
    return _topLine;
}

- (void)creatUI{
    self.backgroundColor = self.config.backgroundColor;
    CGFloat gap = 20;
    CGFloat linegap = 4;
    
    self.minTextField = [self getTextFieldHolder:self.config.minValueTitle tag:1];
    [self addSubview:self.minTextField];
    [self.minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(gap);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(self.config.textFieldHeight);
        make.width.mas_equalTo(self.config.textFieldWidth);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = self.config.rangeLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minTextField.mas_right).offset(linegap);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(8);
        make.centerY.equalTo(self.minTextField);
    }];
    
    self.maxTextField = [self getTextFieldHolder:self.config.maxValueTitle tag:2];
    [self addSubview:self.maxTextField];
    [self.maxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(linegap);
        make.height.width.centerY.mas_equalTo(self.minTextField);
    }];
    
    self.unitLabel = [[UILabel alloc]init];
    self.unitLabel.text = self.config.unitLabelTitle;
    self.unitLabel.textColor = self.config.unitLabelColor;
    self.unitLabel.numberOfLines = 1;
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.font = self.config.unitLabelFont;
    [self addSubview:self.unitLabel];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maxTextField.mas_right).offset(linegap);
        make.centerY.height.equalTo(self.minTextField);
    }];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:self.config.confirmBtnTitle forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = self.config.confirmBtnFont;
    [self.confirmButton setTitleColor:self.config.confirmBtnTitleColor forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.backgroundColor = self.config.confirmBtnBgColor;
    self.confirmButton.clipsToBounds = YES;
    self.confirmButton.layer.cornerRadius = 2;
    
    [self addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-gap);
        make.centerY.mas_equalTo(self.minTextField);
        make.height.mas_equalTo(self.config.confirmButtonHeight);
        make.width.mas_equalTo(self.config.confirmButtonWidth);
    }];
    
    [self addSubview:self.topLine];
}

#pragma mark - Getter && Setter
- (UITextField *)getTextFieldHolder:(NSString *)placeHolder tag:(NSInteger)tag{
    UITextField *textField = [[UITextField alloc]init];
    textField.font = self.config.rangeTextFieldFont;
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    textField.textColor = self.config.rangeTextFieldColor;
    textField.placeholder = placeHolder;
    if(placeHolder){
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{
            NSForegroundColorAttributeName:self.config.rangeTextFieldPlaceholderColor,
            NSFontAttributeName:self.config.rangeTextFieldFont,
            NSParagraphStyleAttributeName:style
        }];
    }
    textField.clipsToBounds = YES;
    textField.layer.borderWidth = self.config.rangeTextFieldBorderWidth;
    textField.layer.borderColor = self.config.rangeTextFieldBorderColor.CGColor;
    textField.tag = tag;
    textField.textAlignment = NSTextAlignmentCenter;
    return textField;
}

- (ZQTabMenuPriceViewInputIncorrectType)textFieldGuide:(UITextField *)textField{
    BOOL isFix = NO;
    ZQTabMenuPriceViewInputIncorrectType inputType = ZQTabMenuPriceViewInputIncorrectTypeNoInput;
    if (self.maxTextField.text.length && self.minTextField.text.length) {
        CGFloat endF = self.maxTextField.text.floatValue;
        CGFloat beF = self.minTextField.text.floatValue;
        if (endF > beF) {
            isFix = YES;
            inputType = ZQTabMenuPriceViewInputIncorrectTypeIncorrect;
        }
        if (self.maxTextField == textField) {
            if (!isFix) {
                inputType = ZQTabMenuPriceViewInputIncorrectTypeMaxIncorrect;
                textField.text = @"";
            }
        }else{
            if (!isFix) {
                inputType = ZQTabMenuPriceViewInputIncorrectTypeMinIncorrect;
                textField.text = @"";
            }
        }
    }else if(self.maxTextField.text.length == 0 && self.minTextField.text.length == 0){
        inputType = ZQTabMenuPriceViewInputIncorrectTypeNoInput;
    }else{
        inputType = ZQTabMenuPriceViewInputIncorrectTypeIncorrect;
    }
    return inputType;
}

#pragma mark - Public
- (void)setMaxprice:(NSString *)maxprice minprice:(NSString *)minprice{
    self.minTextField.text = minprice;
    self.maxTextField.text = maxprice;
    if ([self getInputTitle]) {
        [self.tabControl setControlTitle:[self getInputTitle]];
    }
}

///重置输入内容
- (void)resetInputText {
    self.minTextField.text = @"";
    self.maxTextField.text = @"";
}

//恢复或者清空最后一次输入的有效值
- (void)validlastTextRestoreOrClear:(BOOL)isRestore {
    if (isRestore) {
        self.minTextField.text = self.lastValidMinText;
        self.maxTextField.text = self.lastValidMaxText;
    } else {
        self.lastValidMinText = @"";
        self.lastValidMaxText = @"";
    }
}

#pragma mark - Private
- (NSDictionary *)getInputIdDic{
    NSString *mix = ZQNullClass(self.minTextField.text);
    NSString *max = ZQNullClass(self.maxTextField.text);
    NSString *idStr = @"";
    if (mix.length && max.length) {
        idStr = [NSString stringWithFormat:@"%@_%@",mix,max];
    }else if (mix.length) {
        idStr = [NSString stringWithFormat:@"%@_",mix];
    }else if (max.length) {
        idStr = [NSString stringWithFormat:@"0_%@",max];
    }
    return @{@"idStr":idStr,@"min":mix,@"max":max};
}

- (NSString *)getInputTitle{
    NSString *mix = self.minTextField.text;
    NSString *max = self.maxTextField.text;
    NSString *unitStr = self.config.unitLabelTitle;
    if (mix.length && max.length) {
        return [NSString stringWithFormat:@"%@-%@%@",mix,max,unitStr];
    }else if (mix.length) {
        return [NSString stringWithFormat:@"%@%@以上",mix,unitStr];
    }else if (max.length) {
        return [NSString stringWithFormat:@"%@%@以下",max,unitStr];
    }else{
        return nil;
    }
}

#pragma mark - Action
- (void)confirmButtonAction{
//    BOOL fix = NO;
    ZQTabMenuPriceViewInputIncorrectType inputType = ZQTabMenuPriceViewInputIncorrectTypeNoInput;
    UITextField *textField;
    if ([self.minTextField isFirstResponder]) {
        inputType = [self textFieldGuide:self.minTextField];
        textField = self.minTextField;
    }else{
        inputType = [self textFieldGuide:self.maxTextField];
        textField = self.maxTextField;
    }
    [textField resignFirstResponder];
    if (self.inputValueBlock) {
        if (inputType == ZQTabMenuPriceViewInputIncorrectTypeIncorrect && [self getInputTitle]) {
            [self.tabControl setControlTitle:[self getInputTitle]];
            self.lastValidMaxText = self.maxTextField.text;
            self.lastValidMinText = self.minTextField.text;
            self.inputValueBlock(self.tag,[self getInputTitle], [self getInputIdDic]);
        }
    }
    if (self.ensureInputTypeBlock) {
        self.ensureInputTypeBlock(inputType);
    }
}

#pragma mark - Override Method
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    self.minTextField.layer.borderColor = self.config.rangeTextFieldBorderColor.CGColor;
    self.maxTextField.layer.borderColor = self.config.rangeTextFieldBorderColor.CGColor;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(self.startEditBlock) {
        self.startEditBlock();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
