//
//  SeperateLine.m
//  house591
//
//  Created by addcn on 2018/6/28.
//  
//

#import "ZQSeperateLine.h"

#import "UIColor+Util.h"

@implementation ZQSeperateLine

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
        [self setBounds:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 0.5)];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //ios6需要延迟加载
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.2];
    }
    return self;
}

- (void)reset{
    [self setBackgroundColor:[UIColor colorWithHexString:@"dadada"]];
    [self setBounds:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 0.5)];
}


@end
