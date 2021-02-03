//
//  ZQTabMenuView.m
//  house591
//
//  Created by zhengzeqin on 2020/5/18.
//  
//

#import "ZQTabMenuView.h"
#import "ZQTabControl.h"
#import "ZQItemModel.h"
#import "ZQTabMenuMoreView.h"
#import "ZQTabMenuTableViewCell.h"
#import "ZQTabMenuEnsureView.h"
#import "ZQFliterSelectData.h"
#import "ZQFliterModelHeader.h"
#import <ZQFoundationKit/UIColor+Util.h>
#define kMAXCount  3 //最大多少列
#define kMutitTitle @"多選"
//#define ZQTabMenuViewHeigthRatio      0.4
@interface ZQTabMenuView () <UITableViewDelegate, UITableViewDataSource>

//最初赋的数据源
@property (nonatomic, strong) NSArray<ZQItemModel *> *listDataSource;

@property (nonatomic, assign) NSInteger firstSelectRow;//第一列选中
@property (nonatomic, assign) NSInteger secondSelectRow;//第二列选中
@property (nonatomic, assign) NSInteger lastSelectRow;//第三列选中
@property (nonatomic, strong) NSArray *tableViewArr;
@property (nonatomic, assign) BOOL flag;//标记，用于记录是否是恢复上次的选中
//@property (nonatomic, assign) NSInteger selectIndex;//设置多级选中下标

@property (nonatomic, strong) ZQFliterSelectData *orginSelectData;//第一次进来的数据源
@property (nonatomic, strong) ZQFliterSelectData *selectData;//最终选中的对象

@property (nonatomic, assign) NSInteger showListViewCount;//当前需要显示的listView的数量

///样式属性
@property (nonatomic, assign) NSTextAlignment menuAligment;
@property (nonatomic, assign) CGFloat menuFontSize;
//是否默认选择下一列数据源的第一个
@property (nonatomic, assign) BOOL menuSecondListFirSelected;

///UI相关
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *menuFooterView;//底部view
@property (nonatomic, strong) ZQTabMenuEnsureView *ensureView;//确认view

@end

@implementation ZQTabMenuView
#pragma mark - Getter && Setter


#pragma mark - LifeCycle
- (instancetype)initWithTabControl:(ZQTabControl *)tabControl {
    if (self = [super init]) {
        self.tabControl = tabControl;
        self.menuSecondListFirSelected = tabControl.menuSecondListFirSelected;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        [self reloadSeletedListDataSource];
    }
    return self;
}

- (void)displayTabMenuViewWithMenuBar:(UIView *)menuBar withTopOffsetY:(CGFloat)offsetY
{
    if (!self.superview) {
        // 初始位置 设置
        CGFloat x = 0.f;
        CGFloat y = menuBar.frame.origin.y + menuBar.frame.size.height + offsetY;
        CGFloat w = ZQScreenWidth;
        CGFloat h = ZQScreenHeight - y;
        self.frame = CGRectMake(x, y, w, h);
        if (self.tabControl.tabControlType == TabControlTypeCustom) {
            if (self.tabControl.displayCustomWithMenu) {
                UIView *customView = self.tabControl.displayCustomWithMenu();
                if (customView) {
                    if ([customView isKindOfClass:[ZQTabMenuMoreView class]]) {
                        ZQTabMenuMoreView *menuMoreView = (ZQTabMenuMoreView *)customView;
                        menuMoreView.tabControl = self.tabControl;
                    }
                    [self addSubview:customView];
                }
            }
        }else {
            [self reloadSeletedListDataSource];//刷新数据 重置默认选中
            [self adjustTableViewsWithCount:[self.selectData getShowListViewCount]];
        }
        if ([self.delegate respondsToSelector:@selector(tabMenuViewToSuperview)]
            && [self.delegate tabMenuViewToSuperview]) {
            //有指定使用指定父视图
            [[self.delegate tabMenuViewToSuperview] addSubview:self];
        }else{
            [menuBar.superview addSubview:self];
        }
        
        if ([self.delegate respondsToSelector:@selector(tabMenuViewWillAppear:)]) {
            [self.delegate tabMenuViewWillAppear:self];
        }
    }else {
        [self dismiss];
    }
}

#pragma mark - Public Method
- (void)resetAllSelectData{
    [ZQFliterSelectData resetAllSelectDataSource:self.listDataSource type:0 row:-1 selectIndex:-1];
}

