#import <UIKit/UIKit.h>
#import <objc/message.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    return 8.0;
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
     * Không gọi [traits geometry].
     * Lấy geometry bằng objc_msgSend để tránh lỗi
     * "no known instance method for selector 'geometry'".
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
     * Ép toàn bộ 4 góc của key.
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
