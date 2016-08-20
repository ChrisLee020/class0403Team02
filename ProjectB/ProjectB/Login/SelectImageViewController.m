//
//  SelectImageViewController.m
//  ProjectB
//
//  Created by lanou on 16/8/20.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "SelectImageViewController.h"

@interface SelectImageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UIView *clipView;
@property(nonatomic,assign)CGPoint startPoint;
@property(nonatomic,strong)UIPanGestureRecognizer *pan;

@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _imageview = [[UIImageView alloc]init];
    if (self.view.bounds.size.width > 415) {
        _imageview.frame = CGRectMake(self.view.frame.size.width * 0.2, 0, self.view.frame.size.width * 0.6, self.view.frame.size.width * 0.6);
    }else{
        _imageview.frame = CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.width );
    }
    [self.view addSubview:_imageview];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.bounds.size.width / 2 - 40, self.view.bounds.size.height -50, 80, 30);
    [btn setTitle:@"设置图片" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
     [self.view addSubview:btn];
     [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, _imageview.frame.size.height + 30, self.view.frame.size.width - 160, 100)];
    label.text = @"选择图片后，拖拽矩形区域来选取你想要作为头像的部分。";
    label.font = [UIFont systemFontOfSize:18];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    
}
-(void)btnAction{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.view.backgroundColor = [UIColor orangeColor];
    UIImagePickerControllerSourceType a = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.sourceType = a;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    _imageview.image = info[UIImagePickerControllerEditedImage];

    [self dismissViewControllerAnimated:YES completion:^{

        [self AT];
    }];
    
}
-(void)AT{
    NSLog(@"1111");
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    _pan = pan;
    _imageview.userInteractionEnabled = YES;
    [self.imageview addGestureRecognizer:_pan];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pan:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
        //获得点击起点
        self.startPoint = [pan locationInView:self.view];
        UIView *clipView = [[UIView alloc]init];
        clipView.backgroundColor = [UIColor clearColor];
        clipView.alpha = 0.5;
        [self.view addSubview:clipView];
        clipView.layer.borderWidth = 1;
        clipView.layer.borderColor = [UIColor redColor].CGColor;
        _clipView = clipView;
        [self.view bringSubviewToFront:_clipView];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        //求偏移量
        CGPoint CurPoint = [pan locationInView:self.view];
        CGFloat OffSetX = CurPoint.x - self.startPoint.x;
        CGFloat offSetY = CurPoint.y - self.startPoint.y;
        self.clipView.frame = CGRectMake(self.startPoint.x, self.startPoint.y, OffSetX, offSetY);
    }else if (pan.state == UIGestureRecognizerStateEnded){
        //获取屏幕图像
        UIGraphicsBeginImageContext(self.view.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        UIRectClip(self.clipView.frame);
        [self.view.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        _imageviewHead.image = image;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
        NSString *path1 = [path stringByAppendingPathComponent:@"userdata.json"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path1];
        if (dict == nil) {
            dict = [[NSMutableDictionary alloc]init];
        }
        NSString *imagename = [NSString stringWithFormat:@"%d%d%d.jpg",arc4random()%1000,arc4random()%1000,arc4random()%1000];
        NSString *path2 = [path stringByAppendingPathComponent:imagename];
        NSLog(@"%@",path2);
        [UIImageJPEGRepresentation(image, 1) writeToFile:path2 atomically:YES];
        [dict setValue:imagename forKey:_namelabelHead.text];
        [dict writeToFile:path1 atomically:YES];
        [self.clipView removeFromSuperview];
        _clipView = nil;
        [self.view removeGestureRecognizer:_pan];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存失败");
    }else{
        NSLog(@"保存成功");
    }
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
