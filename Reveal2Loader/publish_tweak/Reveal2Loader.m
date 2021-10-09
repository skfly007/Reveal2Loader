//
//  Reveal2Loader.m
//  Reveal2Loader
//
//  Created by h4ck on 2019/2/19.
//  Copyright (c) 2019年 __MyCompanyName__. All rights reserved.
//

#include <dlfcn.h>

static __attribute__((constructor)) void tweak_main_revealloader(int __unused argc, char __unused **argv, char __unused **envp)
{
    /*
    printf("开始执行\n");
    os_log(os_log_create("com.skly.subsystem.logservice", "skfly_trace"),"%{public}@",[NSString stringWithFormat:@"当前文件:%s(%d)",__FILE__,__LINE__]);
    os_log_error(os_log_create("com.skly.subsystem.logservice", "skfly_trace"),"%{public}@",[NSString stringWithFormat:@"当前文件:%s(%d)",__FILE__,__LINE__]);
    os_log_fault(os_log_create("com.skly.subsystem.logservice", "skfly_trace"),"%{public}@",[NSString stringWithFormat:@"当前文件:%s(%d)",__FILE__,__LINE__]);
    printf("执行完毕\n");
    */
    NSString* configFile=@"/var/mobile/Library/Preferences/com.skfly.RHRevealLoader.plist";
    MyLogDebug(@"Reveal2Loader开始加载配置文件: %@",configFile);
    
    NSDictionary *prefs = g_skfly_tweak_hook_pre_process(configFile, @"RevealLoader");
    if(nil==prefs)
    {
        return;
    }
    MyLogDebug(@"配置文件加载成功: %@",configFile);
    
    NSString *libraryPath = @"/Library/Frameworks/RevealServer_31.framework/RevealServer";
    if([[prefs objectForKey:[NSString stringWithFormat:@"RHRevealEnabled-%@", [[NSBundle mainBundle] bundleIdentifier]]] boolValue])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:libraryPath])
        {
            void *addr = dlopen([libraryPath UTF8String], RTLD_NOW);
            if(addr)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStart" object:nil];
                MyLogDebug(@"RevealLoader loaded %@ successed, address %p", libraryPath,addr);
            }
            else
            {
                MyLogDebug(@"RevealLoader loaded %@ failed, address %p", libraryPath,addr);
            }
        }
    }
    
}

