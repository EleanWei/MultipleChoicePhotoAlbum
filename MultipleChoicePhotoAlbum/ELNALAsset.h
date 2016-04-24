//
//  ELNALAsset.h
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ELNALAsset : NSObject

@property (nonatomic,strong)ALAsset *asset;
@property (nonatomic,assign)BOOL isSelected;



@end
