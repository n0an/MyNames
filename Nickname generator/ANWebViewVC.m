//
//  ANWebViewVC.m
//  Nickname generator
//
//  Created by Anton Novoselov on 05/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANWebViewVC.h"
#import "ANUtils.h"

@interface ANWebViewVC ()

@end

@implementation ANWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ANLog(@"ANWebViewVC received: %@", self.nameURL);
    
    NSURL* url = [NSURL URLWithString:self.nameURL];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
    [self refreshButtons];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Helper Methods

- (void) refreshButtons {
    self.backButtonItem.enabled = [self.webView canGoBack];
    self.forwardButtonItem.enabled = [self.webView canGoForward];
}




#pragma mark - Actions


- (IBAction)actionBack:(id)sender {
    
    if ([self.webView canGoBack]) {
        [self.webView stopLoading];
        [self.webView goBack];
    }
    
}


- (IBAction)actionForward:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView stopLoading];
        [self.webView goForward];
    }
}


- (IBAction)actionRefresh:(id)sender {
    [self.webView stopLoading];
    [self.webView reload];
    
}




#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"shouldStartLoadWithRequest %@", [request debugDescription]);
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    [self refreshButtons];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self.activityIndicator stopAnimating];
    [self refreshButtons];
    
}











@end
