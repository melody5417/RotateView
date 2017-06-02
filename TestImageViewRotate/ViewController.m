//
//  ViewController.m
//  TestImageViewRotate
//
//  Created by yiqiwang(王一棋) on 2017/6/1.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define AnimationDuration 0.5
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()<CAAnimationDelegate>
@property (weak) IBOutlet NSImageView *imageView;
@property (nonatomic, strong) CABasicAnimation *rotateAnimation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    [self.imageView setWantsLayer:YES];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onZoomin:(id)sender {
    // setFrameCenterRotation只是更改了imageView的origin Size还是原宽高比 所以计算zoom会有问题
    // 先 save Rotation 然后reset Rotation 更新frame 再restore Rotation
//    CGFloat degrees = self.imageView.frameRotation;
//
//    [self.imageView setFrameCenterRotation:0];
//    [self.imageView setFrame:NSMakeRect(newImageViewOrigin.x,
//                                        newImageViewOrigin.y,
//                                        newImageViewSize.width,
//                                        newImageViewSize.height)];
//    [self.imageView setFrameCenterRotation:degrees];
}

- (IBAction)onZoomout:(id)sender {
    NSLog(@"zoomout layer:%@ imageView%@", self.imageView.layer, NSStringFromRect(self.imageView.frame));
}

- (IBAction)onRotate:(id)sender {

    if ([self.imageView.layer animationKeys]) {
        return ;
    }

    NSLog(@"1anchorPoint:%@", NSStringFromPoint(self.imageView.layer.anchorPoint));
    NSRect imageLayerFrame = self.imageView.layer.frame;
    CGPoint center = CGPointMake(imageLayerFrame.origin.x + imageLayerFrame.size.width * 0.5,
                                 imageLayerFrame.origin.y + imageLayerFrame.size.height * 0.5);
    self.imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.imageView.layer.position = center;
    NSLog(@"2anchorPoint:%@", NSStringFromPoint(self.imageView.layer.anchorPoint));


    [self.imageView.layer addAnimation:self.rotateAnimation forKey:@"rotate"];
}

- (CABasicAnimation *)rotateAnimation {
    float fromDegrees = self.imageView.frameRotation;
    float toDegrees = self.imageView.frameRotation + 90;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = AnimationDuration;
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(fromDegrees)];
    animation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(toDegrees)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    return animation;
}

- (void)animationDidStart:(CAAnimation *)anim {

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        NSLog(@"3anchorPoint:%@", NSStringFromPoint(self.imageView.layer.anchorPoint));
        float degrees = self.imageView.frameRotation + 90;
        [self.imageView setFrameCenterRotation:degrees];

        NSLog(@"4anchorPoint:%@", NSStringFromPoint(self.imageView.layer.anchorPoint));
        [self.imageView.layer removeAllAnimations];
    }
}

@end
