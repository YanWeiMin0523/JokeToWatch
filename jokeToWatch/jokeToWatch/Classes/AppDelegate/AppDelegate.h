//
//  AppDelegate.h
//  jokeToWatch
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SetViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *wntoken;
    NSString *wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, copy) NSString *wbtoken;
@property(nonatomic, copy) NSString *wbCurrentUserID;
@property(nonatomic, copy) NSString *wbRefreshToken;

@end

