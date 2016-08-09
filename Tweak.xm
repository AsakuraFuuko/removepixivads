#include <substrate.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#include <AppList/AppList.h>

long long _module_base = 0;

// pixiv.AdContainingViewController viewWillAppear
void (*orig_viewWillAppear)(id self, BOOL animated);
void new_viewWillAppear(id self, BOOL animated) {
    orig_viewWillAppear(self, animated);
    ((UIView *) MSHookIvar<id>(self, "adContainerView")).hidden = YES;
    ((NSLayoutConstraint *) MSHookIvar<id>(self, "adContainerHeightConstraint")).constant = 0;
    NSLog(@"pixiv hook success");
}

// pixiv.AdThumbnailView setView
void (*orig_setView)(id self, id target);
void new_setView(id self, id target) {
    orig_setView(self, target);
    NSLog(@"%@", MSHookIvar<id>(self, "view"));
    ((UIView *) MSHookIvar<id>(self, "view")).hidden = YES;
    NSLog(@"pixiv hook success");
}

// pixiv.VideoAdContainingViewController viewWillAppear
void (*orig_vviewWillAppear)(id self, BOOL animated);
void new_vviewWillAppear(id self, BOOL animated) {
    orig_vviewWillAppear(self, animated);
    ((UIView *) MSHookIvar<id>(self, "adContainerView")).hidden = YES;
    NSLog(@"pixiv hook success");
}

NSString *getPixivVersion() {
    ALApplicationList *al = [ALApplicationList sharedApplicationList];
    NSString *bundleVersion = [al valueForKey:@"bundleVersion" forDisplayIdentifier:@"net.pxv.iphone"];
    NSLog(@"pixiv bundle Version: %@", bundleVersion);
    return bundleVersion;
}

%ctor {
    NSLog(@"pixiv hook begin");
    _module_base = _dyld_get_image_vmaddr_slide(0);
    NSLog(@"pixiv image base: 0x%llx", _module_base);
    
    // Version - Address ( armv7, arm64 )
    NSMutableDictionary *address_dic = [NSMutableDictionary dictionary];
    
    // 6.0.0.2882 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x10037a664, @0x000000000, @0x000000000, NULL] forKey:@"6.0.0.2882"];
    // 6.0.1.2907 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x100378e18, @0x000000000, @0x000000000, NULL] forKey:@"6.0.1.2907"];
    // 6.0.2.2932 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x100378e58, @0x000000000, @0x000000000, NULL] forKey:@"6.0.2.2932"];
    // 6.0.3.2999 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x10037e6dc, @0x000000000, @0x000000000, NULL] forKey:@"6.0.3.2999"];
    // 6.0.4.3076 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x100395f40, @0x000000000, @0x000000000, NULL] forKey:@"6.0.4.3076"];
    // 6.0.5.3127 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x10039e88c, @0x000000000, @0x000000000, NULL] forKey:@"6.0.5.3127"];
    // 6.0.6.3148 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x10038fa08, @0x000000000, @0x000000000, NULL] forKey:@"6.0.6.3148"];
    // 6.0.7.3150 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x10038fa10, @0x000000000, @0x000000000, NULL] forKey:@"6.0.7.3150"];
    // 6.0.8.3216 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x000000000, @0x000000000, @0x000000000, @0x10038f54c, @0x000000000, @0x000000000, NULL] forKey:@"6.0.8.3216"];
    // 6.0.9.3282 armv7 arm64
    [address_dic setObject:[NSArray arrayWithObjects: @0x0004089E4, @0x0004D12A4, @0x0000C0814, @0x100399784, @0x100455158, @0x1000a7e78, NULL] forKey:@"6.0.9.3282"];
    
    
    NSString *version = getPixivVersion();
    float versionFloat = [version floatValue];
    
    if(versionFloat >= 6){
        NSArray *address_array = [address_dic objectForKey:version];
        if(address_array) {
            Dl_info info;
            for (int i = 1; i <= [address_array count] / 3; i++){
                if([[address_array objectAtIndex:3 * i - 3] longLongValue] != 0){
                    long long _viewWillAppear = [[address_array objectAtIndex:3 * i - 3] longLongValue] + _module_base;
                    NSLog(@"pixiv address: 0x%llx", _viewWillAppear);
                    if (dladdr((void *)_viewWillAppear, &info)) {
                        NSLog(@"pixiv resolved symbol at address 0x%llx: dli_fname %s, dli_fbase %p, dli_sname %s, dli_saddr %p", _viewWillAppear, info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr);
                        
                        MSHookFunction((void *)_viewWillAppear, (void *)new_viewWillAppear, (void **)&orig_viewWillAppear);
                        
                        if([[address_array objectAtIndex:3 * i - 2] longLongValue] != 0){
                            long long _setView = [[address_array objectAtIndex:3 * i - 2] longLongValue] + _module_base;
                            MSHookFunction((void *)_setView, (void *)new_setView, (void **)&orig_setView);
                        }
                        
                        if([[address_array objectAtIndex:3 * i - 1] longLongValue] != 0){
                            long long _vviewWillAppear = [[address_array objectAtIndex:3 * i - 1] longLongValue] + _module_base;
                            MSHookFunction((void *)_vviewWillAppear, (void *)new_vviewWillAppear, (void **)&orig_vviewWillAppear);
                        }
                        break;
                    }
                }
            }
        }
    } else {
        // 5.8.7.6556
    }
    
    NSLog(@"pixiv hook end");
}
