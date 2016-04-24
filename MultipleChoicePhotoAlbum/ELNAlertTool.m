//
//  ELNAlertTool.m
//  MultipleChoicePhotoAlbum
//
//  Created by Elean on 16/4/12.
//  Copyright © 2016年 Elean. All rights reserved.
//

#import "ELNAlertTool.h"

@implementation ELNAlertTool
+ (void)showAlertWithController:(UIViewController *)controller andTitle:(NSString *)title andMessage:(NSString *)message afterDelay:(NSTimeInterval)time{

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    [controller presentViewController:alert animated:YES completion:^{
       
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:time];
        
    }];
    
}

- (void)dismissAlert:(UIAlertController *)alert{

    [alert dismissViewControllerAnimated:YES completion:nil];
}
@end
