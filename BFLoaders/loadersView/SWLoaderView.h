//
//  SWLoaderView.h
//  SmartMSBusiness
//
//  Created by Bacem on 12/03/2015.
//  Copyright (c) 2015 streamwide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWLoaderViewWindow : UIWindow

@end
@interface SWLoaderView : UIView

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * subTitle;

-(void)show;
-(void)hide;
- (void)blink;
-(void)showLoaderInView:(UIView*)view;
-(void)hideLoaderView;

-(void)showInWindow;

@end
