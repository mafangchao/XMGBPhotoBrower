//
//  XMGPhotoBrowerWebView.m
//  XMGBPhotoBrower
//
//  Created by machao on 2017/6/7.
//  Copyright © 2017年 machao. All rights reserved.
//

#import "XMGPhotoBrowerWebView.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface XMGPhotoBrowerWebView ()<UIWebViewDelegate,SDPhotoBrowserDelegate>
{
    NSMutableArray *_imageArray;
    NSMutableArray *_imageUrlArray;
}

@property (nonatomic, assign) NSInteger index;
/// 容器视图
@property (nonatomic, strong) UIView *contenterView;


@end

@implementation XMGPhotoBrowerWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contenterView = [[UIView alloc] init];
        _contenterView.center = self.center;
        self.delegate = self;
        [self addSubview:_contenterView];

    }
    return self;
}


#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = _imageUrlArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = _imageArray[index];
    return imageView.image;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        for (NSInteger i = 0; i<_imageUrlArray.count; i++) {
            if ([path isEqualToString:_imageUrlArray[i]]) {
                _index = i;
            }
        }
        
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = _index;
        browser.sourceImagesContainerView = _contenterView;
        browser.imageCount = _imageUrlArray.count;
        browser.delegate = self;
        [browser show];
        
        return NO;
    }
    if ([self.webViewDelegate respondsToSelector:@selector(xmgWebView:shouldStartLoadWithRequest:navigationType:)]) {
        [self.webViewDelegate xmgWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self stringByEvaluatingJavaScriptFromString:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}"];
    
    [self stringByEvaluatingJavaScriptFromString:@"assignImageClickAction();"];
    //
    [ webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout=‘none‘;"];//禁止长按
    
    _imageUrlArray= [self getImgs];//获取所有图片链接
    NSMutableArray *array=[[ NSMutableArray alloc] init];
    for (NSString *string in _imageUrlArray) //剔除没有规则的图集
    {
        
        //        if ([string hasSuffix:@".png"]||[string hasSuffix:@".jpg"]||[string hasSuffix:@".jpeg"])
        //        {
        [array addObject:string];
        //        }
    }
    _imageUrlArray=array;
    _imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _imageUrlArray.count; i++) {
        UIImageView *view = [[UIImageView alloc] init];
        [_imageArray addObject:view];
        [view sd_setImageWithURL:_imageUrlArray[i] placeholderImage:[UIImage imageNamed:@""]];
        [_contenterView addSubview:view];
    }
    if ([self.webViewDelegate respondsToSelector:@selector(xmgWebViewDidFinishLoad:)]) {
        [self.webViewDelegate xmgWebViewDidFinishLoad:webView];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    if ([self.webViewDelegate respondsToSelector:@selector(xmgWebViewDidStartLoad:)]) {
        [self.webViewDelegate xmgWebViewDidStartLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if ([self.webViewDelegate respondsToSelector:@selector(xmgWebView:didFailLoadWithError:)]) {
        [self.webViewDelegate xmgWebView:webView didFailLoadWithError:error];
    }
}
//获取某个标签的结点个数
- (int)nodeCountOfTag:(NSString *)tag {
    
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    int len = [[self stringByEvaluatingJavaScriptFromString:jsString] intValue]; return len;
}
//获取所有图片链接
- (NSMutableArray *)getImgs
{
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    int node = [self nodeCountOfTag:@"img"];
    for (int i = 0; i < node; i++)
    {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        NSString *img = [self stringByEvaluatingJavaScriptFromString:jsString];
        [arrImgURL addObject:img];
    }
    return arrImgURL;
}


@end
