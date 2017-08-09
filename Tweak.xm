#include <substrate.h>

// for 5.x
%hook PIXLoginUserStateManager
- (BOOL) isPremium {
    return TRUE;
}
%end // end hook

%hook PIXUserModel
- (BOOL) isPremium {
    return TRUE;
}
%end // end hook
// 5.x end

// for 6.x
%hook ADGManagerViewController
- (void) loadRequest {
    id delegate = MSHookIvar<id>(self, "_delegate");
    if (delegate) {
        %log(delegate);
        UIView *view = MSHookIvar<UIView *>(delegate, "_delegate");
        if (view) {
            %log(view);
            [view removeFromSuperview];
        }
    }
}
%end // end hook

@interface _TtC5pixiv26AdContainingViewController : UIViewController
- (void) hideAd;
@end

%hook _TtC5pixiv26AdContainingViewController
- (void) viewWillAppear : (BOOL) animated {
	%orig;
    [self hideAd];
}
%end // end hook

@interface _TtC5pixiv31VideoAdContainingViewController : UIViewController
- (void) hideAd;
@end

%hook _TtC5pixiv31VideoAdContainingViewController
- (void) viewWillAppear : (BOOL) animated {
	%orig;
    [self hideAd];
}
%end // end hook
// 6.x end
