//
//  ZQTabMenuTableViewCell.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//

#import "ZQTabMenuTableViewCell.h"
#import "UIColor+Util.h"
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
    if (self.model.selectMode == ZQItemModelSelectModeMultiple) { //复选类型
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
    self.titleLabel.textColor = isChoice ? self.config.menuCellTitleSelectedColor : self.config.menuCellTitleNormalColor;
    [self configBackgroundColorWithSelectState:isChoice];
}

- (void)setConfig:(ZQFilterMenuControlConfig *)config {
    _config = config;
    
    self.titleLabel.font = config.menuCellFont;
    self.titleLabel.textColor = config.menuCellTitleNormalColor;
    self.titleLabel.textAlignment = config.menuCellAligment;
    [self.checkButton setImage:config.menuCellIndicatorNormalImg forState:UIControlStateNormal];
    [self.checkButton setImage:config.menuCellIndicatorSelectedImg forState:UIControlStateSelected];
    
    UIEdgeInsets titleLabelEdgeInsets = config.menuCellTitleLabelEdgeInsets;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(titleLabelEdgeInsets.left);
        make.top.mas_equalTo(titleLabelEdgeInsets.top);
        make.bottom.mas_equalTo(titleLabelEdgeInsets.bottom);
        make.right.equalTo(self.checkButton.mas_left).offset(titleLabelEdgeInsets.right);
    }];
}

// 根据选中状态修改背景色
- (void)configBackgroundColorWithSelectState:(BOOL)isSelect {
    if (!isSelect) {
        self.backgroundColor = [UIColor clearColor];
        return;
    }
    NSArray *colors = self.config.menuViewSelectCellBgColors;
    UIColor *color = self.config.menuViewSelectCellBgColor;
    if (colors && self.listViewIndex <= (int)[colors count]-1) {
        self.backgroundColor = colors[self.listViewIndex];
    } else if (color) {
        self.backgroundColor = color;
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}


@end
