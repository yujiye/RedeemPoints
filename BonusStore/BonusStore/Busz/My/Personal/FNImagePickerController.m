//
//  FNImagePickerController.m
//  BonusStore
//
//  Created by Nemo on 16/7/19.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNImagePickerController.h"
#import "FNHeader.h"
#import "FNMyBO.h"
@interface FNImagePickerController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
    BOOL _isChanged;
    
    NSFileManager * fileManager;
}
@end

@implementation FNImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model = [[FNPersonalModel alloc]init];
    
    self.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    for (UIView *v in toVC.view.subviews)
    {
        if ([v isKindOfClass:[UICollectionView class]])
        {
            [(UICollectionView *)v setContentInset:UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0)];
            
            return nil;
        }
    }
    
    return nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   

    _isChanged = YES;
    
    NSString * type = [info objectForKey:@"UIImagePickerControllerMediaType"];
    
    if ([type isEqualToString:@"public.image"])
    {
        _image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        if (UIImagePNGRepresentation(_image) == nil)
        {
            _data = UIImageJPEGRepresentation(_image, 1.0);
        }
        else
        {
            _data = UIImagePNGRepresentation(_image);
        }
        
        _path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"res"];
        
        fileManager = [NSFileManager defaultManager];
        
        [fileManager createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil];
        
        [fileManager createFileAtPath:[_path stringByAppendingString:@"/image.png"] contents:_data attributes:nil];
        
        self.model.favImgPath = [[NSString alloc]initWithFormat:@"%@%@",_path,@"/image.png"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIImageView * imageview = (UIImageView *)[self.view viewWithTag:4];
        
        imageview.layer.cornerRadius = 29.0;
        
        imageview.image=_image;
        
        if ([self.imageDelegate respondsToSelector:@selector(imageWithModel:)])
        {
            [self.imageDelegate imageWithModel:self];
        }
    }
    else
    {
        [UIAlertView alertViewWithMessage:@"暂不支持该格式，请重试"];
    }

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
