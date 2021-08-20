//
//  ZQTabMenuMoreCollCell.m
//  house591
//
//  Created by zhengzeqin on 2019/11/14.
//

#import "ZQTabMenuMoreCollCell.h"
#import "UIColor+Util.h"
#import <Masonry/Masonry.h>
#import "ZQFilterMenuConfig.h"
@interface ZQTabMenuMoreCollCell()

@end

@implementation ZQTabMenuMoreCollCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(1);
        make.bottom.equalTo(self.contentView).offset(-1);
    }];
    [self didSelectColor:NO];
}

-(void)setConfig:(ZQFilterMenuMoreViewConfig *)config {
    _config = config;
    self.titleLabel.font = config.moreCellTitleFont;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setIsChoice:(BOOL)isChoice{
    _isChoice = isChoice;
    [self didSelectColor:isChoice];
}

#pragma mark - Private Method
- (void)didSelectColor:(BOOL)isDidSelect{
    if (isDidSelect) {
        self.contentView.backgroundColor = self.config.moreCellSelectedBgColor;
        self.titleLabel.textColor = self.config.moreCellTitleSelectedColor;
        [self setClipsToBoundsView:self.contentView cornerRadius:self.config.moreCellCornerRadius borderWidth:self.config.moreCellBorderWidth borderColor:self.config.moreCellSelectedBorderColor];
    }else{
        self.contentView.backgroundColor = self.config.moreCellNormalBgColor;
        self.titleLabel.textColor = self.config.moreCellTitleNormalColor;
        [self setClipsToBoundsView:self.contentView cornerRadius:self.config.moreCellCornerRadius borderWidth:self.config.moreCellBorderWidth borderColor:self.config.moreCellNormalBorderColor];
    }
}

- (UILabel *)creatLabelFont:(UIFont *)font
                       text:(NSString *)text
                      color:(UIColor *)color{
    UILabel *l = [[UILabel alloc]init];
    l.textAlignment = NSTextAlignmentCenter;
    l.numberOfLines = 1;
    l.font = font;
    l.text = text;
    l.textColor = color;
    return l;
}

- (void)setClipsToBoundsView:(UIView *)view
                cornerRadius:(CGFloat)cornerRadius
                 borderWidth:(CGFloat)borderWidth
                 borderColor:(UIColor *)borderColor{
    view.clipsToBounds = YES;
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = borderColor.CGColor;
}

#pragma mark - Override Method
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self didSelectColor:self.isChoice];
}

@end
