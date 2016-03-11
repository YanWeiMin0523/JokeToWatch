//
//  LoginViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "PassWordViewController.h"
#import "ProgressHUD.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UISwitch *checkPass;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    //密码密文
    self.passText.secureTextEntry = YES;
    self.checkPass.on = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}
//登录
- (IBAction)loginBtn:(id)sender {
   
    [BmobUser loginWithUsernameInBackground:self.userText.text password:self.passText.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [ProgressHUD showSuccess:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            //返回上一页
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
     UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }] ;
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alterC addAction:alertCancel];
            [alterC addAction:alertAction];
            [self presentViewController:alterC animated:YES completion:nil];
        }
        
    }];
   
    
}




//密码显示
- (IBAction)checkPassSwitch:(id)sender {
    UISwitch *passSwitch = sender;
    if (passSwitch.on) {
        self.passText.secureTextEntry = NO;
    }else{
    self.passText.secureTextEntry = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


//回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
