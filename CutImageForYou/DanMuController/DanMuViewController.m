//
//  DanMuViewController.m
//  CutImageForYou
//
//  Created by chenxi on 2018/5/25.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "DanMuViewController.h"
#import "XMAutoScrollTextView.h"
#import "GradientSlider.h"
#import "SettingViewController.h"
#import <StoreKit/StoreKit.h>

@interface DanMuViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)XMAutoScrollTextView *lableView;

@property(nonatomic,strong)UIView *setView;
@property(nonatomic,strong)UISlider *fontSizeSlider;
@property(nonatomic,strong)GradientSlider *labelColorSlider;
@property(nonatomic,strong)GradientSlider *bgColorSlider;
@property(nonatomic,strong)UISlider * speedSlider;

@property(nonatomic,strong)UITextField * inputTextField;
@property(nonatomic,strong)UIView * textFieldView;
@property(nonatomic,strong)UIButton * setBtn;

@property(nonatomic,assign)BOOL  textFieldIsShow;
@property(nonatomic,assign)BOOL  setViewIsShow;

@property(nonatomic,strong)UIButton *cuBtn;
@property(nonatomic,strong)UIButton *xiBtn;


@end

@implementation DanMuViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    self.navigationController.navigationBar.hidden = YES;
    [self ceateView];
    [self createSetView];
    [self createTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.textFieldIsShow = YES;
    self.setViewIsShow = NO;
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTextField)];
    [self.view addGestureRecognizer:tapRecognize];
    _nowFontName = @"HeiTi SC";
    _nowFontSize = 90;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;

}

- (void)showAppStoreReView{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    
    //仅支持iOS10.3+（需要做校验） 且每个APP内每年最多弹出3次评分alart
    
    if ([systemVersion doubleValue] > 10.3) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
            //防止键盘遮挡
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }
    }
}

- (void)hiddenTextField{
    if (self.textFieldIsShow) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.textFieldView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kAUTOHEIGHT(60));
        } completion:nil];
        self.textFieldIsShow = NO;
    }else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.textFieldView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kAUTOHEIGHT(60));
            self.textFieldView.frame = CGRectMake(0, ScreenHeight - kAUTOHEIGHT(60), ScreenWidth, kAUTOHEIGHT(60));
        } completion:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.setView.alpha  = 0;
        }];
        self.textFieldIsShow = YES;
    }
    
}
- (void)createTextField{
    self.textFieldView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - kAUTOHEIGHT(60), ScreenWidth, kAUTOHEIGHT(60))];
    [self.view addSubview:self.textFieldView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, kAUTOHEIGHT(60))];
    [self.textFieldView addSubview:bgView];
    bgView.alpha = 0.1;
    bgView.backgroundColor = [UIColor blackColor];
//   bgView.layer.cornerRadius = kAUTOHEIGHT(25);

    self.inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), 0, ScreenWidth - kAUTOWIDTH(80), kAUTOHEIGHT(44))];
    [self.textFieldView addSubview:self.inputTextField];
    self.inputTextField.returnKeyType =UIReturnKeyDone;
    self.inputTextField.delegate = self;
//    self.inputTextField.backgroundColor = [UIColor redColor];
    self.inputTextField.placeholder = @"请输入......";
    self.inputTextField.textColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(45), ScreenWidth - kAUTOWIDTH(40), 0.5)];
    [self.textFieldView addSubview:lineView];
    lineView.alpha = 0.8;
    lineView.backgroundColor = [UIColor whiteColor];
    
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setBtn.frame = CGRectMake(CGRectGetMaxX(self.inputTextField.frame) + kAUTOWIDTH(10), kAUTOHEIGHT(9.5), kAUTOWIDTH(25), kAUTOHEIGHT(25));
    [self.setBtn setImage:[UIImage imageNamed:@"主页-设置.png"] forState:UIControlStateNormal];
    [self.textFieldView addSubview:self.setBtn];
    [self.setBtn addTarget:self action:@selector(hiddenSetView) forControlEvents:UIControlEventTouchUpInside];
    
    if (PNCisIPAD) {
        self.setBtn.frame = CGRectMake(CGRectGetMaxX(self.inputTextField.frame) + kAUTOWIDTH(10), kAUTOHEIGHT(44)/2 - 12.5, 25, 25);
    }
}

