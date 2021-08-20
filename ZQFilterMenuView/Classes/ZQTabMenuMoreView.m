//
//  ZQTabMenuMoreView.m
//  house591
//
//  Created by zhengzeqin on 2019/11/13.
//


#import "ZQTabMenuMoreView.h"
#import "ZQTabMenuMoreCollCell.h"
#import "ZQTabMenuMoreColHeaderView.h"
#import "ZQTabMenuEnsureView.h"
#import "ZQTabMenuMoreFilterData.h"
#import <Masonry/Masonry.h>
#import "UIColor+Util.h"
#import "ZQFliterModelHeader.h"
#import "ZQFilterMenuConfig.h"

typedef NS_ENUM(NSInteger ,ZQTabMenuMoreBottomShowType) {
    ZQTabMenuMoreBottomShowTypeEnsure, //带重置样式
    ZQTabMenuMoreBottomShowTypeInput, //带输入框样式
};

@interface ZQTabMenuMoreView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *moreCollectionView;

/// 是否要恢复上次选择
@property (nonatomic, assign) BOOL isResetStore;
/** 配置对象 */
@property (nonatomic, strong) ZQFilterMenuMoreViewConfig *moreViewConfig;
/** ensureView配置对象 */
@property (nonatomic, strong) ZQFilterMenuEnsureViewConfig *ensureViewConfig;
/** 输入框配置对象 */
@property (nonatomic, strong) ZQFilterMenuRangeViewConfig *inputViewConfig;
/** 显示内容样式类型 */
@property (nonatomic, assign) ZQTabMenuMoreBottomShowType type;
/** 剔除隐藏数据后的数据源*/
@property (nonatomic, strong) NSMutableArray <ZQItemModel *>*showListDataSource;
@end

@implementation ZQTabMenuMoreView

- (instancetype)initWithMoreViewConfig:(ZQFilterMenuMoreViewConfig *)moreViewConfig
                      ensureViewConfig:(ZQFilterMenuEnsureViewConfig *)ensureViewConfig {
    if (self = [super initWithFrame:CGRectZero]) {
        self.moreViewConfig = moreViewConfig;
        self.ensureViewConfig = ensureViewConfig;
        [self creatUI:ZQTabMenuMoreBottomShowTypeEnsure];
    }
    return self;
}

- (instancetype)initWithMoreViewConfig:(ZQFilterMenuMoreViewConfig *)moreViewConfig
                       rangeViewConfig:(ZQFilterMenuRangeViewConfig *)rangeViewConfig {
    if (self = [super initWithFrame:CGRectZero]) {
           self.moreViewConfig = moreViewConfig;
           self.inputViewConfig = rangeViewConfig;
        [self creatUI:ZQTabMenuMoreBottomShowTypeInput];
       }
    return self;
}

- (ZQTabMenuMoreFilterData *)fliterData{
    if (!_fliterData) {
        _fliterData = [[ZQTabMenuMoreFilterData alloc]init];
    }
    return _fliterData;
}

- (NSMutableArray<ZQItemModel *> *)showListDataSource {
    if (_showListDataSource == nil) {
        _showListDataSource = [NSMutableArray array];
    }
    return _showListDataSource;
}