#pragma mark - Private Method
/**
 //zzq
 重置TableView的显示
 @param count 为对于展示tabelviewe个数
 */
- (void)adjustTableViewsWithCount:(NSInteger)count{
    if (self.showListViewCount != count) { //展示的个数调整
        self.showListViewCount = count;
        CGRect adjustFrame = self.frame;
        CGFloat height = adjustFrame.size.height * self.tabControl.config.menuViewHeigthRatio;
        CGFloat menuLargthHeigth = self.tabControl.config.menuViewLargthHeight;
        if (menuLargthHeigth != 0) {//注意如果不是0 则限制最大高度
            if (height > menuLargthHeigth) {
                height = menuLargthHeigth;
            }
        }
        adjustFrame.size.height = height;
        adjustFrame.origin.y = 0;
        self.contentView.frame = adjustFrame;
        //添加底部view
        if (_menuFooterView == nil) {
            if(self.tabControl.tabControlType == TabControlTypeMutiple) {
                _menuFooterView = self.ensureView;
            }else if ([self.delegate respondsToSelector:@selector(tabMenuViewFooterView:)]) {
                _menuFooterView = [self.delegate tabMenuViewFooterView:self];
            }
            if (_menuFooterView) {
                CGFloat y = _contentView.frame.size.height - _menuFooterView.frame.size.height;
                CGRect frame = _menuFooterView.frame;
                frame.origin.y = y;
                _menuFooterView.frame = frame;
                [_contentView addSubview:_menuFooterView];
            }
        }
        
        adjustFrame.size.height = adjustFrame.size.height -  _menuFooterView.frame.size.height;
        CGFloat tableViewWidth = ZQScreenWidth / count;
        UITableView *lastView = nil;
        for (NSInteger i = 0; i < self.tableViewArr.count; i++) {
            UITableView *tableView = self.tableViewArr[i];
            if (i > count - 1) {//无需展示的设置宽度0
                tableViewWidth = 0;
            }
            if (count == 3) { //三分
                if (i == count - 1) {
                    tableViewWidth = ZQScreenWidth * 0.4;
                }else{
                    tableViewWidth = ZQScreenWidth * 0.3;
                }
            }
            adjustFrame.size.width = tableViewWidth;
            if (lastView) {
                adjustFrame.origin.x = lastView.frame.size.width +  lastView.frame.origin.x;
            }else{
                adjustFrame.origin.x = 0;
            }
            tableView.frame = adjustFrame;
            lastView = tableView;
        }
        
    }
}

//刷新所有
- (void)reloadAllList {
    [self.tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        [tableView reloadData];
    }];
}

//滚动tableView到指定位置
- (void)scrollAllTableIndex{
    for (NSInteger i = 0; i < kMAXCount; i++) {
        [self scrollTableIndex:i];
    }
}

//展示的多少行并滚动到目标
- (void)showListViewCount:(NSInteger)listViewIndex{
    [self adjustTableViewsWithCount:[self.selectData getShowListViewCount]];
    [self reloadAllList];
    for (NSInteger i = listViewIndex + 1; i < kMAXCount; i++) {
        [self scrollTableIndex:i];
    }
}

