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
        [self setBackgroundColor:[UIColor colorWithHexString:@"cccccc"]];
        [self setBounds:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 0.5)];
    }
    return self;
}


@end
