//
//  ELNAlertTool.h
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ELNAlertTool : NSObject

+ (void)showAlertWithController:(UIViewController *)controller andTitle:(NSString *)title andMessage:(NSString *)message afterDelay:(NSTimeInterval)time;

@end
