//
//  ZQFliterModelHeader.h
//  house591
//
//  Created by zhengzeqin on 2020/5/20.
//

#ifndef ZQFliterModelHeader_h
#define ZQFliterModelHeader_h

#define ZQLuckyMutableCopyImplementation \
- (id)mutableCopyWithZone:(NSZone *)zone{ \
id object = [[[self class] allocWithZone:zone] init]; \
 \
unsigned int count = 0; \
Ivar *ivars = class_copyIvarList([self class], &count); \
for (int i = 0; i < count; i++) { \
    Ivar ivar = ivars[i]; \
    const char *name = ivar_getName(ivar); \
    NSString *key = [NSString stringWithUTF8String:name]; \
    id value = [self valueForKey:key]; \
    [object setValue:value forKey:key]; \
} \
 \
return object; \
} \

//检查是否为空对象
#define ZQCHECK_NULL(object) ([object isKindOfClass:[NSNull class]]?nil:object)
//空对象 赋予空字符串
#define ZQNullClass(object) (ZQCHECK_NULL(object)?object:@"")

#define ZQScreenWidth                      [[UIScreen mainScreen] bounds].size.width
#define ZQScreenHeight                     [[UIScreen mainScreen] bounds].size.height
//防止block循環引用
#define ZQWS(weakSelf) __weak __typeof(&*self)weakSelf = self

#endif /* ZQFliterModelHeader_h */
