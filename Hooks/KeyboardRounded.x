#import <UIKit/UIKit.h>
#import <objc/message.h>

static CGFloat KRKeyRadius(void) {
    return 8.0;
}

#pragma mark - UIKBRenderGeometry

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) double roundRectRadius;
@property(nonatomic) int roundRectCorners;
@end

#pragma mark - UIKBRenderFactory_Monolith

@interface UIKBRenderFactory_Monolith : NSObject

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane;

- (id)_variantTraitsForLetterKey:(id)key
                       onKeyplane:(id)keyplane;

@end

%hook UIKBRenderFactory_Monolith

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane
{
    id traits = %orig(key, keyplane);

    if (!traits)
        return traits;

    if (![traits respondsToSelector:@selector(geometry)])
        return traits;

    id geometry = [traits geometry];

    if (!geometry)
        return traits;

    if ([geometry respondsToSelector:@selector(setRoundRectRadius:)]) {
        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            @selector(setRoundRectRadius:),
            KRKeyRadius()
        );
    }

    if ([geometry respondsToSelector:@selector(setRoundRectCorners:)]) {
        ((void (*)(id, SEL, int))objc_msgSend)(
            geometry,
            @selector(setRoundRectCorners:),
            0xF
        );
    }

    return traits;
}

- (id)_variantTraitsForLetterKey:(id)key
                       onKeyplane:(id)keyplane
{
    id traits = %orig(key, keyplane);

    if (!traits)
        return traits;

    if (![traits respondsToSelector:@selector(geometry)])
        return traits;

    id geometry = [traits geometry];

    if (!geometry)
        return traits;

    if ([geometry respondsToSelector:@selector(setRoundRectRadius:)]) {
        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            @selector(setRoundRectRadius:),
            KRKeyRadius()
        );
    }

    if ([geometry respondsToSelector:@selector(setRoundRectCorners:)]) {
        ((void (*)(id, SEL, int))objc_msgSend)(
            geometry,
            @selector(setRoundRectCorners:),
            0xF
        );
    }

    return traits;
}

%end
