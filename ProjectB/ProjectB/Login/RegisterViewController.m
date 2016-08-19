//
//  RegisterViewController.m
//  ProjectB
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 0403ClassTeam02. All rights reserved.
//

#import "RegisterViewController.h"
#import "EMSDK.h"
#import "LoginViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *registerUserName;
@property (weak, nonatomic) IBOutlet UITextField *registerPassword;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordrepeat;

@end

@implementation RegisterViewController
- (IBAction)registerAction:(id)sender{
    if (self.registerUserName.text.length < 6 || self.registerPassword.text.length < 6) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"警告" message:@"用户名和密码不能短于六位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    //注册
    //异步注册
    if ([_registerPassword.text isEqualToString:_registerPasswordrepeat.text]) {
        [[EMClient sharedClient] asyncRegisterWithUsername:self.registerUserName.text password:self.registerPassword.text success:^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"恭喜您！" message:@"注册成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        [[EMClient sharedClient]asyncLoginWithUsername:_registerUserName.text password:_registerPassword.text success:^{
                            //1
                            self.loginVC.namelabel.text = _registerUserName.text;
                            [self.loginVC dismissVC];
                        } failure:^(EMError *aError) {
                            //2
                        }];
                    }];
            }];
            [alertVC addAction:sureAction];
            [self presentViewController:alertVC animated:YES completion:^{
//                [self.navigationController popViewControllerAnimated:YES];
            }];


            
            
            
            
        } failure:^(EMError *aError) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"警告" message:aError.errorDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:sureAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"两次密码输入不相同，请检查！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    
    
    //    [[EMClient sharedClient]registerWithUsername:self.registerUserName.text password:self.registerPassword.text];
    
    //同步注册
    //    EMError *error = [[EMClient sharedClient]registerWithUsername:self.registerUserName.text password:self.registerPassword.text];
    //    if (error == nil) {
    //        NSLog(@"注册成功");
    //    }else{
    //        NSLog(@"注册失败，%@",error.errorDescription);
    //    }
    //    
}
- (IBAction)canceledAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
