//
//  CollectionViewCell.h
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface CollectionViewCell : UICollectionViewCell

//相册资源
- (void)reloadCellWithALAsset:(ALAsset *)asset;
//相机资源
- (void)reloadCellWithImage:(UIImage *)image;

@end
