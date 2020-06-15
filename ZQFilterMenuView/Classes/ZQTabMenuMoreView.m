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
#import <ZQFoundationKit/UIColor+Util.h>
#import "ZQFliterModelHeader.h"
@interface ZQTabMenuMoreView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *moreCollectionView;

/// 是否要恢复上次选择
@property (nonatomic, assign) BOOL isResetStore;

@property (nonatomic, strong) ZQTabMenuEnsureView *ensureView;

@property (nonatomic, strong) ZQTabMenuMoreFilterData *fliterData;

@end

@implementation ZQTabMenuMoreView
#define GAP  20
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         [self creatUI];
    }
    return self;
}

- (ZQTabMenuMoreFilterData *)fliterData{
    if (!_fliterData) {
        _fliterData = [[ZQTabMenuMoreFilterData alloc]init];
    }
    return _fliterData;
}

- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    ZQWS(weakSelf);
    CGFloat bottomViewH = 73;
    self.ensureView = [[ZQTabMenuEnsureView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.ensureView];
    [self.ensureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(bottomViewH);
    }];
    self.ensureView.clickAction = ^(NSInteger tag) {
        if (tag == 1) { // 重置
            [weakSelf retSetAction];
        }else{ // 确定
            [weakSelf ensureAction];
        }
    };
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = GAP;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, GAP, GAP, GAP);
    _moreCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _moreCollectionView.showsHorizontalScrollIndicator = NO;
    _moreCollectionView.backgroundColor = [UIColor whiteColor];
    _moreCollectionView.delegate = self;
    _moreCollectionView.dataSource = self;
    _moreCollectionView.scrollEnabled = YES;
    _moreCollectionView.pagingEnabled = NO;
    [_moreCollectionView registerClass:[ZQTabMenuMoreCollCell class] forCellWithReuseIdentifier:@"ZQTabMenuMoreCollCell"];
    [_moreCollectionView registerClass:[ZQTabMenuMoreColHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQTabMenuMoreColHeaderView"];
    [self addSubview:_moreCollectionView];
    [_moreCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ensureView.mas_top);
        make.left.right.top.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setListDataSource:(NSArray<ZQItemModel *> *)ListDataSource{
    _ListDataSource = ListDataSource;
    [self.fliterData setListDataSource:ListDataSource];
    [self setTabControlTitle];
    [self.moreCollectionView reloadData];
}

- (void)resetChoiceReload{
    [self.fliterData resetChoiceReloadDataSource:self.ListDataSource];
    [self.moreCollectionView reloadData];
}

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
    self.ensureView.styleColor = styleColor;
}

#pragma mark - Public Method
- (void)tabMenuViewWillAppear{
    [self resetChoiceReload];
}

- (void)tabMenuViewWillDisappear{
    
}

#pragma mark - Action Method
- (void)retSetAction{
    [self.fliterData removeAllSelectData];
    [self.moreCollectionView reloadData];
}

- (void)ensureAction{
    [self.fliterData setLastSelectedDataSource:self.ListDataSource];
    [self setTabControlTitle];
    if (self.selectBlock) {
        self.selectBlock(self,self.fliterData.lastMoreSeletedDic,self.fliterData.moreSeletedDic);
    }
}

#pragma mark - Private Method
/// 设置选中状态
- (void)setTabControlTitle{
    [self.tabControl setControlTitleStatus:[self.fliterData isHadSelected] title:self.tabControl.title selTitle:self.tabControl.title];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.ListDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ZQItemModel *model = self.ListDataSource[section];
    NSArray *models = model.dataSource;
    return models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQTabMenuMoreCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZQTabMenuMoreCollCell" forIndexPath:indexPath];
    cell.styleColor = self.styleColor;
    cell.didSelectBgColor = self.didSelectBgColor;
    cell.didUnSelectBgColor = self.didUnSelectBgColor;
    ZQItemModel *itemModel = self.ListDataSource[indexPath.section];
    ZQItemModel *model = itemModel.dataSource[indexPath.row];
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
    ZQItemModel *itemModel = self.ListDataSource[indexPath.section];
    ZQItemModel *model = itemModel.dataSource[indexPath.row];
    NSMutableArray *arr = self.fliterData.moreSeletedDic[ZQNullClass(itemModel.currentID)];
    if (itemModel.selectMode == 0) {// 单选
        if (model.selectMode != 1) {
            [self.fliterData removeAllExtenFixModel:arr selectModel:model];
        }
        [self.fliterData selectModel:model arr:arr];
    }else { //复选
        [self.fliterData selectModel:model arr:arr];
    }
    [self.fliterData.moreSeletedDic setObject:arr forKey:ZQNullClass(itemModel.currentID)];
    [self.moreCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ZQTabMenuMoreColHeaderView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        ZQTabMenuMoreColHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQTabMenuMoreColHeaderView" forIndexPath:indexPath];
        ZQItemModel *model = self.ListDataSource[indexPath.section];
        headerView.titleLabel.text = model.displayText;
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    size = CGSizeMake((ZQScreenWidth - GAP * 4)/3, 34);
    return size;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ZQScreenWidth, 60);
}

@end
