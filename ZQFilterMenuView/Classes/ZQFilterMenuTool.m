//
//  ZQFilterMenuTool.m
//  Masonry
//
//  Created by zhengzeqin on 2020/6/9.
//

#import "ZQFilterMenuTool.h"

@implementation NSBundle (ZQFilterMenuTool)
+ (instancetype)ZQFilterMenuToolBundle {
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        NSBundle *bundle = [NSBundle bundleForClass:[ZQFilterMenuTool class]];
        refreshBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"ZQFilterMenuView" ofType:@"bundle"]];
    }
    return refreshBundle;
}

@end

@implementation ZQFilterMenuTool

+ (UIImage *)imageNamed:(NSString *)imageName {
    NSBundle *bundle = [NSBundle ZQFilterMenuToolBundle];
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:@"png"];
    UIImage *image = [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
