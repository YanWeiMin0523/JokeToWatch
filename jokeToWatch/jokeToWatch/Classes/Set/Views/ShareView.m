//
//  ShareView.m
//  jokeToWatch
//
//  Created by scjy on 16/3/10.
//  Copyright © 2016年 YanWeiMin. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "WXApiObject.h"

@interface ShareView ()<WXApiDelegate, WBHttpRequestDelegate>

@property(nonatomic, strong) UIView *shareView;
@property(nonatomic, strong) UIView *blackView;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configShareView];
    }
    return self;
}

- (void)configShareView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    //视图黑背景
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 200)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    [window addSubview:self.blackView];
    
    //弹出
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 250, kWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];
    
    //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(10, 20, kWidth/4, kWidth/4);
    [weiboBtn setImage:[UIImage imageNamed:@"ic_focused"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(goToShare:) forControlEvents:UIControlEventTouchUpInside];
    weiboBtn.tag = 1;
    [self.shareView addSubview:weiboBtn];
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kWidth/4+20, kWidth/4, 30)];
    weiboLabel.text = @"微博好友";
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weiboLabel];
    
    //微信
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(kWidth/3+10, 20, kWidth/4, kWidth/4);
    [weixinBtn setImage:[UIImage imageNamed:@"icon_pay_weixin"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(goToShare:) forControlEvents:UIControlEventTouchUpInside];
    weixinBtn.tag = 2;
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/3+10, kWidth/4+20, kWidth/4, 30)];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.text= @"微信好友";
    [self.shareView addSubview:weixinLabel];
    [self.shareView addSubview:weixinBtn];
    
    //朋友圈
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(kWidth*2/3+10, 20, kWidth/4, kWidth/4);
    [friendBtn setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
    friendBtn.tag = 3;
    [friendBtn addTarget:self action:@selector(goToShare:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth*2/3+10, kWidth/4+20, kWidth/4, 30)];
    friendLabel.text = @"朋友圈";
    friendLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.shareView addSubview:friendLabel];
    [self.shareView addSubview:friendBtn];
    
    //取消
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    removeBtn.frame = CGRectMake(20, kWidth/2-20, kWidth - 40, 30);
    removeBtn.backgroundColor = [UIColor orangeColor];
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.8;
        self.shareView.frame = CGRectMake(0, kHeight - 200, kWidth, 200);
    }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0 animations:^{
                             self.blackView.alpha = 0.8;
                         }];
                     }];

    
}

//取消分享
- (void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.0;
        self.shareView.alpha = 0.0;
        self.shareView.frame = CGRectMake(0, kHeight - 250, kWidth, 200);
    }completion:^(BOOL finished) {
        [self.shareView removeAllSubviews];
        [self.blackView removeAllSubviews];
    }];

}

//点击分享
- (void)goToShare:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
            AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            WBAuthorizeRequest *authRequest =[WBAuthorizeRequest request];
            authRequest.redirectURI = kRedirectURI;
            authRequest.scope = @"all";
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
            
            [WeiboSDK sendRequest:request];
            [self removeView];

        }
            break;
        case 2:
        {
            //分享微信
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.text = self.model.plain;
            req.scene = WXSceneSession;
            req.bText = YES;
            [WXApi sendReq:req];
        }
            break;
            case 3:
        {
            //微信朋友圈
            SendMessageToWXReq *friendReq = [[SendMessageToWXReq alloc] init];
            friendReq.text = self.model.plain;
            friendReq.scene = WXSceneTimeline;
            friendReq.bText = YES;
            [WXApi sendReq:friendReq];
        }
            
        default:
            break;
    }
    
    
    
    
}

- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    //文字
    message.text = NSLocalizedString(self.model.plain, nil);
    //图片
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"li" ofType:@"png"]];
    message.imageObject = image;
    
    return message;

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
