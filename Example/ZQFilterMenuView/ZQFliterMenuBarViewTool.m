//
//  ZQFliterMenuBarViewTool.m
//  ZQFilterMenuView_Example
//
//  Created by zhengzeqin on 2020/6/28.
//  Copyright © 2020 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import "ZQFliterMenuBarViewTool.h"

@implementation ZQFliterMenuBarViewTool
+ (NSArray *)getSortArrayConfigKey:(NSString *)key{
    NSDictionary *dic = [self getConfigPlistKey:key];
    if (dic) {
        return [self getSortConfigDic:dic];
    }
    return [NSArray array];
}

+ (NSDictionary *)getChildArrDictionaryConfigDic:(NSDictionary *)dict{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    @autoreleasepool {
        if (dict) {
            NSArray *keys = [dict allKeys];
            for (NSString *key in keys) {
                if (key&&![key isKindOfClass:[NSNull class]]) {
                    NSDictionary *resultDic = [dict objectForKey:key];
                    if (resultDic) {
                        NSMutableArray *config = [[NSMutableArray alloc] init];
                        NSMutableArray *sortArr = [self configSort:resultDic];
                        for (int i = 0; i < sortArr.count; i++) {
                            [config addObject:[sortArr objectAtIndex:i]];
                        }
                        [dic setValue:config forKey:key];
                    }
                }
            }
        }
    }
    return dic;
}

+ (NSDictionary *)getConfigPlistKey:(NSString *)key{
    NSString *configPlist = [[NSBundle mainBundle] pathForResource:@"Configure" ofType:@"plist"];
    NSDictionary *configDic = [[NSDictionary alloc] initWithContentsOfFile:configPlist];
    NSDictionary *itemDic = [configDic valueForKey:key];
    return itemDic;
}

+ (NSMutableArray *)getSortConfigDic:(NSDictionary *)dict{
    NSMutableArray *config = [[NSMutableArray alloc] init];
    NSMutableArray *sortArr = [self configSort:dict];
    for (int i = 0; i < sortArr.count; i++) {
        [config addObject:[sortArr objectAtIndex:i]];
    }
    return config;
}

+ (NSMutableArray *)configSort:(NSDictionary *)configItems{
    NSMutableArray *backArr = [[NSMutableArray alloc] init];
    NSArray *sortArr = [configItems valueForKey:@"sort"];
    for (NSString *key in sortArr) {
        [backArr addObject:@[key,[configItems objectForKey:key]]];
    }
    return backArr;
}

+ (BOOL)string:(NSString *)string componentString:(NSString *)componentString isContainsStr:(NSString *)str{
    NSArray *arr = [string componentsSeparatedByString:componentString];
    return [self stringArray:arr isContainsStr:str];
}

//字符串是否存在数组中
+ (BOOL)stringArray:(NSArray<NSString*> *)arr isContainsStr:(NSString *)str{
    if ([arr containsObject:str]) {
        return YES;
    }
    return NO;
}
@end