//滚动第几个tableView
- (void)scrollTableIndex:(NSInteger)listViewIndex{
    if (listViewIndex < kMAXCount) {
        NSArray *dataSource = [self.selectData getListDataSource:self.listDataSource listViewIndex:listViewIndex];
        NSArray *selectIndexArr = [self.selectData getAllSelectIndexArr:YES];
        if (selectIndexArr.count > listViewIndex) {//需判斷數據源是否越界
            NSInteger seletedIndex = [selectIndexArr[listViewIndex] integerValue];
            if (dataSource.count > seletedIndex) {//需判斷數據源是否越界
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:seletedIndex inSection:0];
                UITableView *tableView = self.tableViewArr[listViewIndex];
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
}

/// 设置标题
/// @param showType 类型 如果 = 1 展示标题 不限选中时候，如果 = 0 展示当前model的title = -1 展示多选
- (void)resetActionDisplayText:(NSString *)displayText showType:(NSInteger)showType{
    if (showType == 1) {
        displayText = self.tabControl.title;
    }else if(showType == -1) {
        displayText = kMutitTitle;
    }
    if (displayText.length == 0) {//如果没有
        displayText = self.tabControl.title;
    }
    [self.tabControl setControlTitle:displayText];
}

// 隐藏
- (void)dismiss {
    if (self.superview) {
        [self endEditing:YES];
        if ([self.delegate respondsToSelector:@selector(tabMenuViewWillDisappear:)]) {
            [self.delegate tabMenuViewWillDisappear:self];
        }
        [self removeFromSuperview];
    }
}

// 获取与tableView对应的背景颜色
- (UIColor *)fetchTableViewBgColorWithIndex:(NSInteger)index {
    NSArray *colors = self.tabControl.config.menuViewTableViewBgColors;
    if (colors && index <= (int)[colors count]-1) {
        return colors[index];
    }
    return self.tabControl.config.menuViewTableViewBgColor;
}

// 获取与tableView对应的分割线颜色
- (UIColor *)fetchTableViewSeparatorColorWithIndex:(NSInteger)index {
    NSArray *colors = self.tabControl.config.menuViewTableViewSeparatorColors;
    if (colors && index <= (int)[colors count]-1) {
        return colors[index];
    }
    return self.tabControl.config.menuViewTableViewSeparatorColor;
}

#pragma mark - Action
//多选的重置
- (void)retSetAction{
    [self.selectData removeSonSelectDataAllSelectModel];
    [self.selectData updateSeletedListDataSource:self.listDataSource orginSelectData:self.orginSelectData selectIndex:-1 flag:0];
    [self adjustTableViewsWithCount:[self.selectData getShowListViewCount]];
    [self reloadAllList];
    [self scrollAllTableIndex];
}

//多选的确认
- (void)ensureAction{
    if (self.tabControl.tabControlType == TabControlTypeMutiple){ ////数据回传 多选确定
        if (self.tabControl.didSelectedMenuAllData) {
            self.tabControl.didSelectedMenuAllData(self.tabControl, 1, self.selectData,nil);
        }
    }
    //确定选中，则更新数据源的select 状态
    if ([self.selectData getChoiceCount] == 1) { //如果只选中一项，情况重置为区域
        [self.selectData removeSonSelectDataAllSelectModel]; //清空所有选择
        ZQItemModel *firstModel = [self.selectData addFirstSelectedModelDataSource:self.listDataSource index:0]; //选中第一项
        [self.selectData resetSelectLastModelDataSource:firstModel.dataSource listViewIndex:0]; //重置后面
    }
    [self resetActionDisplayText:[self.selectData getActionDisplayText] showType:0];
    //更新所有数据
    [self.selectData updateSeletedListDataSource:self.listDataSource orginSelectData:nil selectIndex:-1 flag:0];
    [self dismiss];
    
}

//#pragma mark - Override Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    point.y += self.frame.origin.y;
    CALayer *layer = [self.layer hitTest:point];
    if (layer == self.layer) {
        [self dismiss];
    }
}

#pragma mark - UI
/** 懒加载 */
- (NSArray *)tableViewArr {
    if (_tableViewArr == nil) {
        
        _tableViewArr = @[[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain],
                          [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain],
                          [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain]];
        __weak __typeof(&*self)weakSelf = self;
        [_tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
            [tableView registerClass:[ZQTabMenuTableViewCell class] forCellReuseIdentifier:@"TabMenuCell"];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.separatorColor = [self fetchTableViewSeparatorColorWithIndex:idx];
            tableView.backgroundColor = [self fetchTableViewBgColorWithIndex:idx];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.tag = idx;
            tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
            [weakSelf.contentView addSubview:tableView];
            switch (idx) {
                case 0:
                    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                    break;
                case 1:case 2:
                    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                    break;
                default:
                    break;
            }
        }];
    }
    return _tableViewArr;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (ZQTabMenuEnsureView *)ensureView{
    if(!_ensureView){
        ZQWS(weakSelf);
        _ensureView = [[ZQTabMenuEnsureView alloc] initWithConfig:self.tabControl.config.ensureViewConfig];
        _ensureView.frame = CGRectMake(0, 0, ZQScreenWidth, 71);
        _ensureView.clickAction = ^(NSInteger tag) {
            if (tag == 1) { // 重置
                [weakSelf retSetAction];
            }else{ // 确定
                [weakSelf ensureAction];
            }
        };
    }
    return _ensureView;
}

#pragma mark - DealData
//刷新选中数据UI
- (void)reloadSeletedListDataSource{
    //初始化数据源
    self.selectData = [[ZQFliterSelectData alloc]init];
    self.listDataSource = self.tabControl.ListDataSource;
    self.selectData.fatherDataSource = self.listDataSource;
    [self.selectData reloadSeletedListDataSource:self.listDataSource selectIndex:-1];
    NSString *selectedTitle = [self.selectData getActionDisplayText];
    if (selectedTitle) { //設置title
        [self.tabControl setControlTitle:selectedTitle];
    }
    if (self.orginSelectData == nil && self.selectData) {
        self.orginSelectData = [self.selectData mutableCopy]; //记录第一次的数据
    }
    [self reloadAllList];
    [self scrollAllTableIndex];
}

//选中的数据处理
- (void)didSelectModel:(ZQItemModel *)selectModel
             selectRow:(NSInteger)selectRow
         listViewIndex:(NSInteger)listViewIndex{

    if (self.tabControl.tabControlType == TabControlTypeDefault) {
        if (self.tabControl.didSelectedMenuAllData) {
            self.tabControl.didSelectedMenuAllData(self.tabControl, 0, self.selectData,selectModel);
        }
        //更新数据
        [self.selectData updateSeletedListDataSource:self.listDataSource orginSelectData:nil selectIndex:-1 flag:0];
        NSInteger type = 0;
        if ([selectModel isShowUnlimited]) {//不限 展示父的title
            ZQItemModel *father = selectModel.fatherModel;
            if (father == nil) {
                type = 1;//展示title
            }else{
                selectModel = father;
            }
        }
        [self resetActionDisplayText:selectModel.displayText showType:type];
        [self dismiss];
    }
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dataSource = [self.selectData getListDataSource:self.listDataSource listViewIndex:tableView.tag];
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger listViewIndex = tableView.tag;
    ZQTabMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TabMenuCell"];
    NSArray<ZQItemModel *> *dataSource = [self.selectData getListDataSource:self.listDataSource listViewIndex:listViewIndex];
    ZQItemModel *model = dataSource[indexPath.row];
    model.indexPath = indexPath;//标记数据模型下标
    cell.config = self.tabControl.config;
    cell.model = model;
    ZQFliterSelectData *childSelectData = self.selectData.dict[@(listViewIndex)];
    cell.isChoice = [childSelectData isChoiceModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger listViewIndex = tableView.tag;
    NSArray *lastDataSource = nil; //子數據源
    NSInteger selectRow = indexPath.row;
    NSArray<ZQItemModel *> *dataSource = [self.selectData getListDataSource:self.listDataSource listViewIndex:listViewIndex];//获取当前列数据源
    ZQItemModel *selectModel = dataSource[selectRow];
    ZQFliterSelectData *childData = self.selectData.dict[@(listViewIndex)];//选中的数据对象
    if (selectModel.dataSource.count) {//如果有子数据
        lastDataSource = selectModel.dataSource;
    }
    //單選多選處理
    if (selectModel.selectMode == 0) { //单选移除当前所有的
        [childData removeAllSelectModelAndAddModel:selectModel row:selectRow];//移除所有数据,加入单选数据
        [self.selectData resetSelectLastModelDataSource:lastDataSource listViewIndex:listViewIndex];
    }else if(selectModel.selectMode == 1) { //复选 暂时没有子数据源
        ZQItemModel *firstModel = dataSource.firstObject;
        if ([firstModel isShowUnlimited]) { //不限
            [childData removeSelectModel:firstModel];
        }
        if (![childData isChoiceModel:selectModel]) {
            [childData addSelectModel:selectModel row:selectRow];
        }else{
            [childData removeSelectModel:selectModel];
            if (childData.hadSelectedCount == 0) { //已经没有选中的了
                if ([firstModel isShowUnlimited]) { //添加不限
                    [childData addSelectModel:firstModel row:firstModel.indexPath.row];
                }
            }
        }
    }
    if (lastDataSource == nil) {//没有子数据源才触发点击
        [self didSelectModel:selectModel selectRow:selectRow listViewIndex:listViewIndex];
    }
    [self showListViewCount:listViewIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tabControl.config.menuCellHeigth;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


@end
