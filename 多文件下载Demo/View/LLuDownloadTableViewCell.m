//
//  LLuDownloadTableViewCell.m
//  多文件下载Demo
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "LLuDownloadTableViewCell.h"

@implementation LLuDownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDownloadProgress:(float)progress WithStatus:(LLuDownloadStatus)downloadStatus
{
    _downloadStatus = downloadStatus;
    if (_downloadStatus == LLuDownloadStatusNone) {
        
        self.statusLabel.text = @"未下载";
        self.statusImg.image = [[UIImage alloc] init];
        self.progressV.hidden = YES;
        
    }  else if (_downloadStatus == LLuDownloadStatusPause) {
        
        self.statusLabel.text = @"下载暂停";
        self.statusImg.image = [UIImage imageNamed:@"zanting"];
        
    }  else if(_downloadStatus == LLuDownloadStatusWaiting) {
        
        self.statusLabel.text = @"等待中";
        self.statusImg.image = [UIImage imageNamed:@"dengdai"];
        
    }  else if(_downloadStatus == LLuDownloadStatusError) {
        
        self.statusLabel.text = @"下载失败";
        self.statusImg.image = [UIImage imageNamed:@"iconfont-xiazai"];
        
    }   else if(_downloadStatus == LLuDownloadStatusComplete) {
        
        self.statusLabel.text = @"下载完成";
        self.statusImg.image = [UIImage imageNamed:@"iconfont-xiazai"];
        
    }   else if(_downloadStatus == LLuDownloadStatusLoading) {
        
        self.statusLabel.text = @"正在下载";
        self.statusImg.image = [UIImage imageNamed:@"xiazaizhong"];
        //进度条label
        self.ramLanel.text = [@"" stringByAppendingFormat:@"%.2f%@",progress,@"%"];
        
    }
    //进度条
    self.progressV.progress = progress / 100;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
