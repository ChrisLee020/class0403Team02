//
//  LoginViewController.m
//  ProjectB
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "LoginViewController.h"
#import "UMSocial.h"
#import "RegisterViewController.h"
#import "EMSDK.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *UserNameText;
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Logincanceled:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"你二大爷");
    }];
}

- (IBAction)LoginBtn:(id)sender {
    if ([[EMClient sharedClient] isConnected]) {
        [[EMClient sharedClient]logout:YES];
    }
    if (self.UserNameText.text.length < 6 || self.PasswordText.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"用户名和密码长度不能小于六位" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }else{
        [[EMClient sharedClient] asyncLoginWithUsername:self.UserNameText.text password:self.PasswordText.text success:^{
            _namelabel.text = _UserNameText.text;
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"登陆成功");
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
                NSString *path1 = [path stringByAppendingPathComponent:@"userdata.json"];
                NSMutableDictionary *userdataDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
                NSString *path2 = [userdataDict valueForKey:_namelabel.text];
                NSString *path3 = [path stringByAppendingPathComponent:path2];
                UIImage *image = [UIImage imageWithContentsOfFile:path3];
                if (image == nil) {
                    image = [UIImage imageNamed:@"userImageplaceholder.png"];
                }
                _image.image = image;
                
            }];

        } failure:^(EMError *aError) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"登录失败！\n请检查你的账号与密码是否正确！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];
    }
    
    
    
    
    
    
}
- (IBAction)registerBtn:(id)sender {
//    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
//    [self.navigationController pushViewController:registerVC animated:YES];
    UIStoryboard *LoginSB = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    RegisterViewController *registerVC = [LoginSB instantiateViewControllerWithIdentifier:@"Register"];
    registerVC.loginVC = self;
    [self.navigationController pushViewController:registerVC animated:YES];


}


-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response{
    /**
     点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
     例如：
     
     -(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
     {
     if (platformName == UMShareToSina) {
     socialData.shareText = @"分享到新浪微博的文字内容";
     }
     else{
     socialData.shareText = @"分享到其他平台的文字内容";
     }
     }
     
     @param platformName 点击分享平台
     
     @prarm socialData   分享内容
     */
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功");
        
    }
    
    
}


- (IBAction)sinaLogin:(id)sender {
    /*
     //分享功能模板
     [UMSocialData defaultData].extConfig.title = @"分享的title";
     [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
     [UMSocialSnsService presentSnsIconSheetView:self
     appKey:@"507fcab25270157b37000010"
     shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
     shareImage:[UIImage imageNamed:@"icon"]
     shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
     delegate:self];
     */
    //第三方登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        NSLog(@"response.responseCode%u",response.responseCode);
        //获取微博用户名，UID，token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [dict valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            
            _namelabel.text = snsAccount.userName;
            _image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:snsAccount.iconURL]]];
            _image.layer.cornerRadius = 0;
        }else{
                    NSLog(@"错误代码response.responseCode%u",response.responseCode);
             [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response){ NSLog(@"SnsInformation is %@",response.data); }];
            
        }
        [self dismissViewControllerAnimated:YES completion:^{
        //    NSLog(@"弹出运行正常");
        }];
    });
    
    
}

-(void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:^{
    //    NSLog(@"方法调用弹出成功");
    }];
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
