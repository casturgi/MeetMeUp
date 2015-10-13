//
//  WebViewController.m
//  MeetMeUp
//
//  Created by cory Sturgis on 10/12/15.
//  Copyright © 2015 CorySturgis. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property NSString *theTitle;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spinner.hidesWhenStopped = YES;
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    [self.webView.scrollView setDelegate:self];
    NSString *urlAddress = [NSString stringWithFormat:@"https://www.%@.com", [[self.event objectForKey:@"group"] objectForKey:@"urlname"]];
    NSLog(@"%@",urlAddress);
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}


- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];

}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.spinner startAnimating];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.spinner stopAnimating];
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;

    self.theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationController.navigationBar.topItem.title = self.theTitle;

    self.urlTextField.text = self.webView.request.URL.absoluteString;
}
- (IBAction)comingSoonOnPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Coming soon." message: @"Try again later!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *enteredText = textField.text;
    BOOL hasPrefix = ([enteredText hasPrefix:@"http://"] || [enteredText hasPrefix:@"https://"]);
    if (hasPrefix == YES){
        NSURL *url = [NSURL URLWithString:textField.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];

    } else {
        NSString *newURL = [NSString stringWithFormat:@"https://%@",enteredText];
        NSURL *url = [NSURL URLWithString:newURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    return [textField resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    CGFloat *lastPosition = 0.0;
    CGRect newFrame = self.urlTextField.frame;
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 0 ){
        self.urlTextField.alpha = (100/scrollView.contentOffset.y);
        newFrame.origin.y -= (scrollView.contentOffset.y/100);
        self.urlTextField.frame = newFrame;
    } else {
        self.urlTextField.alpha = 1;
        newFrame.origin.y = 75;
        self.urlTextField.frame = newFrame;
    }
    
}
@end
