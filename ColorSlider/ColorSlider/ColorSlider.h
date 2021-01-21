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


@class ColorSlider;

@protocol ColorSliderDelegate <NSObject>
@optional
/// 数据变化实时更新
/// @param value 当前变化值
- (void)colorSlider:(ColorSlider *_Nullable)colorSlider didChangedValue:(NSInteger)value;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ColorSlider : UIView

- (instancetype)initWithStyle:(ColorSliderStyle)style;

@property (nonatomic, weak) id<ColorSliderDelegate> delegate;

/// 是否可用
@property (nonatomic, assign) BOOL enable;

@property (nonatomic, assign) NSInteger value;



@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) NSInteger minCCT;
@property (nonatomic, assign) NSInteger maxCCT;

@end

NS_ASSUME_NONNULL_END
