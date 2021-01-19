//
//  ColorSlider.m
//  ColorSlider
//
//  Created by WeiRuJian on 2021/1/16.
//

#import "ColorSlider.h"

#define COLOR_SLIDER_PADDING 10.0
#define COLOR_SLIDER_MARGIN 5.0

/// 滑块方向
typedef NS_ENUM(NSInteger, ColorSliderDirection) {
    ColorSliderDirectionVertical = 0, ///垂直
    ColorSliderDirectionHorizontal  /// 水平
};

@interface ColorSlider()

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIView *colorAreaView;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) ColorSliderDirection direction;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *sliderMaskView;

@property (nonatomic, strong) UIView *intensityView;
@property (nonatomic, assign) ColorSliderStyle style;
@end

@implementation ColorSlider

- (instancetype)initWithStyle:(ColorSliderStyle)style {
    self = [super init];
    if (self) {
        self.minValue = 0;
        self.maxValue = 360;
        self.padding = COLOR_SLIDER_PADDING;
        self.margin = COLOR_SLIDER_MARGIN;
        self.style = style;
        [self setupUI];
    }
    return self;
}

- (void)setStyle:(ColorSliderStyle)style {
    _style = style;
}
- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.maskView.hidden = !enable;
    self.sliderMaskView.hidden = !enable;
}

- (void)setupUI {
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.valueLabel.text = @"0°";
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.valueLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"HUE";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    
    
    self.colorAreaView = [[UIView alloc] init];
    self.colorAreaView.layer.cornerRadius = 8;
    self.colorAreaView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.colorAreaView];
    
    self.intensityView = [[UIView alloc] init];
    self.intensityView.layer.cornerRadius = 8;
    self.intensityView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.intensityView];
    
    self.maskView = [[UIView alloc] init];
    self.maskView.layer.cornerRadius = 8;
    self.maskView.hidden = YES;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:self.maskView];
    
    
    
    self.sliderView = [[UIView alloc] init];
    self.sliderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.sliderView.layer.cornerRadius = 4;
    self.sliderView.layer.borderWidth = 3;
    self.sliderView.backgroundColor = [UIColor colorWithHue:0 saturation:1 brightness:1 alpha:1];
    self.sliderView.layer.borderColor = UIColor.whiteColor.CGColor;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    [self.sliderView addGestureRecognizer:panGesture];
    [self addSubview:self.sliderView];
    
    self.sliderMaskView = [[UIView alloc] init];
    self.sliderMaskView.hidden = YES;
    self.sliderMaskView.layer.cornerRadius = 4;
    self.sliderMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:self.sliderMaskView];
    
    switch (self.style) {
        case ColorSliderStyleHUE:
            self.titleLabel.text = @"HUE";
            self.valueLabel.text = @"0°";
            self.sliderView.backgroundColor = [UIColor colorWithHue:0 saturation:1 brightness:1 alpha:1];
            self.minValue = 0;
            self.maxValue = 360;
            break;
        case ColorSliderStyleCCT:
            self.titleLabel.text = @"CCT";
            self.valueLabel.text = @"1600K";
            self.sliderView.backgroundColor = [self colorWithCCT:16];
            self.minValue = 16;
            self.maxValue = 100;
            break;
        case ColorSliderStyleINT:
            self.colorAreaView.backgroundColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            self.sliderView.backgroundColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1];
            self.intensityView.backgroundColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1];
            self.titleLabel.text = @"INT";
            self.valueLabel.text = @"0%";
            self.minValue = 0;
            self.maxValue = 100;
            break;
        case ColorSliderStyleGM:
            self.titleLabel.text = @"G/M";
            self.valueLabel.text = @"M1.0";
            self.sliderView.backgroundColor = [self colorWithGM:0];
            self.minValue = 0;
            self.maxValue = 20;
            break;
        default:
            break;
    }

}

