//
//  SWLoaderView.m
//  SmartMSBusiness
//
//  Created by Bacem on 12/03/2015.
//  Copyright (c) 2015 streamwide. All rights reserved.
//

#import "SWLoaderView.h"
#define leftMargin 10.0
#define margin 5.0
@interface SWLoaderViewWindow ()
@property (nonatomic,strong) UIWindow *  previousKeyWindow;
-(void)showView:(UIView*)view;
@end
@implementation SWLoaderViewWindow
- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    return self;
}

-(void)showView:(UIView*)view{
    self.previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
    [self insertSubview:view atIndex:0];
    [self makeKeyAndVisible];
    
}
-(void)hide:(UIView*)view{
    [self.previousKeyWindow makeKeyWindow];
}

@end
@interface SWLoaderView ()
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * labelsView;
@property (nonatomic,strong) UIImageView * loader;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subTitleLabel;
@property (nonatomic,strong) NSLayoutConstraint * contentViewWidth;
@property (nonatomic,strong) NSLayoutConstraint * contentViewHeight;
@property (nonatomic,strong) SWLoaderViewWindow * manager;
@end
@implementation SWLoaderView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self comminInit];
    }
    return self;
}
-(void)comminInit{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.hidden = YES;
    self.alpha = 0;
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    
    
    self.labelsView = [[UIView alloc] init];
    self.labelsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelsView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.labelsView];
    
    self.loader = [[UIImageView alloc] init];
    self.loader.translatesAutoresizingMaskIntoConstraints = NO;
    self.loader.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.loader];
    // self.loader.contentMode = UIViewContentModeScaleAspectFill;
    
    NSMutableArray * images = [NSMutableArray array];
    
    for (NSInteger pos = 0; pos<6 ; pos++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"loaderPosition%li",(long)pos]];
        
        UIImage * resizable = [image resizableImageWithCapInsets:UIEdgeInsetsZero
                                                    resizingMode:UIImageResizingModeStretch];
        if(resizable)
            [images addObject:resizable];
        
    }
    [self.loader setAnimationImages:images];
    [self.loader setAnimationDuration:0.7];
    [self.loader startAnimating];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 4;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.labelsView addSubview:self.titleLabel];
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    self.titleLabel.textColor  = [UIColor whiteColor];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.numberOfLines = 4;
    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    [self.labelsView addSubview:self.subTitleLabel];
    self.subTitleLabel.textColor  = [UIColor whiteColor];
    [self.subTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-medium" size:14.0]];
    
    NSLayoutConstraint * contentViewCenterY = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:(NSLayoutRelationEqual)
                                                                              toItem:self.contentView.superview
                                                                           attribute:(NSLayoutAttributeCenterY)
                                                                          multiplier:1.0
                                                                            constant:0.0];
    NSLayoutConstraint * contentViewCenterX = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:(NSLayoutRelationEqual)
                                                                              toItem:self.contentView.superview
                                                                           attribute:(NSLayoutAttributeCenterX)
                                                                          multiplier:1.0
                                                                            constant:0.0];
    
    
    self.contentViewWidth = [NSLayoutConstraint constraintWithItem:self.contentView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:(NSLayoutRelationEqual)
                                                            toItem:self.contentView.superview
                                                         attribute:(NSLayoutAttributeWidth)
                                                        multiplier:1.0
                                                          constant:0.0];
    
    
    
    [self addConstraints:@[contentViewCenterY,contentViewCenterX,self.contentViewWidth]];
    
    
    
    NSLayoutConstraint * labelsViewTop = [NSLayoutConstraint constraintWithItem:self.labelsView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:(NSLayoutRelationEqual)
                                                                         toItem:self.labelsView.superview
                                                                      attribute:(NSLayoutAttributeTop)
                                                                     multiplier:1.0
                                                                       constant:margin];
    
    
    NSLayoutConstraint * labelsViewRight = [NSLayoutConstraint constraintWithItem:self.labelsView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:(NSLayoutRelationEqual)
                                                                           toItem:self.labelsView.superview
                                                                        attribute:(NSLayoutAttributeRight)
                                                                       multiplier:1.0
                                                                         constant:-margin];
    NSLayoutConstraint * labelsViewBottom = [NSLayoutConstraint constraintWithItem:self.labelsView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:(NSLayoutRelationEqual)
                                                                            toItem:self.labelsView.superview
                                                                         attribute:(NSLayoutAttributeBottom)
                                                                        multiplier:1.0
                                                                          constant:-margin];
    
    
    
    NSLayoutConstraint * labelsViewLeft = [NSLayoutConstraint constraintWithItem:self.labelsView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:(NSLayoutRelationEqual)
                                                                          toItem:self.loader
                                                                       attribute:(NSLayoutAttributeRight)
                                                                      multiplier:1.0
                                                                        constant:leftMargin];
    
    [self addConstraints:@[labelsViewRight,labelsViewLeft,labelsViewBottom,labelsViewTop]];
    
    
    
    
    NSLayoutConstraint * loaderCenterY = [NSLayoutConstraint constraintWithItem:self.loader
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:(NSLayoutRelationEqual)
                                                                         toItem:self.loader.superview
                                                                      attribute:(NSLayoutAttributeCenterY)
                                                                     multiplier:1.0
                                                                       constant:0.0];
    NSLayoutConstraint * loaderLeft = [NSLayoutConstraint constraintWithItem:self.loader
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:(NSLayoutRelationEqual)
                                                                      toItem:self.loader.superview
                                                                   attribute:(NSLayoutAttributeLeft)
                                                                  multiplier:1.0
                                                                    constant:margin];
    
    NSLayoutConstraint * loaderHeight = [NSLayoutConstraint constraintWithItem:self.loader
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:(NSLayoutRelationEqual)
                                                                        toItem:self.loader.superview
                                                                     attribute:(NSLayoutAttributeHeight)
                                                                    multiplier:0.7
                                                                      constant:0];
    
    NSLayoutConstraint * loaderWidth = [NSLayoutConstraint constraintWithItem:self.loader
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:(NSLayoutRelationEqual)
                                                                       toItem:self.loader
                                                                    attribute:(NSLayoutAttributeHeight)
                                                                   multiplier:1.0
                                                                     constant:0];
    
    [self addConstraints:@[loaderCenterY,loaderLeft,loaderHeight,loaderWidth]];
    
    
    NSLayoutConstraint * titleTop = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:(NSLayoutRelationEqual)
                                                                    toItem:self.titleLabel.superview
                                                                 attribute:(NSLayoutAttributeTop)
                                                                multiplier:1.0
                                                                  constant:0];
    
    
    NSLayoutConstraint * titleLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:(NSLayoutRelationEqual)
                                                                     toItem:self.titleLabel.superview
                                                                  attribute:(NSLayoutAttributeLeft)
                                                                 multiplier:1.0
                                                                   constant:0];
    
    NSLayoutConstraint * titleRight = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:(NSLayoutRelationEqual)
                                                                      toItem:self.titleLabel.superview
                                                                   attribute:(NSLayoutAttributeRight)
                                                                  multiplier:1.0
                                                                    constant:0];
    
    
    
    [self addConstraints:@[titleLeft,titleRight,titleTop]];
    
    
    NSLayoutConstraint * subTitleTop = [NSLayoutConstraint constraintWithItem:self.subTitleLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:(NSLayoutRelationEqual)
                                                                       toItem:self.titleLabel
                                                                    attribute:(NSLayoutAttributeBottom)
                                                                   multiplier:1.0
                                                                     constant:margin/2];
    
    NSLayoutConstraint * subTitleBottom = [NSLayoutConstraint constraintWithItem:self.subTitleLabel
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:(NSLayoutRelationEqual)
                                                                          toItem:self.subTitleLabel.superview
                                                                       attribute:(NSLayoutAttributeBottom)
                                                                      multiplier:1.0
                                                                        constant:0];
    
    NSLayoutConstraint * subTitleLeft = [NSLayoutConstraint constraintWithItem:self.subTitleLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:(NSLayoutRelationEqual)
                                                                        toItem:self.subTitleLabel.superview
                                                                     attribute:(NSLayoutAttributeLeft)
                                                                    multiplier:1.0
                                                                      constant:0];
    
    NSLayoutConstraint * subTitleRight = [NSLayoutConstraint constraintWithItem:self.subTitleLabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:(NSLayoutRelationEqual)
                                                                         toItem:self.subTitleLabel.superview
                                                                      attribute:(NSLayoutAttributeRight)
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    
    
    [self addConstraints:@[subTitleTop,subTitleLeft,subTitleRight,subTitleBottom]];
    
    
}

