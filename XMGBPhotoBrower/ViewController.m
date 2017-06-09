//
//  ViewController.m
//  XMGBPhotoBrower
//
//  Created by machao on 2017/6/6.
//  Copyright © 2017年 machao. All rights reserved.
//

#import "ViewController.h"

#import "XMGPhotoBrowerWebView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<XMGPhotoBrowerWebViewDelegate>


@property (nonatomic, strong) UITextField *textFiled;

@property (nonatomic, strong) XMGPhotoBrowerWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}


/// 初始化子控件
- (void)setupUI{
    
    _textFiled = [[UITextField alloc] init];
    _textFiled.backgroundColor = [UIColor lightGrayColor];
    _textFiled.text = @"http://api.cyzone.cn/22/311643.html";
    [self.view addSubview:_textFiled];
    _textFiled.frame = CGRectMake(20, 20, kScreenWidth - 100, 40);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(kScreenWidth -80, 20, 60, 40);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _webview = [[XMGPhotoBrowerWebView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 60)];
    _webview.webViewDelegate = self;
    [self.view addSubview:_webview];

//    http://www.jianshu.com/p/0fc864cee3bb

}


/**
   搜索点击事件（加载请求）
 */
- (void)buttonClick {
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.textFiled.text]];
    [self.webview reload];
    [self.webview loadRequest:req];
}

- (BOOL)xmgWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return  YES;
}

- (void)xmgWebViewDidStartLoad:(UIWebView *)webView{

}
- (void)xmgWebViewDidFinishLoad:(UIWebView *)webView{

}
- (void)xmgWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