- (void)creatUI:(ZQTabMenuMoreBottomShowType)type {
    self.type = type;
    self.backgroundColor = [UIColor whiteColor];
    ZQWS(weakSelf);
    CGFloat bottomViewH = 73;
    UIView *view = nil;
    if (type == ZQTabMenuMoreBottomShowTypeEnsure) {
        self.ensureView = [[ZQTabMenuEnsureView alloc]initWithConfig:self.ensureViewConfig];
        [self addSubview:self.ensureView];
        view = self.ensureView;
        self.ensureView.clickAction = ^(NSInteger tag) {
            if (tag == 1) { // 重置
                [weakSelf retSetAction];
            }else{ // 确定
                [weakSelf ensureAction];
            }
        };
    } else if (type == ZQTabMenuMoreBottomShowTypeInput) {
        self.inputView = [[ZQTabMenuPriceView alloc]initWithConfig:self.inputViewConfig];
        [self addSubview:self.inputView];
        self.inputView.inputValueBlock = ^(NSInteger tag, NSString *title, NSDictionary *idDic) {
            if(weakSelf.inputSelectBlock) {
                weakSelf.isCustomizeEnter = YES;
                [weakSelf.fliterData.lastMoreSeletedDic removeAllObjects];
                weakSelf.inputSelectBlock(weakSelf,weakSelf.tag,title,idDic);
            }
        };
        self.inputView.ensureInputTypeBlock = ^(ZQTabMenuPriceViewInputIncorrectType incorrectType){ /// todo
            if (incorrectType == ZQTabMenuPriceViewInputIncorrectTypeNoInput) {
                weakSelf.isCustomizeEnter = NO;
                [weakSelf.inputView resetInputText];
                [weakSelf.inputView validlastTextRestoreOrClear:NO];
                [weakSelf ensureAction];
            }
            if (weakSelf.ensureInputTypeBlock) {
                weakSelf.ensureInputTypeBlock(incorrectType);
            }
        };
        self.inputView.startEditBlock = ^{
            [weakSelf resetSeletedAction];
        };
        view = self.inputView;
    }
    if (view) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.bottom.right.equalTo(self);
              make.height.mas_equalTo(bottomViewH);
        }];
    }
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = self.moreViewConfig.minimumInteritemSpacing;
    flowLayout.minimumLineSpacing = self.moreViewConfig.minimumLineSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(self.moreViewConfig.sectionInsetTopSpace, self.moreViewConfig.sectionInsetLeftRightSpace, self.moreViewConfig.sectionInsetBottomSpace, self.moreViewConfig.sectionInsetLeftRightSpace);
    _moreCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    if (@available(iOS 11.0, *)) {
        _moreCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _moreCollectionView.contentInset = self.moreViewConfig.collectionViewInsets;
    _moreCollectionView.showsHorizontalScrollIndicator = NO;
    _moreCollectionView.backgroundColor = self.moreViewConfig.backgroundColor;
    _moreCollectionView.delegate = self;
    _moreCollectionView.dataSource = self;
    _moreCollectionView.scrollEnabled = YES;
    _moreCollectionView.pagingEnabled = NO;
    [_moreCollectionView registerClass:[ZQTabMenuMoreCollCell class] forCellWithReuseIdentifier:@"ZQTabMenuMoreCollCell"];
    [_moreCollectionView registerClass:[ZQTabMenuMoreColHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQTabMenuMoreColHeaderView"];
    [self addSubview:_moreCollectionView];
    [_moreCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (view) {
            make.bottom.equalTo(view.mas_top);
        } else {
            make.bottom.equalTo(self.mas_bottom);
        }
        make.left.right.top.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setListDataSource:(NSArray<ZQItemModel *> *)listDataSource{
    _listDataSource = listDataSource;
    [self.showListDataSource removeAllObjects];
    for (ZQItemModel *model in listDataSource) {
        if (!model.isHide) {
            [self.showListDataSource addObject:model];
        }
    }
    [self.fliterData setListDataSource:self.showListDataSource];
    [self setTabControlTitle];
    [self.moreCollectionView reloadData];
}

- (void)resetChoiceReload{
    [self.fliterData resetChoiceReloadDataSource:self.showListDataSource];
    [self.moreCollectionView reloadData];
}

#pragma mark - Public Method
- (void)tabMenuViewWillAppear{
    if (self.type == ZQTabMenuMoreBottomShowTypeInput) {
        if (self.isCustomizeEnter) { //有自定义输入
            [self.inputView validlastTextRestoreOrClear:YES];
        } else {
            [self resetChoiceReload];
        }
    } else {
        [self resetChoiceReload];
        [self.ensureView resetBtnState];
    }
}

- (void)tabMenuViewWillDisappear{
    if (self.type == ZQTabMenuMoreBottomShowTypeInput) {
        if (self.isCustomizeEnter) { //有自定义输入
            [self.fliterData.lastMoreSeletedDic removeAllObjects];
            [self retSetAction];
        } else {
            [self.inputView resetInputText];
            [self.inputView validlastTextRestoreOrClear:NO];
        }
    }
}

#pragma mark - Action Method
- (void)retSetAction{
    [self.fliterData resetDefaultSelectDataWithDataSource:self.showListDataSource];
    if (self.getCurrentSelectingBlock) { // 获取实时选中项的数据回调
        [self.fliterData updateCurrentSelectedDataSource:self.showListDataSource];
        self.getCurrentSelectingBlock(self, NO, nil, self.fliterData);
    }
    [self.moreCollectionView reloadData];
}

- (void)ensureAction{
    [self.fliterData setLastSelectedDataSource:self.showListDataSource];
    [self setTabControlTitle];
    if (self.selectBlock) {
//        NSString *str = [self.fliterData getSeltedAllTitleDic][@"title"];
//        NSDictionary *dic = [self.fliterData getSeltedAllTitleDic][@"dic"];
        self.selectBlock(self,self.fliterData);
    }
}

#pragma mark - Private Method

/// 设置选中状态
- (void)setTabControlTitle{
    [self.tabControl setControlTitleStatus:[self.fliterData isHadSelected] title:self.tabControl.title selTitle:self.tabControl.title];
}

//输入框样式重置输入内容
- (void)resetInputAction {
    if (self.type == ZQTabMenuMoreBottomShowTypeInput && self.moreViewConfig.isSelectedResetInput) {
        [self.inputView resetInputText];
    }
}

//输入框样式重置选中内容
- (void)resetSeletedAction {
     if (self.type == ZQTabMenuMoreBottomShowTypeInput && self.moreViewConfig.isInputResetSelected) {
         [self.fliterData removeAllSelectData];
         [self.moreCollectionView reloadData];
     }
}

//是否存在选中数据
- (BOOL)isSelectedItemData {
    if(self.fliterData.moreSeletedDic.count > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.showListDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ZQItemModel *model = self.showListDataSource[section];
    NSArray *models = model.showDataSource;
    return models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQTabMenuMoreCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZQTabMenuMoreCollCell" forIndexPath:indexPath];
    cell.config = self.moreViewConfig;
    ZQItemModel *itemModel = self.showListDataSource[indexPath.section];
    ZQItemModel *model = itemModel.showDataSource[indexPath.row];
    NSMutableArray *arr = self.fliterData.moreSeletedDic[ZQNullClass(itemModel.currentID)];
    cell.titleLabel.text = model.displayText;
    if ([arr containsObject:model]) {
        cell.isChoice = YES;
    }else{
        cell.isChoice = NO;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQItemModel *itemModel = self.showListDataSource[indexPath.section];
    ZQItemModel *model = itemModel.showDataSource[indexPath.row];
    NSMutableArray *arr = self.fliterData.moreSeletedDic[ZQNullClass(itemModel.currentID)];
    if (itemModel.selectMode == ZQItemModelSelectModeSingle) {// 单选
        if (model.selectMode != ZQItemModelSelectModeMultiple) {
            [self.fliterData removeAllExtenFixModel:arr selectModel:model];
        }
        [self.fliterData selectModel:model arr:arr];
    }else { //复选
        [self.fliterData selectModel:model arr:arr];
    }
    
    if (itemModel.selectMode == ZQItemModelSelectModeUnlimit) { // 不限和其他数据特殊处理 (选中不限移除其他,选中其他,移除不限)
        if ([model isShowUnlimited]) {
            [self.fliterData removeAllSelectData];
            arr = [NSMutableArray arrayWithObject:model];
        } else {
            [self.fliterData removeUnlimitedModelWithArr:arr];
        }
    }
    [self resetInputAction];
    [self.fliterData.moreSeletedDic setObject:arr forKey:ZQNullClass(itemModel.currentID)];
//    [self.moreCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    [self.moreCollectionView reloadData];
    if (self.getCurrentSelectingBlock) { // 选中/取消选中cell 回调
        [self.fliterData updateCurrentSelectedDataSource:self.showListDataSource];
        BOOL isSelect = [arr containsObject:model];
        self.getCurrentSelectingBlock(self, isSelect, model, self.fliterData);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ZQTabMenuMoreColHeaderView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        ZQTabMenuMoreColHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQTabMenuMoreColHeaderView" forIndexPath:indexPath];
        ZQItemModel *model = self.showListDataSource[indexPath.section];
        headerView.titleLabel.text = model.displayText;
        headerView.config = self.moreViewConfig;
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    CGFloat totalCellWidth = self.frame.size.width - self.moreViewConfig.sectionInsetLeftRightSpace * 2 - self.moreViewConfig.minimumInteritemSpacing * (self.moreViewConfig.perLineCellNum-1);
    size = CGSizeMake((totalCellWidth-1)/self.moreViewConfig.perLineCellNum, self.moreViewConfig.cellItemHeight);
    return size;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.frame.size.width, self.moreViewConfig.sectionHeaderHegiht);
}

@end
