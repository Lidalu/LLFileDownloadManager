//
//  ViewController.m
//  多文件下载Demo
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 lu. All rights reserved.
//

#import "ViewController.h"
#import "LLuDownloadTableViewCell.h"
#import "LLuDownloadModel.h"
#import "DownloadProgressTableDataSource.h"
#import "UIBarButtonItem+FastCreateItem.h"

static NSString *CellIdentifier = @"Cell";

@interface ViewController () <UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) DownloadProgressTableDataSource *dpTableDS;

@property (nonatomic, strong) UIBarButtonItem *deleteBtn;

@property (nonatomic, strong) UIBarButtonItem *editBtn;

@property (nonatomic, strong) NSMutableArray *selectedList;

@end

@implementation ViewController

#pragma -mark setter and getter 

- (NSArray *)dataList {
    
    if (!_dataList) {
        
        _dataList = [NSMutableArray arrayWithArray:[LLuDownloadModel downLoadsList]];
    }
    return _dataList;
}

- (NSMutableArray *)selectedList {
    
    if (!_selectedList) {
        
        _selectedList = [NSMutableArray array];
    }
    return _selectedList;
}

- (UIBarButtonItem *)deleteBtn {
    
    if (!_deleteBtn) {
        
        _deleteBtn = [UIBarButtonItem createBarButtonItemWithImageName:@"shanchu" target:self action:@selector(deleteClickAction:)];
        _deleteBtn.enabled = NO;
    }
    return _deleteBtn;
}

- (UIBarButtonItem *)editBtn {
    
    if (!_editBtn) {
        
        _editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editClickAction:)];
    }
    return _editBtn;
}

- (void)initUI {
    
    self.title = @"多文件下载Demo";
    self.navigationItem.leftBarButtonItems = @[self.deleteBtn, [UIBarButtonItem createBarButtonItemWithImageName:@"一键暂停" target:self action:@selector(pauseClickAction:)]];
    self.navigationItem.rightBarButtonItems = @[self.editBtn, [UIBarButtonItem createBarButtonItemWithImageName:@"一键下载" target:self action:@selector(downLoadClickAction:)]];

    
    self.dpTableDS = [[DownloadProgressTableDataSource alloc] init];
    self.dpTableDS.dataList = self.dataList;
    self.tableView.dataSource = self.dpTableDS;
    
    [DownloadProgressTableDataSource setInstanceCellIdentifier:CellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LLuDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.tableView.rowHeight = 80;
}

#pragma mark - Click Method

- (void)deleteClickAction:(id )sender {
    
    NSLog(@"1=====%@", self.selectedList);

    [self pauseWithSelectedList:self.selectedList];
    //得到所有选中的行数
    NSArray *againSelectList = [self.tableView indexPathsForSelectedRows];
    
        //创建删除对象的数组
    NSMutableArray * deleteObjcList = [NSMutableArray array];
        
    for (NSInteger i = 0; i < againSelectList.count; i ++) {
        
        NSIndexPath * index = againSelectList[i];
        NSLog(@"delete===%ld", (long)index.row);
        //根据选中行数得到相应数组
        NSString * string = self.dataList[index.row];
        
        [deleteObjcList addObject:string];
        
    }
    NSLog(@"2====%@", self.selectedList);
    //在数据源里删除所有选中的元素
    [self.dataList removeObjectsInArray:deleteObjcList];
    NSLog(@"3====%@", self.selectedList);
    [self.selectedList removeObjectsInArray:againSelectList];
    NSLog(@"4====%@", self.selectedList);
    [self downLoadWithSelectedList:self.selectedList];
    //批量删除动画
    [self.tableView deleteRowsAtIndexPaths:againSelectList withRowAnimation:UITableViewRowAnimationFade];
    //刷新tableview
    [self.tableView reloadData];
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    self.editBtn.title = self.tableView.editing ? @"完成" : @"编辑" ;
}

- (void)pauseClickAction:(id )sender {
    
    
    [self pauseWithSelectedList:self.selectedList];
//    self.editBtn.title = self.tableView.editing ? @"完成" : @"编辑" ;
}

- (void)editClickAction:(id )sender {
    
    //将tableView转换为可编辑状态
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    UIBarButtonItem * item = sender;
    item.title = self.tableView.editing ? @"完成" : @"编辑" ;
    self.deleteBtn.enabled = self.tableView.editing;
}

- (void)downLoadClickAction:(UIButton *)sender {
    
    //得到所有选中的行数
    self.selectedList = [NSMutableArray arrayWithArray:[self.tableView indexPathsForSelectedRows]];
    [self downLoadWithSelectedList:self.selectedList];
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    self.editBtn.title = self.tableView.editing ? @"完成" : @"编辑" ;

}

- (void)pauseWithSelectedList: (NSMutableArray *)selectedList {
    
    for (NSInteger i = 0; i < selectedList.count; i ++) {
        
        NSIndexPath * index = selectedList[i];
        NSLog(@"%ld", (long)index.row);
        NSString *tempTag = [NSString stringWithFormat:@"%li", (long)index.row];
        [[LLuDownloadManager sharedDownloadManager] stopDownloadOperationWithTag:tempTag];
    }
}

- (void)downLoadWithSelectedList:(NSMutableArray *)selectedList {
    
    for (NSInteger i = 0; i < selectedList.count; i ++) {
        
        NSIndexPath * index = selectedList[i];
        NSLog(@"download===%ld", (long)index.row);
        //根据选中行数得到相应的model
        LLuDownloadModel *model = self.dataList[index.row];
        
        if ([[_dpTableDS.statusArray objectAtIndex:index.row] intValue] == LLuDownloadStatusNone) {
            
            LLuDownloadTableViewCell *cell = (LLuDownloadTableViewCell *)[self.tableView cellForRowAtIndexPath:index];
            float progress= [[_dpTableDS.progressArray objectAtIndex:index.row]floatValue];
            [cell setDownloadProgress:progress WithStatus:LLuDownloadStatusWaiting];
        }
        
        NSString *tempTag = [NSString stringWithFormat:@"%li", (long)index.row];
        [[LLuDownloadManager sharedDownloadManager] downloadURLStr:model.url withTag:tempTag withDelegate:self];
    }
}

#pragma mark - life ctyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(9, 1, 1));

    [self initUI];
}