- (void)hiddenSetView{
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstText"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstText"];
        //第一次启动
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAppStoreReView];
        });
    }else{
        //不是第一次启动了
    }
    
    [self.inputTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.textFieldView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kAUTOHEIGHT(60));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.setView.alpha = 1;
            self.textFieldIsShow = NO;
        }];
    }];
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.inputTextField]) {
        [self.inputTextField resignFirstResponder];
        self.lableView.textString = self.inputTextField.text;
        self.lableView.textLabel.text = self.lableView.jingZhiTextLabel.text = self.inputTextField.text;
    }
    return YES;
}

- (void)keybardWillChangeFrame:(NSNotification *)note
{
    NSLog(@"%@",note);
    CGFloat keyboardH  = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat ScreenH = [UIScreen mainScreen].bounds.size.height;
//    self.bottomContrain.constant = ScreenH - keyboardH;
    self.textFieldView.frame = CGRectMake(0, keyboardH - kAUTOHEIGHT(60), ScreenWidth, kAUTOHEIGHT(60));
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}




-(void)createSetView{
    
    self.setView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.setView.backgroundColor =  PNCColorWithHexA(0x000000, 0.5);
    [self.view addSubview:self.setView];
    self.setView.alpha = 0;
    
    UIView *setFatherView =  [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - kAUTOHEIGHT(450), ScreenWidth, kAUTOHEIGHT(450))];
    setFatherView.backgroundColor =  PNCColorWithHexA(0x000000, 0);
    [self.setView addSubview:setFatherView];
    
    UIView *setFatherMaskView =  [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), 0, ScreenWidth - kAUTOWIDTH(40), kAUTOHEIGHT(430))];
    setFatherMaskView.backgroundColor = [UIColor blackColor];
    setFatherMaskView.alpha = 0.3;
    setFatherMaskView.layer.cornerRadius = 12;
    [setFatherView addSubview:setFatherMaskView];
    
    

    
    UILabel *fontSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(20) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(25))];
    [setFatherView addSubview:fontSizeLabel];
    fontSizeLabel.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    fontSizeLabel.text = @"字体大小";
    fontSizeLabel.textColor = [UIColor whiteColor];
    
    _fontSizeSlider = [ [ UISlider alloc ] initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(40) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(40)) ];//高度设为40就好,高度代表手指触摸的高度.这个一定要注意
    _fontSizeSlider.minimumValue = 0.0;//下限
    if (PNCisIPAD) {
        _fontSizeSlider.maximumValue = 450.0;//上限

    }else{
        _fontSizeSlider.maximumValue = 280.0;//上限

    }
    _fontSizeSlider.value = 22.0;//开始默认值
    _fontSizeSlider.minimumTrackTintColor = [UIColor whiteColor];
    _fontSizeSlider.maximumTrackTintColor = [UIColor blackColor];
