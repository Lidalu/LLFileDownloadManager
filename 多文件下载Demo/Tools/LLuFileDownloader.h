/*! 头文件基本信息。这个用在每个源代码文件的头文件的最开头

@header LLuFileDownloader.h

@abstract 关于这个源代码文件的一些基本描述

@author Created by Lilu on 16/5/3

@version 1.00 16/5/3 Creation(此文档的版本信息)

//  Copyright © 2016年 lu. All rights reserved.

*/

#import <Foundation/Foundation.h>


@protocol LLuFileDownloaderDelegate;
//LLuFileDownloader类
@interface LLuFileDownloader : NSOperation<NSURLConnectionDelegate>

//下载进程的标示符
@property(nonatomic,strong)NSString *tag;

//本次应该下载的数据的大小
@property(nonatomic,assign)uint64_t expectedDataLength;
//当前已经下载的数据的大小
@property(nonatomic,assign)uint64_t receivedDataLength;

@property(nonatomic,weak)id<LLuFileDownloaderDelegate> delegate;

//使用下载地址字符串初始化LLuFileDownloader
-(id)initWidthURLStr:(NSString *)urlstr;

//开始下载
-(void)startDownload;

-(void)cancelOperation;

@end

//LLuFileDownloader的委托
@protocol LLuFileDownloaderDelegate <NSObject>

@optional

//下载失败的委托
-(void)LLuFileDownloader:(LLuFileDownloader *)fileDownloader loadFailWithError:(NSError *)error;

//下载进度的委托
-(void)LLuFileDownloader:(LLuFileDownloader *)fileDownloader loadWithProgress:(float)progress;

//下载成功的委托
-(void)LLuFileDownloaderLoadComplete:(LLuFileDownloader *)fileDownloader;

//暂停的下载任务委托
-(void)LLuFileDownloaderPaused:(LLuFileDownloader *)fileDownloader;

@end
