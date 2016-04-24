//
//  CollectionViewCell.m
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell()

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)reloadCellWithALAsset:(ALAsset *)asset{

    
    _imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    
}
- (void)reloadCellWithImage:(UIImage *)image{

    _imageView.image = image;
}


@end