//    _fontSizeSlider.backgroundColor =[UIColor redColor];//测试用,
    [_fontSizeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    _fontSizeSlider.continuous = NO;//当放开手., 值才确定下来
    [ setFatherView addSubview:_fontSizeSlider];

    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_fontSizeSlider.frame) - kAUTOWIDTH(25), CGRectGetMinY(_fontSizeSlider.frame) + kAUTOHEIGHT(12.5), kAUTOWIDTH(15), kAUTOHEIGHT(15))];
    [setFatherView addSubview:leftImageView];
    leftImageView.image = [UIImage imageNamed:@"字体1.png"];
   
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_fontSizeSlider.frame) + kAUTOWIDTH(10), CGRectGetMinY(_fontSizeSlider.frame) + kAUTOHEIGHT(7.5), kAUTOWIDTH(25), kAUTOHEIGHT(25))];
    [setFatherView addSubview:rightImageView];
    rightImageView.image = [UIImage imageNamed:@"字体1.png"];
    
    if (PNCisIPAD) {
        leftImageView.frame =CGRectMake(CGRectGetMinX(_fontSizeSlider.frame) -25, CGRectGetMinY(_fontSizeSlider.frame) + kAUTOHEIGHT(40)/2 - 7.5, 15, 15);
        rightImageView.frame = CGRectMake(CGRectGetMaxX(_fontSizeSlider.frame) + 10, CGRectGetMinY(_fontSizeSlider.frame) + kAUTOHEIGHT(40)/2 - 12.5, 25, 25);
    
    }
    
    UILabel *labelColorLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(80) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(25))];
    [setFatherView addSubview:labelColorLabel];
    labelColorLabel.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    labelColorLabel.text = @"字体颜色";
    labelColorLabel.textColor = [UIColor whiteColor];
    
    
    _labelColorSlider = [[ GradientSlider alloc ] initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(100) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(40)) ];//高度设为40就好,高度代表手指触摸的高度.这个一定要注意
//    _labelColorSlider.minimumValue = 0.0;//下限
//    _labelColorSlider.maximumValue = 250.0;//上限
    _labelColorSlider.value = 1;//开始默认值
//    _labelColorSlider.backgroundColor =[UIColor redColor];//测试用,
    [_labelColorSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //    _fontSizeSlider.continuous = NO;//当放开手., 值才确定下来
    [setFatherView addSubview:_labelColorSlider];
    
    UILabel *bgColorLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(140) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(25))];
    [setFatherView addSubview:bgColorLabel];
    bgColorLabel.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    bgColorLabel.text = @"背景颜色";
    bgColorLabel.textColor = [UIColor whiteColor];
    
    _bgColorSlider = [[ GradientSlider alloc ] initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(160) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(40)) ];//高度设为40就好,高度代表手指触摸的高度.这个一定要注意
    //    _labelColorSlider.minimumValue = 0.0;//下限
    //    _labelColorSlider.maximumValue = 250.0;//上限
    _bgColorSlider.value = 1;//开始默认值
//    _bgColorSlider.backgroundColor =[UIColor redColor];//测试用,
    [_bgColorSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //    _fontSizeSlider.continuous = NO;//当放开手., 值才确定下来
    [setFatherView addSubview:_bgColorSlider];
    
    
    UILabel *speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(200) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(25))];
    [setFatherView addSubview:speedLabel];
    speedLabel.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    speedLabel.text = @"速度大小";
    speedLabel.textColor = [UIColor whiteColor];
    
    _speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(220) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(40))];//高度设为40就好,高度代表手指触摸的高度.这个一定要注意
    _speedSlider.minimumValue = 0.0;//下限
    _speedSlider.maximumValue = 16.0;//上限
    _speedSlider.value = 1.0;//开始默认值
    _speedSlider.minimumTrackTintColor = [UIColor whiteColor];
    _speedSlider.maximumTrackTintColor = [UIColor blackColor];
