#import <UIKit/UIKit.h>
#import <objc/message.h>

#pragma mark - Settings

static NSString * const KRPreferencesDomain = @"com.tutu.keyboardrounded";
static NSString * const KRRadiusKey = @"KeyRadius";
static NSString * const KRSettingsChangedNotification =
    @"com.tutu.keyboardrounded/settingschanged";

static CGFloat KRKeyRadius(void) {
    NSUserDefaults *defaults =
        [[NSUserDefaults alloc] initWithSuiteName:KRPreferencesDomain];

    CGFloat radius = [defaults floatForKey:KRRadiusKey];

    // 0 = chưa có giá trị → dùng mặc định
    if (radius <= 0.0) {
        radius = 10.0;
    }

    return MAX(0.0, MIN(radius, 20.0));
}

#pragma mark - Keyboard Geometry

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) double roundRectRadius;
@property(nonatomic) int roundRectCorners;
@end

#pragma mark - Keyboard Traits

@interface UIKBRenderTraits : NSObject
@end

#pragma mark - iPhone Keyboard Factory

@interface UIKBRenderFactoryiPhone : NSObject

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane;

@end

%hook UIKBRenderFactoryiPhone

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane
{
    id traits = %orig(key, keyplane);

    if (!traits)
        return traits;

    /*
     * Không gọi trực tiếp [traits geometry]
     * để tránh lỗi compile "no known instance method".
     */
    SEL geometrySelector = @selector(geometry);

    if (![traits respondsToSelector:geometrySelector])
        return traits;

    id geometry =
        ((id (*)(id, SEL))objc_msgSend)(
            traits,
            geometrySelector
        );

    if (!geometry)
        return traits;

    /*
     * Bo cả 4 góc của KEY.
     */
    SEL radiusSetter = @selector(setRoundRectRadius:);

    if ([geometry respondsToSelector:radiusSetter]) {
        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)KRKeyRadius()
        );
    }

    SEL cornersSetter = @selector(setRoundRectCorners:);

    if ([geometry respondsToSelector:cornersSetter]) {
        ((void (*)(id, SEL, int))objc_msgSend)(
            geometry,
            cornersSetter,
            0xF
        );
    }

    return traits;
}

%end

#pragma mark - iPhone Landscape

@interface UIKBRenderFactoryiPhoneLandscape : NSObject

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane;

@end

%hook UIKBRenderFactoryiPhoneLandscape

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane
{
    id traits = %orig(key, keyplane);

    if (!traits)
        return traits;

    SEL geometrySelector = @selector(geometry);

    if (![traits respondsToSelector:geometrySelector])
        return traits;

    id geometry =
        ((id (*)(id, SEL))objc_msgSend)(
            traits,
            geometrySelector
        );

    if (!geometry)
        return traits;

    SEL radiusSetter = @selector(setRoundRectRadius:);

    if ([geometry respondsToSelector:radiusSetter]) {
        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)KRKeyRadius()
        );
    }

    SEL cornersSetter = @selector(setRoundRectCorners:);

    if ([geometry respondsToSelector:cornersSetter]) {
        ((void (*)(id, SEL, int))objc_msgSend)(
            geometry,
            cornersSetter,
            0xF
        );
    }

    return traits;
}

%end
