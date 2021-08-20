//
//  ZQTabMenuMoreSectionHeaderView.m
//  house591
//
//  Created by zhengzeqin on 2019/11/14.
//

#import "ZQTabMenuMoreColHeaderView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Util.h"
#import "ZQFilterMenuConfig.h"
@interface ZQTabMenuMoreColHeaderView()

@end

@implementation ZQTabMenuMoreColHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.titleLabel];
}

- (void)setConfig:(ZQFilterMenuMoreViewConfig *)config {
    _config = config;
    self.titleLabel.textColor = config.moreSectionHeaderTitleColor;
    self.titleLabel.font = config.sectionHeaderTitleFont;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(config.sectionHeaderTitleLabelTopSpace);
        make.left.mas_equalTo(config.sectionHeaderTitleLabelLeftSpace);
        make.height.mas_equalTo(config.sectionHeaderTitleLabelHeight);
    }];
}

@end
