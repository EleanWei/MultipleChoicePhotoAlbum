//
//  ELNPickerViewController.m
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import "ELNPickerViewController.h"

#import "ELNPickerCell.h"
//显示图片的cell

#import "ELNALAsset.h"

@interface ELNPickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
//显示图片

@property (nonatomic,strong) NSMutableArray    *dataSource;
//数据源

@property (nonatomic,strong) ALAssetsLibrary   *assetsLibrary;
//相册读取对象

@property (nonatomic,strong) ALAssetsGroup     *assetsGroup;
//接收上个界面选中的相册

@property (nonatomic,strong) NSMutableArray *selectedAssetsGroup;
//选中的图片




@end

@implementation ELNPickerViewController

#pragma mark -- 自定义构造方法
- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    self = [super init];
    if (self) {
        
        //接收上个界面选择的相册
        _assetsGroup = assetsGroup;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //创建collectionView
    [self createCollectionView];
    
    //创建navigationItem左右button
    [self createNavigationBarButton];
    
    //加载数据
    [self loadData];
    

    
}

- (void)createNavigationBarButton{

    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(succeeded)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

#pragma mark -- 创建collectionView
- (void)createCollectionView{

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 10)/4.0, (CGRectGetWidth([UIScreen mainScreen].bounds) - 10)/4.0);
    
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 3;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds) , CGRectGetHeight([UIScreen mainScreen].bounds) - 64) collectionViewLayout:flowLayout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.allowsMultipleSelection = YES;
    //设置支持复选
    
    [_collectionView registerClass:[ELNPickerCell class] forCellWithReuseIdentifier:@"ELNPickerCell"];
    
    
    [self.view addSubview:_collectionView];
    
    
    
}

#pragma mark -- 加载相册图片
- (void)loadData{

    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    
    if(!_selectedAssetsGroup){
    
        _selectedAssetsGroup = [NSMutableArray array];
    }
    
    [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            
           
            ELNALAsset *asset = [[ELNALAsset alloc]init];
            asset.asset = result;
            asset.isSelected = NO;
            
            [_dataSource addObject:asset];
            
        }
    }];
    
    [_collectionView reloadData];

}

#pragma mark -- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

   
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    ELNPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ELNPickerCell" forIndexPath:indexPath];
    
    [cell reloadCellWithALAsset:_dataSource[indexPath.row]];
    
    
    return cell;

    
    
}
#pragma mark -- collectionView delegate
//选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    //调用方法修改cell的选中状态
    [self changeCellWithIndexPath:indexPath];

    
    
}
//替选
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

     //调用方法修改cell的选中状态
    [self changeCellWithIndexPath:indexPath];
    
    
}

#pragma mark -- 修改cell的状态
- (void)changeCellWithIndexPath:(NSIndexPath *)indexPath{
    //1.通过indexPath获取到数据源中的模型对象，修改对象中修改状态
    ELNALAsset *asset = _dataSource[indexPath.row];
    asset.isSelected ^= 1;
    
    [_dataSource replaceObjectAtIndex:indexPath.row withObject:asset];
    
    //2.将数据模型添加或者移除
    
    //如果选中 将数据模型加入选中的数组
    if (asset.isSelected) {
        
        [self.selectedAssetsGroup addObject:asset];
        
    }else{
        
    //如果取消选中 将数据模型从选中数组中移除
        [self.selectedAssetsGroup removeObject:asset];
    }
    
    
    
   //3，修改cell上显示的选中图片的显示状态
    ELNPickerCell *cell = (ELNPickerCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    [cell changeSelectedWithALAsset:asset];

}


#pragma mark -- navigationItem barButton 
- (void)back{

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)succeeded{

    //发送通知到主界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedPhoto" object:nil userInfo:@{@"Assets":self.selectedAssetsGroup}];
    
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
