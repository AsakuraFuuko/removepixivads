#include <substrate.h>
#include <mach-o/dyld.h>

int _module_base = 0;

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

	unsigned long _viewWillAppear = 0x100399784 + _module_base; //6.0.9 arm64
	MSHookFunction((void *)_viewWillAppear, (void *)new_viewWillAppear, (void **)&orig_viewWillAppear);

	unsigned long _setView = 0x100455158 + _module_base;
	MSHookFunction((void *)_setView, (void *)new_setView, (void **)&orig_setView);

	unsigned long _vviewWillAppear = 0x1000a7e78 + _module_base;
	MSHookFunction((void *)_vviewWillAppear, (void *)new_vviewWillAppear, (void **)&orig_vviewWillAppear);

	NSLog(@"pixiv hook end");
}