-(void)drawRect:(CGRect)rect {
    
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    if (rect.size.width > rect.size.height) {
        /// 水平布局
        self.direction = ColorSliderDirectionHorizontal;
        self.maskView.frame = self.bounds;
        
    } else {
        /// 垂直布局
        self.direction = ColorSliderDirectionVertical;
        self.valueLabel.frame = CGRectMake(0, self.margin, w, 30);
        self.colorAreaView.frame = CGRectMake(3,
                                              CGRectGetMaxY(self.valueLabel.frame) + self.padding,
                                              w - 6,
                                              h - (30 + self.margin + self.padding) * 2);
        
        self.intensityView.frame = CGRectMake(CGRectGetMinX(self.colorAreaView.frame),
                                              CGRectGetMaxY(self.colorAreaView.frame),
                                              CGRectGetWidth(self.colorAreaView.frame),
                                              0);
        
        self.sliderView.frame = CGRectMake(0, CGRectGetMaxY(self.colorAreaView.frame)-10, w, 20);
        if (self.value) {
            
            CGFloat l = (self.maxValue - self.minValue) / CGRectGetHeight(self.colorAreaView.frame);
            CGFloat y =  (self.maxValue - self.value + CGRectGetMinY(self.colorAreaView.frame) + 10) / l;
            CGRect rect = self.sliderView.frame;
            rect.origin.y = y;
            self.sliderView.frame = rect;
            self.sliderMaskView.frame = self.sliderView.frame;
            
            CGRect intRect = self.intensityView.frame;
            intRect.origin.y = y;
            intRect.size.height = (h - self.margin - self.padding - 30) - y;
            self.intensityView.frame = intRect;
            
            
            [self setSliderOnValue:self.value atLocationY:y];
        }
        
        self.titleLabel.frame = CGRectMake(0, h - (self.margin + 30), w, 30);
        self.maskView.frame = self.colorAreaView.frame;
        self.sliderMaskView.frame = self.sliderView.frame;
        
        
        switch (self.style) {
            case ColorSliderStyleINT:
            
                break;
                
            default:
            {
                CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
                gradientLayer.frame = self.colorAreaView.bounds;
                
                if (self.style == ColorSliderStyleHUE) {
                    gradientLayer.colors = [self hueColors];
                }
                if (self.style == ColorSliderStyleCCT) {
                    gradientLayer.colors = [self cctColors];
                }
                if (self.style == ColorSliderStyleGM) {
                    gradientLayer.colors = [self gmColors];
                }
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint = CGPointMake(0, 1);
                gradientLayer.cornerRadius = 8;
                [self.colorAreaView.layer addSublayer:gradientLayer];
            }
                break;
        }
        
    }
    
    
}


- (void)panGestureHandler:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self];
    
    switch (self.direction) {
        case ColorSliderDirectionVertical:
        {
            /// 垂直布局滑动
            CGRect rect =  self.sliderView.frame;
            CGFloat y = location.y;
            if (y < self.colorAreaView.frame.origin.y - 10) {
                y = self.colorAreaView.frame.origin.y - 10;
            }
            if (y > CGRectGetMaxY(self.colorAreaView.frame) - 10) {
                y = CGRectGetMaxY(self.colorAreaView.frame) - 10;
            }
            
            rect.origin.y = y;
            self.sliderView.frame = rect;
            self.sliderMaskView.frame = self.sliderView.frame;
            
            /// 拖动中
            if (sender.state == UIGestureRecognizerStateChanged) {
                CGFloat offset = y - CGRectGetMinY(self.colorAreaView.frame) + 10;
                CGFloat scale = (self.maxValue - self.minValue) / CGRectGetHeight(self.colorAreaView.frame);
                NSInteger value = self.maxValue - offset * scale;
                
                [self setSliderOnValue:value atLocationY:y];
                
                if (self.delegate && [self.delegate conformsToProtocol:@protocol(ColorSliderDelegate)]) {
                    [self.delegate colorSliderDidChangedValue:value];
                }
            }
            
            /// 拖动结束
            if(sender.state == UIGestureRecognizerStateEnded) {
                switch (self.style) {
                    case ColorSliderStyleHUE:
                    {
                        CGFloat offset = y - CGRectGetMinY(self.colorAreaView.frame) + 10;
                        CGFloat l = (self.maxValue - self.minValue) / CGRectGetHeight(self.colorAreaView.frame);
                        NSInteger degree = self.maxValue - offset * l;
                        
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ColorSliderDelegate)]) {
                            [self.delegate colorSliderDidChangedOutputValue:degree];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
        }
            break;
            
        default:
        {
            
        }
            break;
    }
}

