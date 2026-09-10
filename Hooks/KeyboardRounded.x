#import <UIKit/UIKit.h>

#pragma mark - Settings

// Độ bo của TẤT CẢ phím
static CGFloat KRKeyRadius(void) {
    return 12.0;
}

// Độ bo của nền keyboard
static CGFloat KRKeyboardRadius(void) {
    return 28.0;
}

#pragma mark - Keyboard Key Geometry

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) CGFloat roundRectRadius;
@end

/*
 * Quan trọng:
 * Hook trực tiếp setter của geometry.
 *
 * Không hook UIKBRenderer nữa.
 * Vì WERTY/UIO... có thể sử dụng geometry riêng,
 * nên thay đổi ở đây sẽ áp dụng cho từng geometry.
 */

%hook UIKBRenderGeometry

- (void)setRoundRectRadius:(CGFloat)radius {
    %orig(KRKeyRadius());
}

%end

#pragma mark - Keyboard Background

@interface UIKBBackdropView : UIView
@end

@interface UIKBVisualEffectView : UIView
@end

static void KRApplyBackgroundRadius(UIView *view) {
    if (!view)
        return;

    CALayer *layer = view.layer;

    if (!layer)
        return;

    layer.cornerRadius = KRKeyboardRadius();
    layer.masksToBounds = YES;
}

#pragma mark - UIKBBackdropView

%hook UIKBBackdropView

- (void)layoutSubviews {
    %orig;

    KRApplyBackgroundRadius(self);
}

%end

#pragma mark - UIKBVisualEffectView

%hook UIKBVisualEffectView

- (void)layoutSubviews {
    %orig;

    KRApplyBackgroundRadius(self);
}

%end