//    _speedSlider.backgroundColor =[UIColor redColor];//测试用,
    [_speedSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //    _fontSizeSlider.continuous = NO;//当放开手., 值才确定下来
    [setFatherView addSubview:_speedSlider];
    
    UILabel *fontLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(60), kAUTOHEIGHT(260) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(45))];
    [setFatherView addSubview:fontLabel];
    fontLabel.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    fontLabel.text = @"字体样式";
    fontLabel.numberOfLines = 0;
    fontLabel.textColor = [UIColor whiteColor];
    
    _cuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cuBtn.frame = CGRectMake(kAUTOWIDTH(60), ScreenHeight -  kAUTOHEIGHT(450) + kAUTOHEIGHT(300) , kAUTOWIDTH(30) ,kAUTOHEIGHT(30));
    [_cuBtn setTitle: @"粗体" forState:UIControlStateNormal];
    [_cuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cuBtn.titleLabel.font = [UIFont fontWithName:@"HeiTi SC" size:13];
    _cuBtn.backgroundColor = PNCColorWithHexA(0x000000, 0.5);
    _cuBtn.layer.cornerRadius = kAUTOHEIGHT(15);
    _cuBtn.layer.masksToBounds = YES;
    [self.setView addSubview:_cuBtn];
    [_cuBtn addTarget:self action:@selector(changeToCu) forControlEvents:UIControlEventTouchUpInside];
    _cuBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _xiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _xiBtn.frame = CGRectMake(kAUTOWIDTH(60) + kAUTOWIDTH(50), ScreenHeight -  kAUTOHEIGHT(450) + kAUTOHEIGHT(300) , kAUTOWIDTH(30) ,kAUTOHEIGHT(30));
    [_xiBtn setTitle: @"细体" forState:UIControlStateNormal];
    [_xiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _xiBtn.titleLabel.font = [UIFont fontWithName:@"HeiTi SC" size:13];
    _xiBtn.backgroundColor = PNCColorWithHexA(0x000000, 0.5);
    _xiBtn.layer.cornerRadius = kAUTOHEIGHT(15);
    _xiBtn.layer.masksToBounds = YES;
    [self.setView addSubview:_xiBtn];
    [_xiBtn addTarget:self action:@selector(changeToXi) forControlEvents:UIControlEventTouchUpInside];
    _xiBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _xiBtn.layer.borderWidth = 1;
    
    
    UILabel *moreFontLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(60), ScreenHeight -  kAUTOHEIGHT(450) + kAUTOHEIGHT(300) + kAUTOHEIGHT(40) ,ScreenWidth - kAUTOWIDTH(120) ,kAUTOHEIGHT(45))];
    [self.setView addSubview:moreFontLabel];
    moreFontLabel.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    moreFontLabel.text = @"更多字体样式，尽请期待......";
    moreFontLabel.numberOfLines = 0;
    moreFontLabel.textColor = [UIColor whiteColor];

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(setFatherMaskView.frame.size.width - kAUTOWIDTH(40), setFatherMaskView.frame.size.height - kAUTOHEIGHT(40), kAUTOWIDTH(25), kAUTOHEIGHT(25));
    [sureBtn setImage:[UIImage imageNamed:@"保存"] forState:UIControlStateNormal];
    [setFatherMaskView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(hiddenFaterView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutBtn.frame = CGRectMake(kAUTOWIDTH(15), setFatherMaskView.frame.size.height - kAUTOHEIGHT(40), kAUTOWIDTH(25), kAUTOHEIGHT(25));
    [aboutBtn setImage:[UIImage imageNamed:@"关于"] forState:UIControlStateNormal];
    [setFatherMaskView addSubview:aboutBtn];
    [aboutBtn addTarget:self action:@selector(presentAboutMeController:) forControlEvents:UIControlEventTouchUpInside];

    if (PNCisIPAD) {
        aboutBtn.frame = CGRectMake(15, setFatherMaskView.frame.size.height - 40, 25,25);
         sureBtn.frame = CGRectMake(setFatherMaskView.frame.size.width - 40, setFatherMaskView.frame.size.height - 40, 25,25);
    }
    
}

- (void)changeToXi{
    _cuBtn.layer.borderWidth = 0;
    _lableView.textLabel.font = [UIFont fontWithName:@"HeiTi SC" size:_nowFontSize];
    _xiBtn.layer.borderWidth = 1;
    _nowFontName =@"HeiTi SC";
    _lableView.jingZhiTextLabel.font = [UIFont fontWithName:@"HeiTi SC" size:_nowFontSize];


}
- (void)changeToCu{
    _cuBtn.layer.borderWidth = 1;
    _lableView.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:_nowFontSize];
    _xiBtn.layer.borderWidth = 0;
    _nowFontName =@"Helvetica-Bold";
    _lableView.jingZhiTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:_nowFontSize];
}
//-(void)changeToFaGuang{
//    uivi
//}



