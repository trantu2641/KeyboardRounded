#import <UIKit/UIKit.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    return 12.0;
}

static CGFloat KRKeyboardRadius(void) {
    return 24.0;
}

#pragma mark - Key geometry

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) CGFloat roundRectRadius;
@end

@interface UIKBRenderer : NSObject
- (void)renderBackgroundTraits:(id)traits allowCaching:(BOOL)allowCaching;
@end

%hook UIKBRenderer

- (void)renderBackgroundTraits:(id)traits allowCaching:(BOOL)allowCaching {

    id geometry = nil;

    if ([traits respondsToSelector:@selector(geometry)]) {
        geometry = [traits geometry];
    }

    BOOL canRound =
        geometry &&
        [geometry respondsToSelector:@selector(roundRectRadius)] &&
        [geometry respondsToSelector:@selector(setRoundRectRadius:)];

    CGFloat oldRadius = 0.0;

    if (canRound) {
        oldRadius = [geometry roundRectRadius];

        [geometry setRoundRectRadius:KRKeyRadius()];
    }

    %orig(traits, allowCaching);

    if (canRound) {
        [geometry setRoundRectRadius:oldRadius];
    }
}

%end

#pragma mark - Keyboard background

@interface UIKBBackdropView : UIView
@end

@interface UIKBVisualEffectView : UIView
@end

static void KRApplyKeyboardBackgroundRadius(UIView *view) {

    if (!view)
        return;

    CALayer *layer = view.layer;

    if (!layer)
        return;

    CGFloat radius = KRKeyboardRadius();

    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
}

#pragma mark - UIKBBackdropView

%hook UIKBBackdropView

- (void)layoutSubviews {

    %orig;

    KRApplyKeyboardBackgroundRadius(self);
}

- (void)setFrame:(CGRect)frame {

    %orig(frame);

    KRApplyKeyboardBackgroundRadius(self);
}

- (void)setBounds:(CGRect)bounds {

    %orig(bounds);

    KRApplyKeyboardBackgroundRadius(self);
}

%end

#pragma mark - UIKBVisualEffectView

%hook UIKBVisualEffectView

- (void)layoutSubviews {

    %orig;

    KRApplyKeyboardBackgroundRadius(self);
}

%end
