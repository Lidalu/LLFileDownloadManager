//
//  LLuDownloadTableViewCell.h
//  多文件下载Demo
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 lu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    LLuDownloadStatusNone,
    LLuDownloadStatusWaiting,
    LLuDownloadStatusPause,
    LLuDownloadStatusLoading,
    LLuDownloadStatusComplete,
    LLuDownloadStatusError
} LLuDownloadStatus;

@interface LLuDownloadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *vodieName;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ramLanel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;

@property(nonatomic, assign) LLuDownloadStatus downloadStatus;

-(void)setDownloadProgress:(float)progress WithStatus:(LLuDownloadStatus)downloadStatus;

@end
