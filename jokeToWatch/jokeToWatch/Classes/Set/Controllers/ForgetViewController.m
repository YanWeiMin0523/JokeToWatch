//
//  ForgetViewController.m
//  jokeToWatch
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ForgetViewController.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"
#import <BmobSDK/BmobSMS.h>
@interface ForgetViewController ()
{
    UIAlertView *alertV;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeText;
@property (weak, nonatomic) IBOutlet UITextField *forgetPassText;
@property (weak, nonatomic) IBOutlet UISwitch *passSwitch;
@property(nonatomic, strong) UIAlertAction *alertSure;
@property(nonatomic, strong) UIAlertAction *alertCancel;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.tabBarController.tabBar.hidden = YES;
    self.forgetPassText.secureTextEntry = YES;
    
    self.passSwitch.on = NO;
    
}
//判断
- (BOOL)chechMessggeSure{
    //手机号
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
    //密码
    if (self.forgetPassText.text.length <= 0 && [self.forgetPassText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    //判断新密码与旧密码
    if ([self.forgetPassText.text isEqualToString:self.oldPass]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"新密码与旧密码不能一致" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

//验证码
- (IBAction)verifyCode:(id)sender {
    
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneText.text andTemplate:@"验证码" resultBlock:^(int number, NSError *error) {
        
        //判断手机号为空
        if (self.phoneText.text.length <= 0 && [self.phoneText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号不能为空" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:self.alertCancel];
            [alertC addAction:self.alertSure];
            [self presentViewController:alertC animated:YES completion:nil];
        }else{
            alertV = [[UIAlertView alloc] initWithTitle:@"验证码十分钟内有效" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            NSTimer *timer;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(doTimer) userInfo:nil repeats:YES];
        }
    }];
    
    
}

- (void)doTimer{
    [alertV dismissWithClickedButtonIndex:0 animated:YES];
}

//完成
- (IBAction)achieveForgetPass:(id)sender {
    if (![self chechMessggeSure]) {
        return;
    }
    //验证码重置密码
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.verifyCodeText.text andNewPassword:self.forgetPassText.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"重置密码成功"];
            YWMLog(@"修改成功");
        }else{
        [ProgressHUD showError:@"很遗憾，密码修改失败"];
        YWMLog(@"%@", error);
        }
    }];

    
}


//密码明文
- (IBAction)passSwitch:(id)sender {
    UISwitch *forgetSwitch = sender;
    if (forgetSwitch.on) {
        self.forgetPassText.secureTextEntry = NO;
    }
    self.forgetPassText.secureTextEntry = YES;
    
}

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
