//
//  UIBarButtonItem+FastCreateItem.m
//  多文件下载Demo
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "UIBarButtonItem+FastCreateItem.h"

@implementation UIBarButtonItem (FastCreateItem)

+ (UIBarButtonItem *)createBarButtonItemWithImageName:(NSString *)imgName target:(id)target action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imgName] forState:(UIControlStateNormal)];
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    btn.adjustsImageWhenHighlighted = NO;
    [btn sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
