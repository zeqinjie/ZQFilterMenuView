//
//  ZQFliterMenuBarViewTool.h
//  ZQFilterMenuView_Example
//
//  Created by zhengzeqin on 2020/6/28.
//  Copyright © 2020 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQFliterMenuBarViewTool : NSObject
+ (NSArray *)getSortArrayConfigKey:(NSString *)key;
+ (NSDictionary *)getChildArrDictionaryConfigDic:(NSDictionary *)dict;
+ (NSDictionary *)getConfigPlistKey:(NSString *)key;
+ (BOOL)string:(NSString *)string componentString:(NSString *)componentString isContainsStr:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