//设置单个cell的下载进度和状态
-(void)setCellWithTag:(NSInteger)tagvalue WithStatus:(LLuDownloadStatus)downloadStatus WithDownloadProgress:(float)progress
{
    NSInteger tempTag = tagvalue;
    
    //设置对应的cell的下载进度
    [self.dpTableDS.progressArray replaceObjectAtIndex:tempTag withObject:[NSNumber numberWithFloat:progress]];
    [self.dpTableDS.statusArray replaceObjectAtIndex:tempTag withObject:[NSNumber numberWithInt:downloadStatus]];
    
    //如果对应的cell在可视区域，刷新它
    for(LLuDownloadTableViewCell *cell in [self.tableView visibleCells])
    {
        if (cell.tag == tempTag) {
            [cell setDownloadProgress:progress WithStatus:downloadStatus];
            break;
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //多选
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}

//设置单个cell的状态
-(void)setCellWithTag:(NSInteger)tagvalue WithStatus:(LLuDownloadStatus)downloadStatus
{
    NSInteger tempTag = tagvalue;
    
    //设置对应的cell的下载进度
    float progress = [[_dpTableDS.progressArray objectAtIndex:tempTag] floatValue];
    [_dpTableDS.statusArray replaceObjectAtIndex:tempTag withObject:[NSNumber numberWithInt:downloadStatus]];

    for(LLuDownloadTableViewCell *cell in [self.tableView visibleCells])
    {
        if (cell.tag == tempTag) {
            [cell setDownloadProgress:progress WithStatus:downloadStatus];
            break;
        }
    }
}


#pragma --mark LLuileDownloaderDelegate

-(void)LLuFileDownloader:(LLuFileDownloader *)fileDownloader loadWithProgress:(float)progress
{
    
    [self setCellWithTag:[fileDownloader.tag intValue] WithStatus:LLuDownloadStatusLoading WithDownloadProgress:progress];
}

-(void)LLuFileDownloader:(LLuFileDownloader *)fileDownloader loadFailWithError:(NSError *)error
{
    [self setCellWithTag:[fileDownloader.tag intValue] WithStatus:LLuDownloadStatusError];
    
}

-(void)LLuFileDownloaderLoadComplete:(LLuFileDownloader *)fileDownloader
{
    [self setCellWithTag:[fileDownloader.tag intValue] WithStatus:LLuDownloadStatusComplete];
    
    [[LLuDownloadManager sharedDownloadManager]removeDownloadOperationWithTag:fileDownloader.tag];
    
}

-(void)LLuFileDownloaderPaused:(LLuFileDownloader *)fileDownloader
{
    [self setCellWithTag:[fileDownloader.tag intValue] WithStatus:LLuDownloadStatusPause];
}


#pragma --mark UITableviewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if ([[_dpTableDS.statusArray objectAtIndex:indexPath.row] intValue] == LLuDownloadStatusLoading || [[_dpTableDS.statusArray objectAtIndex:indexPath.row] intValue] == LLuDownloadStatusWaiting) {
        
        NSString *tempTag=[@"" stringByAppendingFormat:@"%li",(long)indexPath.row];
        [[LLuDownloadManager sharedDownloadManager] stopDownloadOperationWithTag:tempTag];
        
    }else if([[_dpTableDS.statusArray objectAtIndex:indexPath.row] intValue] == LLuDownloadStatusPause || [[_dpTableDS.statusArray objectAtIndex:indexPath.row] intValue] == LLuDownloadStatusError)
    { 
        LLuDownloadModel *model = self.dataList[indexPath.row];
        NSString *tempTag=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [[LLuDownloadManager sharedDownloadManager] downloadURLStr:model.url withTag:tempTag withDelegate:self];
        
        
        [_dpTableDS.statusArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:LLuDownloadStatusWaiting]];
        LLuDownloadTableViewCell *cell=(LLuDownloadTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        float progress= [[_dpTableDS.progressArray objectAtIndex:indexPath.row]floatValue];
        [cell setDownloadProgress:progress WithStatus:LLuDownloadStatusWaiting];
    }
}

@end