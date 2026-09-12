#import <UIKit/UIKit.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    return 8.0;
}

#pragma mark - Keyboard Geometry

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) double roundRectRadius;
@property(nonatomic) int roundRectCorners;
@end

@interface UIKBRenderTraits : NSObject
- (id)geometry;
@end

#pragma mark - iPhone Keyboard Factory

@interface UIKBRenderFactoryiPhone : NSObject
- (id)_traitsForKey:(id)key onKeyplane:(id)keyplane;
@end

%hook UIKBRenderFactoryiPhone

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane {

    id traits = %orig(key, keyplane);

    if (!traits)
        return traits;

    if (![traits respondsToSelector:@selector(geometry)])
        return traits;

    id geometry = [traits geometry];

    if (!geometry)
        return traits;

    if ([geometry respondsToSelector:@selector(setRoundRectRadius:)]) {
        [geometry setRoundRectRadius:KRKeyRadius()];
    }

    if ([geometry respondsToSelector:@selector(setRoundRectCorners:)]) {
        [geometry setRoundRectCorners:0xF];
    }

    return traits;
}

%end


#pragma mark - iPhone Landscape

@interface UIKBRenderFactoryiPhoneLandscape : NSObject
- (id)_traitsForKey:(id)key onKeyplane:(id)keyplane;
@end

%hook UIKBRenderFactoryiPhoneLandscape

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane {

    id traits = %orig(key, keyplane);

    if (!traits)
        return traits;

    if (![traits respondsToSelector:@selector(geometry)])
        return traits;

    id geometry = [traits geometry];

    if (!geometry)
        return traits;

    if ([geometry respondsToSelector:@selector(setRoundRectRadius:)]) {
        [geometry setRoundRectRadius:KRKeyRadius()];
    }

    if ([geometry respondsToSelector:@selector(setRoundRectCorners:)]) {
        [geometry setRoundRectCorners:0xF];
    }

    return traits;
}

%end
