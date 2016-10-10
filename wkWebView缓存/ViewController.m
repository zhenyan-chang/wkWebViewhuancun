//
//  ViewController.m
//  wkWebView缓存
//
//  Created by 精美 on 16/10/10.
//  Copyright © 2016年 zhenyan_C. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, assign) CGFloat webViewHeight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 44)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    // 1.创建webview，并设置大小，"20"为状态栏高度
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _urlStr = @"http://www.jianshu.com/users/556f56cfb087/latest_articles";
    // 最后将webView添加到界面
    [self.view addSubview:_webView];
    
    // 取本地缓存
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,      NSUserDomainMask, YES) objectAtIndex:0];
    NSString * path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/Caches/%lu.html",(unsigned long)[_urlStr hash]]];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (!(htmlString == nil || [htmlString isEqualToString:@""])) {
        // 如果有缓存就取缓存，没有就请求
        [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:_urlStr]];
    }else{
        // 新的链接走这里进行缓存
        NSURL *url = [NSURL URLWithString:_urlStr];
         NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        [self writeToCaches];
    }


}

/**
 * 网页缓存写入文件
 */
- (void)writeToCaches
{
    NSString * htmlResponseStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:_urlStr] encoding:NSUTF8StringEncoding error:Nil];
    //创建文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    //获取document路径,括号中属性为当前应用程序独享
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,      NSUserDomainMask, YES) objectAtIndex:0];
    [fileManager createDirectoryAtPath:[cachesPath stringByAppendingString:@"/Caches"] withIntermediateDirectories:YES attributes:nil error:nil];
    //定义记录文件全名以及路径的字符串filePath
    NSString * path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/Caches/%lu.html",(unsigned long)[_urlStr hash]]];
    
    [htmlResponseStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
