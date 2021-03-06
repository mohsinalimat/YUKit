//
//  YU_APP+SysInfo.m
//  YUKit<https://github.com/c6357/YUKit>
//
//  Created by BruceYu on 15/10/13.
//  Copyright © 2015年 BruceYu. All rights reserved.
//

#import "YU_SysInfo.h"
#import "YUKit.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <objc/runtime.h>

#pragma mark -


//CGFloat AppScreenScale(){
//    return [UIScreen mainScreen].scale;
//}

//CGFloat AppOnePhysicalPx(){
//    return (CGFloat)1.f/AppScreenScale();
//}

//CGSize AppScreenSize(){
//    return [UIScreen mainScreen].currentMode.size;
//}

//CGFloat AppScreenWidth(){
//    return [UIScreen mainScreen].bounds.size.width;
//}
//
//CGFloat AppScreenHeight(){
//    return [UIScreen mainScreen].bounds.size.height;
//}

#pragma mark -

//CGFloat AppWidth(){
//    return [[UIScreen mainScreen]applicationFrame].size.width;
//}
//
//CGFloat AppHeight(){
//    return [[UIScreen mainScreen]applicationFrame].size.height;
//}

#pragma mark -
//NSString *AppVersion()
//{
//    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//}
//
//NSString *AppBuildVersion()
//{
//    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//}
//
//
//NSString *AppBundleName()
//{
//    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
//}
//
//NSString *AppIdentifier()
//{
//    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//}

//NSURL *AppDocumentsURL(){
//    return [[[NSFileManager defaultManager]
//             URLsForDirectory:NSDocumentDirectory
//             inDomains:NSUserDomainMask] lastObject];
//}
//
//NSString *AppDocumentsPath(){
//    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//}
//
//NSURL *AppCachesURL(){
//    return [[[NSFileManager defaultManager]
//             URLsForDirectory:NSCachesDirectory
//             inDomains:NSUserDomainMask] lastObject];
//}
//
//NSString *AppCachesPath(){
//    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//}
//
//NSURL *AppLibraryURL(){
//    return [[[NSFileManager defaultManager]
//             URLsForDirectory:NSLibraryDirectory
//             inDomains:NSUserDomainMask] lastObject];
//}
//
//NSString *AppLibraryPath(){
//    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
//}


NSString *AppBundleSeedID()
{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

NSString *AppSchemaWithName(NSString *name)
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array )
    {
        if ( name )
        {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName )
            {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] )
            {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count )
        {
            continue;
        }
        
        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length )
        {
            return schema;
        }
    }
    return nil;
#else
    return nil;
#endif
}

NSString *AppSchema()
{
    return AppSchemaWithName(nil);
}



int64_t AppMemoryUsage()
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kern = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    if (kern != KERN_SUCCESS) return -1;
    return info.resident_size;
}

CGFloat AppCpuUsage()
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    long tot_sec = 0;
    long tot_usec = 0;
    double tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (double)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

