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
%hook GADBannerView
- (void) setRootViewController: (UIViewController *) arg1 {
    %log(arg1);
    UIView *view = MSHookIvar<UIView *>(arg1, "adContainerView");
    if (view) {
        view.hidden = YES;
        NSLayoutConstraint *heightConstraint = MSHookIvar<NSLayoutConstraint *>(arg1, "adContainerHeightConstraint");
        if (heightConstraint) {
            heightConstraint.constant = 0;
        }
        for (UIView *subview in view.subviews) {
            [subview removeFromSuperview];
        }
    }
}
%end // end hook

%hook ADGManagerViewController
- (void) setRootViewController: (UIViewController *) arg1 {
    %log(arg1);
    UIView *view = MSHookIvar<UIView *>(arg1, "adContainerView");
    if (view) {
        view.hidden = YES;
        NSLayoutConstraint *heightConstraint = MSHookIvar<NSLayoutConstraint *>(arg1, "adContainerHeightConstraint");
        if (heightConstraint) {
            heightConstraint.constant = 0;
        }
        for (UIView *subview in view.subviews) {
            [subview removeFromSuperview];
        }
    }
}

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
// 6.x end
