//
//  ZQTabMenuMoreCollCell.m
//  house591
//
//  Created by zhengzeqin on 2019/11/14.
//

#import "ZQTabMenuMoreCollCell.h"
#import <ZQFoundationKit/UIColor+Util.h>
#import <Masonry/Masonry.h>
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
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.contentView);
    }];
    [self didSelectColor:NO];
}

- (void)setIsChoice:(BOOL)isChoice{
    _isChoice = isChoice;
    [self didSelectColor:isChoice];
}

#pragma mark - Private Method
- (void)didSelectColor:(BOOL)isDidSelect{
    if (isDidSelect) {
        self.contentView.backgroundColor = self.didSelectBgColor ? self.didSelectBgColor : [UIColor colorWithHexString:@"faf5f2"];
        self.titleLabel.textColor = (self.styleColor ? self.styleColor : [UIColor colorWithHexString:@"ff8000"]);
        [self setClipsToBoundsView:self.contentView cornerRadius:0 borderWidth:1 borderColor:(self.styleColor ? self.styleColor : [UIColor colorWithHexString:@"ff8000"])];
    }else{
        self.contentView.backgroundColor = self.didUnSelectBgColor ? self.didUnSelectBgColor : [UIColor colorWithHexString:@"f5f5f5"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
        [self setClipsToBoundsView:self.contentView cornerRadius:0 borderWidth:1 borderColor:[UIColor colorWithHexString:@"f5f5f5"]];
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

@end
