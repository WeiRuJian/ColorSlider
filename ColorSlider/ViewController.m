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
//    self.sliderView.value = 213;
    self.sliderView.delegate = self;
    [self.view addSubview:self.sliderView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.center = CGPointMake(self.view.center.x, self.view.center.y + 200);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.sliderView.enable = sender.isSelected;
    
    NSInteger f = arc4random() % 360;
    self.sliderView.value = f;
}

- (void)colorSliderDidChangedValue:(NSInteger)value {
    NSLog(@"%lu", value);
}
- (void)colorSliderDidChangedOutputValue:(NSInteger)value {
    NSLog(@"--%lu--", value);
}
@end