-(void)configureContentViewConstraint{
    if(self.superview){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:(NSLayoutRelationEqual)
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:(NSLayoutRelationEqual)
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:0]];
        
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:(NSLayoutRelationEqual)
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1.0
                                                                    constant:0.0]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:(NSLayoutRelationEqual)
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0]];
        
        [self removeConstraint:self.contentViewWidth];
        
        self.contentViewWidth = [NSLayoutConstraint constraintWithItem:self.contentView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:(NSLayoutRelationEqual)
                                                                toItem:self.contentView.superview
                                                             attribute:(NSLayoutAttributeWidth)
                                                            multiplier:0.75
                                                              constant:0.0];
        
        [self addConstraint:self.contentViewWidth];
        
        //        self.contentViewHeight = [NSLayoutConstraint constraintWithItem:self.contentView
        //                                                              attribute:NSLayoutAttributeHeight
        //                                                              relatedBy:(NSLayoutRelationEqual)
        //                                                                 toItem:self.contentView.superview
        //                                                              attribute:(NSLayoutAttributeHeight)
        //                                                             multiplier:1.0
        //                                                               constant:0];
        //        [self addConstraint:self.contentViewHeight];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
}

-(void)showWithCompletion:(void (^)(BOOL finished))completion{
    if(self.isHidden && self.alpha == 0){
        self.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            if(completion){
                completion(finished);
            }
        }];
    }
}

-(void)hideWithCompletion:(void (^)(BOOL finished))completion{
    // if(!self.isHidden && self.alpha == 1){
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if(completion){
            completion(finished);
        }
    }];
    //}
}


-(void)show{
    [self showWithCompletion:NULL];
}

-(void)hide{
    [self hideWithCompletion:NULL];
}

-(void)showLoaderInView:(UIView*)view{
    if(!self.superview){
        [view addSubview:self];
    }
    [self configureContentViewConstraint];
    [self showWithCompletion:NULL];
}

-(void)hideLoaderView{
    //    BOOL isHidden = self.isHidden;
    //    CGFloat alpha = self.alpha ;
    //if(!isHidden && alpha == 1){
    [self hideWithCompletion:^(BOOL finished) {
        if(_manager)
            [_manager hide:self];
        [self removeFromSuperview];
        _manager = nil;
    }];
    // }
}
-(void)showInWindow{
    _manager = [[SWLoaderViewWindow alloc] init];
    [_manager showView:self];
    [self showLoaderInView:nil];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [_titleLabel setText:title];
    [_titleLabel layoutIfNeeded];
}

-(void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    [_subTitleLabel setText:subTitle];
    [_subTitleLabel layoutIfNeeded];
}
-(void)layoutSubviews{
    [self.contentView layoutIfNeeded];
}
@end
