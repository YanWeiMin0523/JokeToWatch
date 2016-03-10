//
//  AppDelegate.m
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "AppDelegate.h"
#import "HotViewController.h"
#import "ClassicsViewController.h"
#import "SetViewController.h"
#import "NewestViewController.h"
#import <BmobSDK/Bmob.h>
#import "WeiboSDK.h"
#import "WXApi.h"
@interface AppDelegate ()<WeiboSDKDelegate, WXApiDelegate>

@property(nonatomic, strong) UITabBarController *tabBarVC;

@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //bmob
    [Bmob registerWithAppKey:kBmobKey];
    
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWeiBoAppKey];
    
    //微信
    [WXApi registerApp:kWeiXinAppID];
    
    self.tabBarVC = [[UITabBarController alloc] init];
    //热门糗事
    UIStoryboard *hotStory = [UIStoryboard storyboardWithName:@"Hot" bundle:nil];
    UINavigationController *hotNav = [hotStory instantiateInitialViewController];
    hotNav.tabBarItem.image = [UIImage imageNamed:@"icon_my_enable"];
    //选中图片
    UIImage *hotImage = [UIImage imageNamed:@"icon_my_active"];
    hotNav.tabBarItem.selectedImage = [hotImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hotNav.title = @"热门";
    
    //经典桥段
    UIStoryboard *classisStory = [UIStoryboard storyboardWithName:@"Classis" bundle:nil];
    UINavigationController *classisNav = [classisStory instantiateInitialViewController];
    classisNav.tabBarItem.image = [UIImage imageNamed:@"icon_new_enable"];
    UIImage *classisImage = [UIImage imageNamed:@"icon_new_active"];
    classisNav.tabBarItem.selectedImage = [classisImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    classisNav.title = @"经典";
    
    //最近更新
    UIStoryboard *newStory = [UIStoryboard storyboardWithName:@"Newest" bundle:nil];
    UINavigationController *newNav = [newStory instantiateInitialViewController];
    newNav.tabBarItem.image = [UIImage imageNamed:@"icon_top_enable"];
    UIImage *newImage = [UIImage imageNamed:@"icon_top_active"];
    newNav.tabBarItem.selectedImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newNav.title = @"最新";
    
    //设置
    UIStoryboard *setStory = [UIStoryboard storyboardWithName:@"Set" bundle:nil];
    UINavigationController *setNav = [setStory instantiateInitialViewController];
    setNav.tabBarItem.image = [UIImage imageNamed:@"icon_help_set"];
    UIImage *setImage = [UIImage imageNamed:@"icon_help"];
    setNav.tabBarItem.selectedImage = [setImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    setNav.title = @"设置";
    [[UITabBar appearance] setTintColor:[UIColor orangeColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    self.tabBarVC.viewControllers = @[hotNav, classisNav, newNav, setNav];
    self.window.rootViewController = self.tabBarVC;
    
    return YES;
}

#pragma mark ------------ 微博 微信方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"恭喜您，分享成功!", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