- (void)presentAboutMeController:(UIButton *)sender{
    
    // 先缩小
    sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        sender.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
    SettingViewController *aVc = [[SettingViewController alloc]init];
    [self presentViewController:aVc animated:YES completion:nil];
}

- (void)hiddenFaterView{
    [UIView animateWithDuration:0.3 animations:^{
        self.setView.alpha = 0;
    } completion:^(BOOL finished) {
//        [self.setView removeFromSuperview];
    }];
}

-(void)sliderValueChanged:(UISlider *)paramSender{
    if ([paramSender isEqual:self.fontSizeSlider]) {
        NSLog(@"New value=%f",paramSender.value);
        self.lableView.textLabel.font = [UIFont fontWithName:_nowFontName size:paramSender.value];
        self.lableView.fontOfSize = paramSender.value;
        [self.lableView layoutSubviews];
        _nowFontSize = paramSender.value;
        
        self.lableView.jingZhiTextLabel.font =  [UIFont fontWithName:_nowFontName size:paramSender.value];
    }
    
    if ([paramSender isEqual:self.labelColorSlider]) {
        NSLog(@"New value=======%f",paramSender.value);
        
        CGPoint  point=CGPointMake(paramSender.frame.size.width*paramSender.value, 1
                                   );
        UIColor* color=[self colorOfPoint:point];
        if (paramSender.value<0.99999) {
            self.lableView.textLabel.textColor = color;
            self.lableView.jingZhiTextLabel.textColor = color;

        }
        
    }
    if ([paramSender isEqual:self.bgColorSlider]) {
        NSLog(@"New value=======%f",paramSender.value);
        
        CGPoint  point=CGPointMake(paramSender.frame.size.width*paramSender.value, 1
                                   );
        UIColor* color=[self colorOfPoint:point];
        if (paramSender.value<0.99) {
            self.lableView.backgroundColor = color;
        }
        
    }
    
    if ([paramSender isEqual:self.speedSlider]) {
        NSLog(@"New value=======%f",paramSender.value);
            self.lableView.displayLinkDistance = paramSender.value;
        
        if (paramSender.value < 0.3) {
            self.lableView.displayLinkDistance = 0;
            self.lableView.contentSize = CGSizeMake(ScreenHeight, ScreenWidth);
            self.lableView.contentOffset = CGPointMake(ScreenHeight, 0);
            
            self.lableView.textLabel.hidden = YES;
            self.lableView.jingZhiTextLabel.hidden = NO;
//            self.lableView.textLabel.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//            self.lableView.textLabel.adjustsFontSizeToFitWidth=YES;
//            self.lableView.textLabel.numberOfLines = 0;
//            self.lableView.textLabel.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
        }else{
            self.lableView.textLabel.hidden = NO;
            self.lableView.jingZhiTextLabel.hidden = YES;
        }
        }
        
    
}
- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [_labelColorSlider.gradientLayer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return color;
}

- (void)ceateView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenWidth)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.bgView];
    
    self.lableView = [[XMAutoScrollTextView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenWidth) WithText:@"林深时见鹿，海蓝时见鲸，梦醒时见你。" WithTextColor:[UIColor blackColor]];
    self.lableView.fontOfSize = 90;
    self.lableView.displayLinkDistance  = 2;
    [self.bgView addSubview:self.lableView];
 
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI_2);
    self.bgView.center = self.view.center;
    self.bgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.bgView setTransform:transform];
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.lableView.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
