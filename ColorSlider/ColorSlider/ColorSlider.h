//
//  ColorSlider.h
//  ColorSlider
//
//  Created by WeiRuJian on 2021/1/16.
//

#import <UIKit/UIKit.h>

/// 滑块类型
typedef NS_ENUM(NSInteger, ColorSliderStyle) {
    ColorSliderStyleHUE = 0, /// HSI色彩
    ColorSliderStyleCCT, /// CCT色温
    ColorSliderStyleINT, /// INT 亮度
    ColorSliderStyleGM, /// GM 绿/品
    ColorSliderStyleSAT /// SAT 饱和度
};


@protocol ColorSliderDelegate <NSObject>
@optional
/// 数据变化实时更新
/// @param value 当前变化值
- (void)colorSliderDidChangedValue:(NSInteger)value;

/// 数据变化结束更新
/// @param value 当前结束变化的值
- (void)colorSliderDidChangedOutputValue:(NSInteger)value;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ColorSlider : UIView

- (instancetype)initWithStyle:(ColorSliderStyle)style;

@property (nonatomic, weak) id<ColorSliderDelegate> delegate;

/// 是否可用
@property (nonatomic, assign) BOOL enable;

@property (nonatomic, assign) NSInteger value;

/// HUE 0~360 || CCT 16~100 || GM -10~10 || INT 0~100
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@end

NS_ASSUME_NONNULL_END
