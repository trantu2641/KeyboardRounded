#import <UIKit/UIKit.h>

static CGFloat KRKeyRadius(void) {
    return 12.0;
}

#pragma mark - 10 Key Round Factory

@interface UIKBRenderFactory10Key_Round : NSObject
- (BOOL)shouldUseRoundCornerForKey:(id)key;
- (int)roundCornersForKey:(id)key onKeyplane:(id)keyplane;
- (void)_customizeGeometry:(id)geometry
                    forKey:(id)key
                  contents:(id)contents
               onKeyplane:(id)keyplane;
@end

%hook UIKBRenderFactory10Key_Round

/*
 * Ép tất cả key sử dụng rounded corner.
 */
- (BOOL)shouldUseRoundCornerForKey:(id)key {
    return YES;
}

/*
 * 0xF = cả 4 góc.
 */
- (int)roundCornersForKey:(id)key
              onKeyplane:(id)keyplane {
    return 0xF;
}

/*
 * Sau khi UIKit tạo geometry cho từng key,
 * đặt radius giống nhau.
 */
- (void)_customizeGeometry:(id)geometry
                    forKey:(id)key
                  contents:(id)contents
               onKeyplane:(id)keyplane {

    %orig(geometry, key, contents, keyplane);

    if (geometry &&
        [geometry respondsToSelector:@selector(setRoundRectRadius:)]) {

        [geometry setRoundRectRadius:KRKeyRadius()];
    }
}

%end


#pragma mark - Monolith Factory

@interface UIKBRenderFactory_Monolith : NSObject
- (void)configureCornersOnGeometry:(id)geometry
                            forKey:(id)key;
- (double)keyRoundRectRadius;
@end

%hook UIKBRenderFactory_Monolith

/*
 * Đây là factory khác mà iOS có thể dùng
 * cho letter keys.
 */
- (double)keyRoundRectRadius {
    return KRKeyRadius();
}

/*
 * Ép geometry của từng key về radius mong muốn.
 */
- (void)configureCornersOnGeometry:(id)geometry
                            forKey:(id)key {

    %orig(geometry, key);

    if (geometry &&
        [geometry respondsToSelector:@selector(setRoundRectRadius:)]) {

        [geometry setRoundRectRadius:KRKeyRadius()];
    }
}

%end
