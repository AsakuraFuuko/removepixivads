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

// before 6.0.8
@interface GADBannerView : UIView
@end

%hook GADBannerView

-(void)setRootViewController:(UIViewController *)arg1{
    UIView *view = MSHookIvar<UIView *>(arg1, "adContainerView");
    NSLog(@"%@", view);
    view.hidden = YES;
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    heightConstraint.constant = 0;
}

%end
// before 6.0.8

// after 6.0.9
%hook ADGManagerViewController

-(void)setAdView:(id)arg1{
    
}

-(id)initWithAdParams:(id)params adView:(UIView *)parentView{
    parentView.hidden = YES;
    parentView.superview.hidden = YES;
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in parentView.superview.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    heightConstraint.constant = 0;
    return %orig(params, parentView);
}

%end // end hook

%hook FADAdViewW320H180

-(void)loadAd{
    
}

%end // end hook
// end after 6.0.9

// 6.x end