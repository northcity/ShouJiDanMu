//
//  XqSlider.m
//  ProgressBarWithColors
//
//  Created by 田相强 on 2017/12/23.
//  Copyright © 2017年 田相强. All rights reserved.
//

#import "GradientSlider.h"
//#import "UIColor+Extensions.h"
@implementation GradientSlider

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self normalSettings];
        [self loadGradientLayers];
    }
    return self;
}
-(void)normalSettings{
    self.minimumTrackTintColor=[UIColor clearColor];
    self.maximumTrackTintColor=[UIColor clearColor];
}
-(void)loadGradientLayers{
   self.colorArray = @[(id)[[UIColor blackColor] CGColor],(id)[[UIColor blackColor] CGColor],
                       (id)[[UIColor blueColor] CGColor],
                      (id)[[UIColor yellowColor] CGColor],
                       (id)[[UIColor redColor] CGColor],
                       (id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor]];
   self.colorLocationArray = @[@0,@0.2, @0.4,@0.5,@0.6,@0.8,@1];
    self.gradientLayer =  [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0,self.frame.size.height/2 -2.5,self.frame.size.width,2);
    self.gradientLayer.masksToBounds = YES;
    self.gradientLayer.cornerRadius = 1;
    [self.gradientLayer setLocations:self.colorLocationArray];
    [self.gradientLayer setColors:self.colorArray];
    [self.gradientLayer setStartPoint:CGPointMake(0, 0)];
    [self.gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.layer addSublayer:self.gradientLayer];
}
@end
