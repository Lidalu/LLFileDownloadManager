/*! 头文件基本信息。这个用在每个源代码文件的头文件的最开头

@header LLuDownloadManager.h

@abstract 关于这个源代码文件的一些基本描述

@author Created by Lilu on 16/5/3

@version 1.00 16/5/3 Creation(此文档的版本信息)

//  Copyright © 2016年 lu. All rights reserved.

*/

#import <Foundation/Foundation.h>
#import "LLuFileDownloader.h"

@interface LLuDownloadManager : NSObject <LLuFileDownloaderDelegate>

+ (instancetype)sharedDownloadManager;

-(NSInteger)currentOperationCount;

-(void)downloadURLStr:(NSString *)urlStr withTag:(NSString *)tag withDelegate:(id<LLuFileDownloaderDelegate>)delegate;

-(void)stopDownloadOperationWithTag:(NSString *)tag;

-(void)removeDownloadOperationWithTag:(NSString *)tag;

@end
