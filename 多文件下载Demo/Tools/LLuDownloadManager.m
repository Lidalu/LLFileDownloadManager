//
//  LLuDownloadManager.m
//  多文件下载Demo
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "LLuDownloadManager.h"

@interface LLuDownloadManager () <NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSOperationQueue *downloadQueue;
//所有列队中的线程
@property (nonatomic, strong) NSMutableDictionary *operationDictionary;
//所有失败和暂停的任务线程中已经下载到的数据量，用于断点续传
@property (nonatomic, strong) NSMutableDictionary *receviedBytesArray;

@end

@implementation LLuDownloadManager

#pragma mark - setter and getter 

- (id)init
{
    self = [super init];
    
    if (self) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        [_downloadQueue setMaxConcurrentOperationCount:2];
        
        _operationDictionary=[[NSMutableDictionary alloc]init];
        _receviedBytesArray=[[NSMutableDictionary alloc]init];
    }
    return self;
}

+ (instancetype)sharedDownloadManager {
    static dispatch_once_t onceToken;
    static id sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}


-(NSInteger)currentOperationCount
{
    return [_downloadQueue operationCount];
}

//开始一个下载任务，是否为断点续传根据已经接收到的数据length。  0是新的下载，否则是一个断点续传
-(void)downloadURLStr:(NSString *)urlStr withTag:(NSString *)tag withDelegate:(id<LLuFileDownloaderDelegate>)delegate
{
    
    LLuFileDownloader *fileDownloader=[[LLuFileDownloader alloc]initWidthURLStr:urlStr];
    fileDownloader.delegate=delegate;
    fileDownloader.tag=tag;
    
    uint64_t receivedLength=0.0;
    if ([_receviedBytesArray valueForKey:tag]!=nil) {
        receivedLength=[[_receviedBytesArray valueForKey:tag] longLongValue];
    }
    
    fileDownloader.receivedDataLength=receivedLength;
    
    
    [_operationDictionary setObject:fileDownloader forKey:tag];
    
    [_downloadQueue addOperation:fileDownloader];
}


//停止某一个正在执行的下载进程
-(void)stopDownloadOperationWithTag:(NSString *)tag
{
    LLuFileDownloader *fileDownloader=(LLuFileDownloader *)[_operationDictionary objectForKey:tag];
    [_receviedBytesArray setValue:[NSNumber numberWithLongLong:fileDownloader.receivedDataLength] forKey:tag];
    [fileDownloader cancelOperation];
    
    
}

//下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    
    NSString * cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    NSFileManager * mgr = [NSFileManager defaultManager];
    
    [mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:cachesPath] error:NULL];
    
}


//删除某个已经正确下载完毕的进程
-(void)removeDownloadOperationWithTag:(NSString *)tag
{
    [_operationDictionary removeObjectForKey:tag];
    
    NSLog(@"未完成的下载任务数:%lu",(unsigned long)[_operationDictionary count]);
    
    int taskNum=(int)[_downloadQueue operationCount]-1;
    
    NSLog(@"列队中的下载任务数1:%i",taskNum);
}


@end
