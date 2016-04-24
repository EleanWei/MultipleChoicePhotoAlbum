//
//  ELNPickerCell.h
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELNALAsset.h"
@protocol ELNPickerCellDelegate<NSObject>



@end

@interface ELNPickerCell : UICollectionViewCell


- (void)reloadCellWithALAsset:(ELNALAsset *)asset;

- (void)changeSelectedWithALAsset:(ELNALAsset *)asset;

@end







