//
//  SYDetailController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYDetailController.h"
#import "SYStory.h"
#import "YSHttpTool.h"

@interface SYDetailController ()

@property (nonatomic, strong) SYStory *story;

@end

@implementation SYDetailController

- (instancetype)initWithStory:(SYStory *)story
{
    self = [super init];
    if (self) {
        self.story = story;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%lld", self.story.id];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [YSHttpTool GETWithURL:url params:nil success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
   
        NSMutableString *htmlStr = [@"<html><head>" mutableCopy];
        
        NSArray *cssArray = dict[@"css"];
        NSArray *jsArray = dict[@"js"];
        
        if (jsArray.count >= 1) {
            for (NSString *url in jsArray) {
                [htmlStr appendFormat:@"<script src=\"%@\"></script>", url];
            }
        }
        
        if (cssArray.count >= 1) {
            for (NSString *url in cssArray) {
                [htmlStr appendFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\">", url];
            }
        }
        
        [htmlStr appendFormat:@"</head><body>%@</body></html>", dict[@"body"]];
        
        
        NSString *placeHolderStr = [NSString stringWithFormat:@"<div class=\"img-place-holder\"><img src=\"%@\"></div>", dict[@"image"]];
        [htmlStr replaceOccurrencesOfString:@"<div class=\"img-place-holder\"></div>" withString:placeHolderStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlStr.length)];
        
        
        NSLog(@"%@", htmlStr);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView loadHTMLString:htmlStr baseURL:nil];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"加载出错....");
    }];
    
    
    

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
