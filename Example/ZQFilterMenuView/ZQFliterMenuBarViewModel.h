//
//  ZQFliterMenuBarViewModel.h
//  ZQFilterMenuView_Example
//
//  Created by 郑泽钦 on 2020/6/27.
//  Copyright © 2020 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZQFilterMenuView/ZQItemModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZQFliterMenuBarViewModel : NSObject
@property (strong, nonatomic) NSArray<ZQItemModel *> *locationDataSource;
@property (strong, nonatomic) NSArray<ZQItemModel *> *typeDataSource;
@property (strong, nonatomic) NSArray<ZQItemModel *> *priceDataSource;
@property (strong, nonatomic) NSArray<ZQItemModel *> *moreDataSource;
- (void)configureData;
@end

NS_ASSUME_NONNULL_END
