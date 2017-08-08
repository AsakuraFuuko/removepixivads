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
            NSString *className = NSStringFromClass([view class]);
            if (![className isEqualToString:@"pixiv.AdGenerationRectangleView"]) {
                [view removeFromSuperview];
            }
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

%hook _TtC5pixiv32RankingIllustTableViewController
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = %orig;
    // %log((float) height)
    if (height > 200) {
        return 0;
    } else {
        return height;
    }
}
%end // end hook

%hook _TtC5pixiv25IllustTableViewController
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = %orig;
    // %log((float) height)
    if (height > 200) {
        return 0;
    } else {
        return height;
    }
}
%end // end hook

%hook _TtC5pixiv29HomeIllustTableViewController
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = %orig;
    // %log((float) height)
    if (height > 260 && height < 300) {
        return 0;
    } else {
        return height;
    }
}
%end // end hook

%hook _TtC5pixiv38SearchResultsIllustTableViewController
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = %orig;
    // %log((float) height)
    if (height > 200) {
        return 0;
    } else {
        return height;
    }
}
%end // end hook

%hook _TtC5pixiv41NewFromFollowingIllustTableViewController
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = %orig;
    // %log((float) height)
    if (height > 200) {
        return 0;
    } else {
        return height;
    }
}
%end // end hook
// 6.x end