- (void)setSliderOnValue:(NSInteger)value atLocationY:(CGFloat)y {
    switch (self.style) {
        case ColorSliderStyleHUE:
        {
            
            self.valueLabel.text = [NSString stringWithFormat:@"%lu°",value];
            self.sliderView.backgroundColor = [UIColor colorWithHue:value/360.0 saturation:1 brightness:1 alpha:1];
            
            break;
        }
        case ColorSliderStyleCCT:
        {
            self.valueLabel.text = [NSString stringWithFormat:@"%dK",(int)value * 100];
            self.sliderView.backgroundColor = [self colorWithCCT:(int)value];
            break;
        }
        case ColorSliderStyleGM:
        {
            if (value < 10) {
                self.valueLabel.text = [NSString stringWithFormat:@"M%.1f",1 - fabs(value/10.0)];
            } else if (value > 10) {
                self.valueLabel.text = [NSString stringWithFormat:@"G%.1f",fabs(value/10.0) - 1];
            } else {
                self.valueLabel.text = @"0.0";
            }
            self.sliderView.backgroundColor = [self colorWithGM:value];
            break;
        }
        case ColorSliderStyleINT:
        {
            self.valueLabel.text = [NSString stringWithFormat:@"%lu%@",value, @"%"];
            CGRect rect = self.intensityView.frame;
            rect.origin.y = y;
            rect.size.height = (self.bounds.size.height - self.margin - self.padding - 30) - y;
            self.intensityView.frame = rect;
            break;
        }
        default:
            break;
    }
}

- (NSArray *)hueColors {
    return @[(id)[UIColor colorWithRed:1.0 green:0 blue:0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:1.0 green:0 blue:128.0/255.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor,
             (id)[UIColor colorWithRed:128.0/255.0 green:0 blue:1.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0].CGColor,
             (id)[UIColor colorWithRed:0 green:128.0/255.0 blue:1.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0 green:1.0 blue:1.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0 green:1.0 blue:128.0/255.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0 green:1.0 blue:0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:128.0/255.0 green:1.0 blue:0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:1.0 green:128.0/255.0 blue:0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:1.0 green:0 blue:0 alpha:1].CGColor];
}

- (NSArray *)cctColors {
    return @[(id)[UIColor colorWithRed:128.0/255.0 green:228.0/255.0 blue:254.0/255.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:254.0/255.0 green:200.0/255.0 blue:64.0/255.0 alpha:1].CGColor];
}

- (NSArray *)gmColors {
    return @[(id)[UIColor colorWithRed:1.0 green:0 blue:207.0/255.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1].CGColor,
             (id)[UIColor colorWithRed:0.0 green:1.0 blue:0 alpha:1].CGColor];
}

- (UIColor *)colorWithCCT:(NSInteger)cct {
    CGFloat center = (self.maxValue - self.minValue)/2.0;
    if (cct < center) {
        CGFloat k = 1.0*(cct-self.minValue)/(center - self.minValue);
        CGFloat red = (254 + k * (255-254))/255.0;
        CGFloat green = (200 + k * (255-200))/255.0;
        CGFloat blue = (64 + k * (255-64))/255.0;;
        return  [UIColor colorWithRed:red green:green blue:blue alpha:1];
    } else {
        CGFloat k = 1.0*(cct - center)/(self.maxValue - center);
        CGFloat red = (255 - k * (255-128))/255.0;;
        CGFloat green = (255 - k * (255-228))/255.0;
        CGFloat blue =  1;
        return  [UIColor colorWithRed:red green:green blue:blue alpha:1];
    }
}

- (UIColor *)colorWithGM:(NSInteger)gm {
    CGFloat center = (self.maxValue - self.minValue)/2.0;
    if (gm < center) {
        CGFloat k = 1.0*(gm-self.minValue)/(center - self.minValue);
        CGFloat red = (0 + k * (255-0))/255.0;
        CGFloat green = (255 + k * (255-255))/255.0;
        CGFloat blue = (0 + k * (255-0))/255.0;;
        return  [UIColor colorWithRed:red green:green blue:blue alpha:1];
    } else {
        CGFloat k = 1.0*(gm - center)/(self.maxValue - center);
        CGFloat red = (255 - k * (255-255))/255.0;;
        CGFloat green = (255 - k * (255-0))/255.0;
        CGFloat blue =  (255 - k * (255-207))/255.0;;
        return  [UIColor colorWithRed:red green:green blue:blue alpha:1];
    }
}


@end
