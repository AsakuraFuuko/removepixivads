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

// 6.x end