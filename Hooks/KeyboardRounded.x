#import <UIKit/UIKit.h>
#import <objc/message.h>

#pragma mark - Keyboard traits

@interface UIKBRenderTraits : NSObject
- (id)geometry;
@end

#pragma mark - Keyboard renderer

@interface UIKBRenderer : NSObject
- (void)renderBackgroundTraits:(id)traits allowCaching:(BOOL)allowCaching;
@end

#pragma mark - Keyboard geometry

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) CGFloat roundRectRadius;
@end

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    return 12.0;
}

static CGFloat KRKeyboardRadius(void) {
    return 24.0;
}

#pragma mark - Key radius

%hook UIKBRenderer

- (void)renderBackgroundTraits:(id)traits allowCaching:(BOOL)allowCaching {

    id geometry = nil;

    if (traits &&
        [traits respondsToSelector:@selector(geometry)]) {

        geometry =
            ((id (*)(id, SEL))objc_msgSend)(
                traits,
                @selector(geometry)
            );
    }

    BOOL canRound =
        geometry &&
        [geometry respondsToSelector:@selector(roundRectRadius)] &&
        [geometry respondsToSelector:@selector(setRoundRectRadius:)];

    CGFloat oldRadius = 0.0;

    if (canRound) {

        oldRadius =
            ((CGFloat (*)(id, SEL))objc_msgSend)(
                geometry,
                @selector(roundRectRadius)
            );

        ((void (*)(id, SEL, CGFloat))objc_msgSend)(
            geometry,
            @selector(setRoundRectRadius:),
            KRKeyRadius()
        );
    }

    %orig(traits, allowCaching);

    if (canRound) {

        ((void (*)(id, SEL, CGFloat))objc_msgSend)(
            geometry,
            @selector(setRoundRectRadius:),
            oldRadius
        );
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

    layer.cornerRadius = KRKeyboardRadius();
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
