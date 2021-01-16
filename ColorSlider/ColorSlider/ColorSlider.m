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

- (void)setValue:(NSInteger)value {
    _value = value;
    
    switch (self.style) {
        case ColorSliderStyleHUE:
            self.valueLabel.text = [NSString stringWithFormat:@"%lu°",value];
            self.sliderView.backgroundColor = [UIColor colorWithHue:value/360.0 saturation:1 brightness:1 alpha:1];
            CGFloat l = (self.maxValue - self.minValue) / CGRectGetHeight(self.colorAreaView.frame);
            CGFloat y =  (self.maxValue - value + CGRectGetMinY(self.colorAreaView.frame) + 10) / l;
            CGRect rect = self.sliderView.frame;
            rect.origin.y = y;
            self.sliderView.frame = rect;
            self.sliderMaskView.frame = self.sliderView.frame;
            break;
            
        default:
            break;
    }
    
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
    self.colorAreaView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.colorAreaView];
    
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
            self.minValue = 0;
            self.maxValue = 360;
            break;
        case ColorSliderStyleCCT:
            self.titleLabel.text = @"CCT";
            self.minValue = 16;
            self.maxValue = 100;
            break;
        case ColorSliderStyleINT:
            self.titleLabel.text = @"INT";
            self.minValue = 0;
            self.maxValue = 100;
            break;
        case ColorSliderStyleGM:
            self.titleLabel.text = @"G/M";
            self.minValue = -10;
            self.maxValue = 10;
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
        self.colorAreaView.frame = CGRectMake(3, CGRectGetMaxY(self.valueLabel.frame) + self.padding, w - 6, h - (30 + self.margin + self.padding) * 2);
        
        if (self.value) {
            CGFloat l = (self.maxValue - self.minValue) / CGRectGetHeight(self.colorAreaView.frame);
            CGFloat y = self.value / l;
            CGRect r = CGRectMake(0, CGRectGetMaxY(self.colorAreaView.frame)-10, w, 20);
            r.origin.y = y;
            self.sliderView.frame = r;
        } else {
            self.sliderView.frame = CGRectMake(0, CGRectGetMaxY(self.colorAreaView.frame)-10, w, 20);
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
                switch (self.style) {
                    case ColorSliderStyleHUE:
                    {
                        CGFloat offset = y - CGRectGetMinY(self.colorAreaView.frame) + 10;
                        CGFloat l = (self.maxValue - self.minValue) / CGRectGetHeight(self.colorAreaView.frame);
                        NSInteger degree = self.maxValue - offset * l;
                        self.valueLabel.text = [NSString stringWithFormat:@"%lu°",degree];
                        self.sliderView.backgroundColor = [UIColor colorWithHue:degree/360.0 saturation:1 brightness:1 alpha:1];
                        
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ColorSliderDelegate)]) {
                            [self.delegate colorSliderDidChangedValue:degree];
                        }
                        break;
                        
                    }
                        
                    default:
                        break;
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

@end
