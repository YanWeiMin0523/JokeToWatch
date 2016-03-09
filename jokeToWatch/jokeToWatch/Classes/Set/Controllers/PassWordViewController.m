//
//  PassWordViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "PassWordViewController.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"
#import "ForgetViewController.h"

@interface PassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UITextField *surePassText;
@property (weak, nonatomic) IBOutlet UISwitch *passSwitch;
@property(nonatomic, strong) UIAlertAction *alertSure;
@property(nonatomic, strong) UIAlertAction *alertCancel;

@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passText.secureTextEntry = YES;
    self.surePassText.secureTextEntry = YES;
    //switch默认关闭
    self.passSwitch.on = NO;
    [self backToPreviousPageWithImage];
    self.tabBarController.tabBar.hidden = YES;
    
}
//注册
- (IBAction)registerBtn:(id)sender {
    if (![self checkPassSure]) {
        return;
    }
    [ProgressHUD show:@"正在注册……"];
    BmobUser *bmobUser = [[BmobUser alloc] init];
    [bmobUser setUsername:self.phoneText.text];
    [bmobUser setPassword:self.passText.text];
    [bmobUser setMobilePhoneNumber:self.phoneText.text];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithString:self.phoneText.text] forKey:@"userName"];
    [userDefaults setValue:[NSString stringWithString:self.passText.text] forKey:@"userPass"];
    
    [bmobUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"恭喜你，注册成功"];
            //保存数据
            [userDefaults synchronize];
            YWMLog(@"注册成功");
        }else{
            [ProgressHUD showError:@"很遗憾，你注册失败了/(ㄒoㄒ)/~~"];
            YWMLog(@"%@", error);
        }
    }];
    
    
    
}
//密码是否明文
- (IBAction)switchPass:(id)sender {
    UISwitch *passSwitch = sender;
    if (passSwitch.on) {
        self.passText.secureTextEntry = NO;
        self.surePassText.secureTextEntry = NO;
    }else{
        self.passText.secureTextEntry = YES;
        self.surePassText.secureTextEntry = YES;
    }
}

//判断
- (BOOL)checkPassSure{
    //判断手机号
    if (self.phoneText.text.length <= 0 && [self.phoneText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    //判断手机号的格式
    //移动
    NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    //联通
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSPredicate *regextestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //电信
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSPredicate *regextestCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //小灵通
    NSString *CT = @"^1((33|53|8[09])[09]|349)\\d@{7}$";
    NSPredicate *regextestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (!([regextestMobile evaluateWithObject:self.phoneText.text] == YES || [regextestCU evaluateWithObject:self.phoneText.text] == YES || [regextestCT evaluateWithObject:self.phoneText.text] == YES || [regextestCM evaluateWithObject:self.phoneText.text] == YES)) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号格式不正确" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    //判断密码
    if (self.passText.text.length <= 0 && [self.passText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
        forgetVC.oldPass = self.passText.text;
        
        
        return NO;
    }
    //判断两个密码
    if (![self.passText.text isEqualToString:self.surePassText.text]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不一致，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

//回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//懒加载
- (UIAlertAction *)alertCancel{
    if (!_alertCancel) {
        self.alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    }
    return _alertCancel;
}

- (UIAlertAction *)alertSure{
    if (!_alertSure) {
        self.alertSure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    }
    return _alertSure;
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
