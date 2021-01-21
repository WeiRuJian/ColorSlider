//
//  ViewController.m
//  ColorSlider
//
//  Created by WeiRuJian on 2021/1/16.
//

#import "ViewController.h"
#import "ColorSlider.h"


@interface ViewController () <ColorSliderDelegate>
@property (nonatomic, strong) ColorSlider *sliderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sliderView = [[ColorSlider alloc] initWithStyle:ColorSliderStyleCCT];
    self.sliderView.frame = CGRectMake(0, 0, 66, 300 );
    self.sliderView.center = self.view.center;
//    self.sliderView.value = 50;
   
    self.sliderView.delegate = self;
    [self.view addSubview:self.sliderView];
    
    
    self.sliderView.font = [UIFont boldSystemFontOfSize:22];
    self.sliderView.textColor = UIColor.whiteColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.center = CGPointMake(self.view.center.x, self.view.center.y + 200);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sliderView.maxCCT = 56;
    self.sliderView.minCCT = 23;
}

- (void)buttonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.sliderView.enable = sender.isSelected;
    
    NSInteger f = arc4random() % 360;
    self.sliderView.value = f;
}

- (void)colorSlider:(ColorSlider *)colorSlider didChangedValue:(NSInteger)value {
    NSLog(@"%lu", value);
}

@end
