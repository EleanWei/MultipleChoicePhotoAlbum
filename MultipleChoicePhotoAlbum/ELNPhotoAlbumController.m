//
//  ELNPhotoAlbumController.m
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import "ELNPhotoAlbumController.h"

#import "ELNPickerViewController.h"
//显示相册详情界面

#import <AssetsLibrary/AssetsLibrary.h>
//图片资源访问支持框架

#import "ELNAlertTool.h"
//自定义自动消失提示框


@interface ELNPhotoAlbumController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
//展示相册

@property (nonatomic,strong)NSMutableArray *dataSource;
//tableView数据源

@property (nonatomic,strong)ALAssetsLibrary *assetsLibrary;
//该类的对象用于本地相册的读取

@end

@implementation ELNPhotoAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建左button
    [self createNavigationBarButton];
    
    
    //创建tableView
    [self createTableView];
    
    //获取数据
    [self getDataSource];
    
    
}
#pragma mark -- 创建navigationBarButton
- (void)createNavigationBarButton{

    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
}


#pragma mark -- 创建tableView
- (void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 64) style:UITableViewStylePlain];
    
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    
    
    
    [self.view addSubview:_tableView];
    
    
}

#pragma mark -- 获取本地相册

- (void)getDataSource{

    //1.数据源数据初始化
    if(!_dataSource){
    
        _dataSource = [NSMutableArray array];
    }
    //2.图片访问类对象初始化
    if (!_assetsLibrary) {
        
        _assetsLibrary = [[ALAssetsLibrary alloc]init];
        
    }
    //3.相册获取
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            //如果获取的相册不为空
            if (group) {
                
                 //添加数据
                [self.dataSource addObject:group];
               
                //主线程刷新UI
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                
            }
            
            
        } failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
           
            //提示错误
            [ELNAlertTool showAlertWithController:self andTitle:@"相册访问失败" andMessage:error.localizedDescription afterDelay:2.0];
            
            
        }];
    });

    
    
    
    
    

}

#pragma mark -- 刷新tableView
- (void)reloadTableView{

    [self.tableView reloadData];
    
    self.title = @"选择相册";
    
}


#pragma mark -- tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSource.count;
}

#pragma mark -- cell的展示

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"AlbumGroupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //获取相册图片数
    ALAssetsGroup *group = (ALAssetsGroup*)[self.dataSource objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger groupCount = [group numberOfAssets];

    
    //相册来源
    NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
    if ([groupName isEqualToString:@"Camera Roll"]) {
        groupName = @"相机胶卷";
    } else if ([groupName isEqualToString:@"My Photo Stream"]) {
        groupName = @"我的照片流";
    }
    
    
    
     cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",groupName, groupCount];
    //显示图片张数
    
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.dataSource objectAtIndex:indexPath.row] posterImage]]];
    //显示第一张图片
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //显示cell右侧小箭头

    return cell;
    
    
}

#pragma mark -- tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  //点击cell 进入对应的相册 选择照片
    
    ALAssetsGroup *assetsGroup = (ALAssetsGroup *)[_dataSource objectAtIndex:indexPath.row];
    
    ELNPickerViewController *pickerView = [[ELNPickerViewController alloc]initWithAssetsGroup:assetsGroup];
    
    [self.navigationController pushViewController:pickerView animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}

#pragma mark -- 取消
- (void)cancel{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
