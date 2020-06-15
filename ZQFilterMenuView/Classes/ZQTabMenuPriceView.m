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
#import <ZQFoundationKit/UIColor+Util.h>
#import "ZQFliterModelHeader.h"
@interface ZQTabMenuPriceView()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *minTextField;
@property (nonatomic,strong) UITextField *maxTextField;
@property (nonatomic,strong) UIButton *confirmButton;
@property (strong, nonatomic) UILabel *unitLabel;//單位
@property (nonatomic, strong) ZQSeperateLine *topLine;
@end

@implementation ZQTabMenuPriceView

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

- (void)setUnitStr:(NSString *)unitStr{
    _unitStr = unitStr;
    self.unitLabel.text = unitStr;
}

- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat textFieldW = 87;
    CGFloat textFieldH = 36;
    CGFloat gap = 20;
    CGFloat linegap = 4;
    
    self.minTextField = [self getTextFieldHolder:@"最低價" tag:1];
    [self addSubview:self.minTextField];
    [self.minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(gap);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(textFieldH);
        make.width.mas_equalTo(textFieldW);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithHexString:@"979797"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minTextField.mas_right).offset(linegap);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(8);
        make.centerY.equalTo(self.minTextField);
    }];
    
    self.maxTextField = [self getTextFieldHolder:@"最高價" tag:2];
    [self addSubview:self.maxTextField];
    [self.maxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(linegap);
        make.height.width.centerY.mas_equalTo(self.minTextField);
    }];
    
    self.unitLabel = [[UILabel alloc]init];
    self.unitLabel.text = @"元";
    self.unitLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.unitLabel.numberOfLines = 1;
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.unitLabel];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maxTextField.mas_right).offset(linegap);
        make.centerY.height.equalTo(self.minTextField);
        make.width.equalTo(@16);
    }];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"確定" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.backgroundColor = [UIColor colorWithHexString:@"ff8000"];
    self.confirmButton.clipsToBounds = YES;
    self.confirmButton.layer.cornerRadius = 2;
    
    [self addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-gap);
        make.height.width.centerY.mas_equalTo(self.minTextField);
    }];
    
    [self addSubview:self.topLine];
}

#pragma mark - Getter && Setter
- (void)setStyleColor:(UIColor *)styleColor{
    _styleColor = styleColor;
    self.confirmButton.backgroundColor = styleColor;
}

- (UITextField *)getTextFieldHolder:(NSString *)placeHolder tag:(NSInteger)tag{
    UITextField *textField = [[UITextField alloc]init];
    textField.font = [UIFont systemFontOfSize:15];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor colorWithHexString:@"222222"];
    textField.placeholder = placeHolder;
    if(placeHolder){
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"cccccc"],
                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                       NSParagraphStyleAttributeName:style}];
    }
    textField.clipsToBounds = YES;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    textField.tag = tag;
    textField.textAlignment = NSTextAlignmentCenter;
    return textField;
}

- (BOOL)textFieldGuide:(UITextField *)textField{
    BOOL isFix = NO;
    if (self.maxTextField.text.length && self.minTextField.text.length) {
        CGFloat endF = self.maxTextField.text.floatValue;
        CGFloat beF = self.minTextField.text.floatValue;
        if (endF >= beF) {
            isFix = YES;
        }
        if (self.maxTextField == textField) {
            if (!isFix) {
//                [self hideHUDWithStr:@"請輸入值大於最小金額"];
                textField.text = @"";
            }
            
        }else{
            if (!isFix) {
//                [self hideHUDWithStr:@"請輸入值小於最大金額"];
                textField.text = @"";
            }
        }
    }else if(self.maxTextField.text.length == 0 && self.minTextField.text.length == 0){
//        [self hideHUDWithStr:@"請輸入金額"];
    }else{
        isFix = YES;
    }
    return isFix;
}

#pragma mark - Public
- (void)setMaxprice:(NSString *)maxprice minprice:(NSString *)minprice{
    self.minTextField.text = minprice;
    self.maxTextField.text = maxprice;
    if ([self getInputTitle]) {
        [self.tabControl setControlTitle:[self getInputTitle]];
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
    if (mix.length && max.length) {
        return [NSString stringWithFormat:@"%@-%@%@",mix,max,self.unitStr];
    }else if (mix.length) {
        return [NSString stringWithFormat:@"%@%@以上",mix,self.unitStr];
    }else if (max.length) {
        return [NSString stringWithFormat:@"%@%@以下",max,self.unitStr];
    }else{
        return nil;
    }
}

#pragma mark - Action
- (void)confirmButtonAction{
    BOOL fix = NO;
    UITextField *textField;
    if ([self.minTextField isFirstResponder]) {
        fix = [self textFieldGuide:self.minTextField];
        textField = self.minTextField;
    }else{
        fix = [self textFieldGuide:self.maxTextField];
        textField = self.maxTextField;
    }
    if (fix) {
        [textField resignFirstResponder];
        if (self.inputValueBlock) {
            if ([self getInputTitle]) {
                [self.tabControl setControlTitle:[self getInputTitle]];
                self.inputValueBlock(self.tag, [self getInputTitle],[self getInputIdDic]);
            }
        }
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
