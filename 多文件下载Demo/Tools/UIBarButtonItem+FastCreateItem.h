//
//  UIBarButtonItem+FastCreateItem.h
//  多文件下载Demo
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (FastCreateItem)

+ (UIBarButtonItem *)createBarButtonItemWithImageName:(NSString *)imgName target:(id)target action:(SEL)action;

@end
