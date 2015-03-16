//
//  SWLinearLoaderView.m
//  SmartMSBusiness
//
//  Created by Bacem on 12/03/2015.
//  Copyright (c) 2015 streamwide. All rights reserved.
//

#import "SWLinearLoaderView.h"
#define leftMargin 10.0
#define margin 5.0
#define animationDuration 0.6
#define laderHeight 3.0
typedef enum {
    SWLinearLoaderViewWindowAnimationFade,
    SWLinearLoaderViewWindowAnimationFlipFlop
}SWLinearLoaderViewWindowAnimation;
@interface SWLinearLoaderViewWindow ()
@property (nonatomic,strong) UIWindow *  previousKeyWindow;
-(void)showView:(UIView*)view;
@end
@implementation SWLinearLoaderViewWindow
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
@interface SWLinearLoaderView (){
    CAShapeLayer *pathLayer;
    NSInteger status;
}
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * labelsView;
@property (nonatomic,strong) UIView * loaderView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subTitleLabel;
@property (nonatomic,strong) NSLayoutConstraint * contentViewWidth;
@property (nonatomic,strong) NSLayoutConstraint * contentViewHeight;
@property (nonatomic,strong) SWLinearLoaderViewWindow * manager;
@property (nonatomic,assign) SWLinearLoaderViewWindowAnimation loaderAnimation;
@end
@implementation SWLinearLoaderView
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
    self.loaderAnimation = SWLinearLoaderViewWindowAnimationFlipFlop;
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
    
    self.loaderView = [[UIView alloc] init];
    self.loaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.loaderView];
    self.loaderView.backgroundColor = [UIColor clearColor];
    
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
                                                                         constant:-leftMargin];
    NSLayoutConstraint * labelsViewBottom = [NSLayoutConstraint constraintWithItem:self.labelsView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:(NSLayoutRelationEqual)
                                                                            toItem:self.loaderView
                                                                         attribute:(NSLayoutAttributeTop)
                                                                        multiplier:1.0
                                                                          constant:-2*margin];
    
    
    
    NSLayoutConstraint * labelsViewLeft = [NSLayoutConstraint constraintWithItem:self.labelsView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:(NSLayoutRelationEqual)
                                                                          toItem:self.labelsView.superview
                                                                       attribute:(NSLayoutAttributeLeft)
                                                                      multiplier:1.0
                                                                        constant:leftMargin];
    
    [self addConstraints:@[labelsViewRight,labelsViewLeft,labelsViewBottom,labelsViewTop]];
    
    
    
    
    
    
    
    NSLayoutConstraint * loaderViewHeight = [NSLayoutConstraint constraintWithItem:self.loaderView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:(NSLayoutRelationEqual)
                                                                            toItem:self.loaderView.superview
                                                                         attribute:(NSLayoutAttributeHeight)
                                                                        multiplier:0.0
                                                                          constant:laderHeight];
    
    NSLayoutConstraint * loaderViewRight = [NSLayoutConstraint constraintWithItem:self.loaderView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:(NSLayoutRelationEqual)
                                                                           toItem:self.loaderView.superview
                                                                        attribute:(NSLayoutAttributeRight)
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    NSLayoutConstraint * loaderViewLeft = [NSLayoutConstraint constraintWithItem:self.loaderView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:(NSLayoutRelationEqual)
                                                                          toItem:self.loaderView.superview
                                                                       attribute:(NSLayoutAttributeLeft)
                                                                      multiplier:1.0
                                                                        constant:0.0];
    
    NSLayoutConstraint * loaderViewBottom = [NSLayoutConstraint constraintWithItem:self.loaderView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:(NSLayoutRelationEqual)
                                                                            toItem:self.loaderView.superview
                                                                         attribute:(NSLayoutAttributeBottom)
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    
    
    
    [self addConstraints:@[loaderViewHeight,loaderViewRight,loaderViewBottom,loaderViewLeft]];
    
    
    
    
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
    [self flipFlop];
}

- (void)flipFlop {
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIColor * color;
    switch (status) {
        case 0:
            color = [UIColor blueColor];
            [path moveToPoint:CGPointMake(0,self.loaderView.frame.size.height-5)];
            [path addLineToPoint:CGPointMake(self.loaderView.frame.size.width,self.loaderView.frame.size.height-5)];
            break;
        case 1:
            color = [UIColor blackColor];
            [path moveToPoint:CGPointMake(0,self.loaderView.frame.size.height-5)];
            [path addLineToPoint:CGPointMake(self.loaderView.frame.size.width,self.loaderView.frame.size.height-5)];
            break;
        case 2:
            color = [UIColor blueColor];
            if(self.loaderAnimation == SWLinearLoaderViewWindowAnimationFlipFlop){
                [path moveToPoint:CGPointMake(self.loaderView.frame.size.width,self.loaderView.frame.size.height-5)];
                [path addLineToPoint:CGPointMake(0,self.loaderView.frame.size.height-5)];
            }else{
                [path moveToPoint:CGPointMake(0,self.loaderView.frame.size.height-5)];
                [path addLineToPoint:CGPointMake(self.loaderView.frame.size.width,self.loaderView.frame.size.height-5)];
            }
            
            //
            break;
        case 3:
            color = [UIColor blackColor];
            if(self.loaderAnimation == SWLinearLoaderViewWindowAnimationFlipFlop){
                [path moveToPoint:CGPointMake(self.loaderView.frame.size.width,self.loaderView.frame.size.height-5)];
                [path addLineToPoint:CGPointMake(0,self.loaderView.frame.size.height-5)];
            }else{
                [path moveToPoint:CGPointMake(0,self.loaderView.frame.size.height-5)];
                [path addLineToPoint:CGPointMake(self.loaderView.frame.size.width,self.loaderView.frame.size.height-5)];
            }
            break;
        default:
            break;
    }
    
    pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.loaderView.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [color CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = laderHeight;
    pathLayer.lineJoin = kCALineJoinRound;
    pathLayer.strokeEnd = 10;

    [pathLayer setFillRule:kCALineJoinMiter];
    [self.loaderView.layer addSublayer:pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.delegate = self;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.duration = animationDuration;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[pathAnimation];
    animation.duration = animationDuration;
    animation.delegate=self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [pathLayer addAnimation:animation forKey:nil];
    
    status ++;
    
    if(status == 4){
        status = 0;
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(flipFlop) userInfo:nil repeats:NO];
    //[self flipFlop];
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
    _manager = [[SWLinearLoaderViewWindow alloc] init];
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
