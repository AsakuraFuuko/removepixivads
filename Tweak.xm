#include <substrate.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#define GET_ARRAY_LEN(array,len){len = (sizeof(array) / sizeof(array[0]));}

int _module_base = 0;

long long addresses[][3] = {
    {0x0004089E4, 0x0004D12A4, 0x0000C0814}, /* 6.0.9.3282 armv7 */
    {0x100399784, 0x100455158, 0x1000a7e78}, /* 6.0.9.3282 arm64 */
};

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

%ctor {
    NSLog(@"pixiv hook begin");
    _module_base = _dyld_get_image_vmaddr_slide(0);
    NSLog(@"pixiv image base: 0x%x", _module_base);
    
    int address_len = 0;
    GET_ARRAY_LEN(addresses, address_len);
    for (int i = 0; i < address_len; i++){
        Dl_info info;
        unsigned long _viewWillAppear = addresses[i][0] + _module_base;
        if (dladdr((void *)_viewWillAppear, &info)) {
            NSLog(@"pixiv resolved symbol at address 0x%lx: dli_fname %s, dli_fbase %p, dli_sname %s, dli_saddr %p", _viewWillAppear, info.dli_fname, info.dli_fbase, info.dli_sname, info.dli_saddr);
            
            MSHookFunction((void *)_viewWillAppear, (void *)new_viewWillAppear, (void **)&orig_viewWillAppear);
            
            unsigned long _setView = addresses[i][1] + _module_base;
            MSHookFunction((void *)_setView, (void *)new_setView, (void **)&orig_setView);
            
            unsigned long _vviewWillAppear = addresses[i][2] + _module_base;
            MSHookFunction((void *)_vviewWillAppear, (void *)new_vviewWillAppear, (void **)&orig_vviewWillAppear);
            break;
        }
    }
    
    NSLog(@"pixiv hook end");
}
