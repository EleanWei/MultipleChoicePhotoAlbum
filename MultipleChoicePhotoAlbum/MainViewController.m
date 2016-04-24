//
//  MainViewController.m
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright (c) 2016年 Elean. All rights reserved.
//

#import "MainViewController.h"
#import "ELNPhotoAlbumController.h"
#import "ELNALAsset.h"
#import "CollectionViewCell.h"

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)BOOL isCamera;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"多选相册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isCamera = NO;
    
    //创建左右barButton
    [self createNavigationItemBarButton];

    //注册通知
    [self registerNotification];
    
    //创建collectionView
    [self createCollectionView];
    
    
    
    

}

#pragma mark -- 创建左右button
- (void)createNavigationItemBarButton{


    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"相机" style:UIBarButtonItemStylePlain target:self action:@selector(gotoCamera)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoPhotoAlbum)];
    
    self.navigationItem.rightBarButtonItem = rightItme;
    

    
    
}
#pragma mark -- 注册通知
- (void)registerNotification{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedPhotoNotification:) name:@"SelectedPhoto" object:nil];
}
#pragma mark -- 创建collectionView
- (void)createCollectionView{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 10)/4.0, (CGRectGetWidth([UIScreen mainScreen].bounds) - 10)/4.0);
    
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 3;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) collectionViewLayout:flowLayout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];

    [self.view addSubview:_collectionView];
    
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
}

#pragma mark -- 通知方法
- (void)selectedPhotoNotification:(NSNotification *)noti{
    
    //获取选中的图片
   
    _isCamera = NO;
    
    [_dataSource removeAllObjects];
    
    [_dataSource addObjectsFromArray:noti.userInfo[@"Assets"]];
    
    [_collectionView reloadData];

    
}

#pragma mark -- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"CollectionViewCell";
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (_isCamera) {
        
        
        [cell reloadCellWithImage:_dataSource[indexPath.row]];
        
    }else{
    

    ELNALAsset *asset = _dataSource[indexPath.row];
    [cell reloadCellWithALAsset:asset.asset];
    
    }
    return cell;
    
    
}

#pragma mark -- 进入相机
- (void)gotoCamera{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark --  进入自定义相册
- (void)gotoPhotoAlbum{
    
    //点击进入相册控制器 实现多选
    
    ELNPhotoAlbumController *photoAlbum = [[ELNPhotoAlbumController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:photoAlbum];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
#pragma mark -- 选择图片
//取消相机调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    _isCamera = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//使用照片
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _isCamera = YES;
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    
    [_dataSource removeAllObjects];
    
    [_dataSource addObject:image];
    
    [_collectionView reloadData];
    
    
 //写入本地相册
    [self savedPhotosAlbumWithImage:image];
    
}

#pragma mark -- 图库保存图片
- (void)savedPhotosAlbumWithImage:(UIImage *)image{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    
    UIGraphicsBeginImageContext(imageView.bounds.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(temp, nil, nil, nil);
    
}

#pragma mark -- 重写析构方法
- (void)dealloc{

    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
