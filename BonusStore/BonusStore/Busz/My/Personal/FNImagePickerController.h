//
//  FNImagePickerController.h
//  BonusStore
//
//  Created by Nemo on 16/7/19.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@class FNImagePickerController;

@protocol FNImagePickerControllerDelegate <NSObject>

- (void)imageWithModel:(FNImagePickerController *)imagePickerController;

@end

@interface FNImagePickerController : UIImagePickerController

@property (nonatomic, weak)id<FNImagePickerControllerDelegate>imageDelegate;

@property (nonatomic, strong) FNPersonalModel * model;

@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, strong) NSString * path;

@end
