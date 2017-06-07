//
//  XMGPhotoBrowerWebView.h
//  XMGBPhotoBrower
//
//  Created by machao on 2017/6/7.
//  Copyright © 2017年 machao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  XMGPhotoBrowerWebViewDelegate<NSObject>

@optional
- (BOOL)xmgWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)xmgWebViewDidStartLoad:(UIWebView *)webView;
- (void)xmgWebViewDidFinishLoad:(UIWebView *)webView;
- (void)xmgWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end


@interface XMGPhotoBrowerWebView : UIWebView



/**
    如果还想监听webview的代理方法，请遵循这个代理，并实现上面的方法
 */
@property (nonatomic, weak) id<XMGPhotoBrowerWebViewDelegate> webViewDelegate;

@end
