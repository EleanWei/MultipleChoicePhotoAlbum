//
//  ELNPickerCell.m
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import "ELNPickerCell.h"
@interface ELNPickerCell()
@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UIImageView *selectedImage;

@property (nonatomic,strong)ELNALAsset *asset;

@property (nonatomic,assign) BOOL isSelected;



@end

@implementation ELNPickerCell

#pragma mark -- 重写构造方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        
        [self.contentView addSubview:_imageView];
        
      
        _selectedImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 25, frame.size.height - 25, 20, 20)];
       
        _selectedImage.image = [UIImage imageNamed:@"selected.png"];
        
        _selectedImage.hidden = YES;
        
        [self.contentView addSubview:_selectedImage];
        
        _isSelected = NO;
        
        
        
    }
    return self;
}

#pragma mark -- 刷新cell
- (void)reloadCellWithALAsset:(ELNALAsset *)asset{
    
        _asset = asset;
    
    _imageView.image = [UIImage imageWithCGImage:[self.asset.asset thumbnail]];
    
    _selectedImage.hidden = !asset.isSelected;
    

}

#pragma mark -- 设置选中/非选中
- (void)changeSelectedWithALAsset:(ELNALAsset *)asset{

   _selectedImage.hidden = !asset.isSelected;
    
}





@end






