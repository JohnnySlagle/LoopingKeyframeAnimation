//
//  ViewController.m
//  LoopingAnimation
//
//  Created by Johnny Slagle on 12/25/14.
//  Copyright (c) 2014 Johnny Slagle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSArray *points;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Points
    // Yes, this is a bit messy.
    self.points = @[[NSValue valueWithCGPoint:(CGPoint){self.view.bounds.size.width / 4, self.view.bounds.size.height / 4}],
                     [NSValue valueWithCGPoint:(CGPoint){(3 * self.view.bounds.size.width) / 4, self.view.bounds.size.height / 4}],
                     [NSValue valueWithCGPoint:(CGPoint){(3 *self.view.bounds.size.width) / 4, (3 * self.view.bounds.size.height) / 4}],
                     [NSValue valueWithCGPoint:(CGPoint){self.view.bounds.size.width / 4, (3 * self.view.bounds.size.height) / 4}],
                    [NSValue valueWithCGPoint:self.view.center]];
    
    // Create views at points
    self.views = [NSMutableArray array];
    for (NSValue *point in self.points) {
        [self viewAtCenter:[point CGPointValue]];
    }
    
    // Tap Gesture
    UITapGestureRecognizer *animateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateSquares)];
    [self.view addGestureRecognizer:animateTap];
}


// Note: Convenience method to add views to both the array and subview
- (void)viewAtCenter:(CGPoint)center {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 75.0, 75.0)];
    view.backgroundColor = [self randomColor];
    view.center = center;
    [self.view addSubview:view];
    [self.views addObject:view];
}


// Gesture Animation Method
- (void)animateSquares {
    CGFloat duration = 1.5;
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                              animations:^{
                                  for (NSUInteger i = 0; i < self.views.count; i++) {
                                      NSUInteger newIndex = arc4random() % self.views.count;
                                      UIView *view = self.views[i];
                                      CGPoint newPoint = [self.points[newIndex] CGPointValue];
                                      [UIView addKeyframeWithRelativeStartTime:0
                                                              relativeDuration:duration / self.views.count
                                                                    animations:^{
                                                                        view.center = newPoint;
                                                                    }];
                                  }
                              } completion:nil];
}


// From here: http://stackoverflow.com/a/3357312
- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

@end
