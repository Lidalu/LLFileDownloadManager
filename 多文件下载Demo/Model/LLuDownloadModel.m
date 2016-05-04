//
//  LLuDownloadModel.m
//  视频一键下载Demo
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "LLuDownloadModel.h"

@implementation LLuDownloadModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)downLoadWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)downLoadsList {
    
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"downLoad" ofType:@"plist"];
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        
        LLuDownloadModel *downLoad = [LLuDownloadModel downLoadWithDict:dict];
        [tmpArray addObject:downLoad];
    }
    return tmpArray;
}

@end
