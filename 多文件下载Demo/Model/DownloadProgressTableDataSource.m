//
//  DownloadProgressTableDataSource.m
//  多文件下载Demo
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "DownloadProgressTableDataSource.h"
#import "LLuDownloadTableViewCell.h"
#import "LLuDownloadModel.h"

static NSString *CellIdentifier = @"";

@implementation DownloadProgressTableDataSource

+ (void)setInstanceCellIdentifier:(NSString *)cellIdentifier
{
    CellIdentifier = cellIdentifier;
}

- (void)setDataList:(NSArray *)dataList {
    
    _dataList = dataList;
    for (NSInteger i = 0; i < self.dataList.count; i++) {
        [_progressArray addObject:[NSNumber numberWithFloat:0.0]];
        [_statusArray addObject:[NSNumber numberWithInt:LLuDownloadStatusWaiting]];
    }
}

#pragma mark - UITableViewDataSource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLuDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    LLuDownloadModel *downLoadModel = self.dataList[indexPath.row];
    cell.vodieName.text = downLoadModel.title;
    
    cell.tag = indexPath.row;
    float progressValue = [[self.progressArray objectAtIndex:indexPath.row] floatValue];
    int downloadStauts = [[self.statusArray objectAtIndex:indexPath.row] intValue];
    [cell setDownloadProgress:progressValue WithStatus:downloadStauts];
    
    return cell;
}

@end
