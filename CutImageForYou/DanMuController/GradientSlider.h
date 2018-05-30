//
//  XqSlider.h
//  ProgressBarWithColors
//
//  Created by 田相强 on 2017/12/23.
//  Copyright © 2017年 田相强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientSlider : UISlider
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSArray *colorLocationArray;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end
