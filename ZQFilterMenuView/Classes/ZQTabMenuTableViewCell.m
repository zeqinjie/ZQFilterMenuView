//
//  ZQTabMenuTableViewCell.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import "ZQTabMenuTableViewCell.h"
#import <ZQFoundationKit/UIColor+Util.h>
#import <Masonry/Masonry.h>
#import "ZQFilterMenuTool.h"
@interface ZQTabMenuTableViewCell()

@end

@implementation ZQTabMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setImage:[ZQFilterMenuTool imageNamed:@"twhouse_menu_unsel"] forState:UIControlStateNormal];
    [self.checkButton setImage:[ZQFilterMenuTool imageNamed:@"twhouse_menu_sel"] forState:UIControlStateSelected];
    self.checkButton.userInteractionEnabled = NO;
    self.checkButton.hidden = YES;
    [self.contentView addSubview:self.checkButton];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.width.equalTo(@0.0);
        make.centerY.height.equalTo(self);
        make.right.equalTo(@-20);
    }];
    
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.height.equalTo(self);
        make.right.equalTo(self.checkButton.mas_left);
    }];
}

- (void)setMenuFontSize:(CGFloat)menuFontSize{
    _menuFontSize = menuFontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:self.menuFontSize == 0 ? 14 : self.menuFontSize];
}

- (void)setMenuAligment:(NSTextAlignment)menuAligment{
    _menuAligment = menuAligment;
    self.titleLabel.textAlignment = self.menuAligment;
}

- (void)setModel:(ZQItemModel *)model{
    _model = model;
    self.titleLabel.text = model.displayText;
//    self.isChoice = model.seleceted;
}

- (void)setIsChoice:(BOOL)isChoice{
    _isChoice = isChoice;
    CGFloat checkBtnW = 0;
    CGFloat checkBtnR = 0;
    if (self.model.selectMode == 1) { //复选类型
        self.checkButton.hidden = NO;
        checkBtnW = 15;
        checkBtnR = -20;
        self.checkButton.selected = isChoice;
    }else{
        self.checkButton.hidden = YES;
        checkBtnW = 0;
    }
    [self.checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(checkBtnW);
        make.right.mas_equalTo(checkBtnR);
    }];
    self.titleLabel.textColor = isChoice ? (self.styleColor ? self.styleColor :[UIColor colorWithHexString:@"ff8000"]) : [UIColor colorWithHexString:@"222222"];
}


@end
