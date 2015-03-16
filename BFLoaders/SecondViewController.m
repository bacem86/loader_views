//
//  SecondViewController.m
//  BFLoaders
//
//  Created by Bacem on 16/03/2015.
//  Copyright (c) 2015 BF. All rights reserved.
//

#import "SecondViewController.h"
#import "SWLoaderView.h"
#import "SWLinearLoaderView.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.linearLoader){
        SWLinearLoaderView * loaderView = [[SWLinearLoaderView alloc] init];
        loaderView.title = @"Loading...";
        loaderView.subTitle = @"Please wait...";
        [loaderView showInWindow];
    }else{
        SWLoaderView * loaderView = [[SWLoaderView alloc] init];
        loaderView.title = @"Loading...";
        loaderView.subTitle = @"Please wait...";
        [loaderView showInWindow];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
