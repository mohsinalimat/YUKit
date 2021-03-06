//
//  UIImage+YU.h
//  YUKit<https://github.com/c6357/YUKit>
//
//  Created by BruceYu on 15/9/2.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark - initialize
@interface UIImage (YU)

/**
 加载图片,加载时会缓存图片
 @param fileName 图片名
 */
UIKIT_EXTERN UIImage* UIImageWithName(NSString *fileName);

/**
 从Bundle资源文件中获取UIImage

 @param bundleName bundleName
 @param name 资源名字。可能有子文件夹
 @param ext 文件后缀
 */
UIKIT_EXTERN UIImage* UIImageNamedWithBundleOFFile(NSString *bundleName,NSString *name,NSString *ext);


/**
 加载PNG图片，图像数据不会缓存
 */
UIKIT_EXTERN UIImage* UIImageWithContentsOfPNGFile(NSString *fileName);


/**
 加载JPG图片，图像数据不会缓存
 */
UIKIT_EXTERN UIImage* UIImageWithContentsOfJPGFile(NSString *fileName);

/**
 加载图片，图像数据不会缓存
 @param fileName 图片名
 @param ext 图片后缀
 */
UIKIT_EXTERN UIImage* UIImageWithContentsOfFile(NSString *fileName,NSString *ext);

//返回view的快照
+ (UIImage *)imageWithView:(UIView*)view;

//获得纯色图片
//根据颜色返回图片
+ (UIImage *)imageWithColor:(UIColor*)color;

//根据颜色返回图片
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)size;


/**
 改变图片浅色区域颜色

 @param tintColor <#tintColor description#>
 @return <#return value description#>
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

#pragma mark -
#pragma mark -
/**
 <#Description#>

 @param name <#name description#>
 @param top <#top description#>
 @param left <#left description#>
 @param bottom <#bottom description#>
 @param right <#right description#>
 @return <#return value description#>
 */
UIImage* imageWithCapInsets(NSString *name,CGFloat top,CGFloat left,CGFloat bottom,CGFloat right);


/**
 <#Description#>

 @param name <#name description#>
 @param top <#top description#>
 @param left <#left description#>
 @param bottom <#bottom description#>
 @param right <#right description#>
 @param mode <#mode description#>
 @return <#return value description#>
 */
UIImage* imageWithCapInsetsAndResizingMode(NSString *name,CGFloat top,CGFloat left,CGFloat bottom,CGFloat right,UIImageResizingMode mode);



/**
 *图片成比例放大 多少倍

 @param multiple <#multiple description#>
 @return <#return value description#>
 */
- (UIImage *)imageByResizeToMultiple:(CGFloat)multiple;

/**
 * 对图片进行缩放

 @param size <#size description#>
 @return <#return value description#>
 */
- (UIImage *)imageByResizeToSize:(CGSize)size;


/**
 * 根据size的 MAX(width,height)/width or MAX(width,height)/height
 缩放较大边，另一边等比缩放
 如果 是正方形图片，就等比缩放
 @param bounds <#bounds description#>
 @return <#return value description#>
 */
- (UIImage *)imageByResizeWithBounds:(CGSize)bounds;


/**
 *剪切图片

 @param rect <#rect description#>
 @return <#return value description#>
 */
- (UIImage *)imageByCropToRect:(CGRect)rect;


/**
 *等比，居中剪切

 @param size <#size description#>
 @return <#return value description#>
 */
- (UIImage *)imageByCropCenterToRect:(CGSize)size;



/**
 *顺时针多少度 弧度 0 ~ 2M_PI

 @param radians <#radians description#>
 @return <#return value description#>
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;


/**
 *顺时针多少度 度 0 ~ 360

 @param degrees <#degrees description#>
 @return <#return value description#>
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;


/**
 *
 @param orientation <#orientation description#>
 @return <#return value description#>
 */
- (UIImage *)imageRotation:(UIImageOrientation)orientation;



/**
 *获取该图片的大概颜色
 @return <#return value description#>
 */
- (UIColor*)imageMostColor;



/**
 <#Description#>

 @param color <#color description#>
 @return <#return value description#>
 */
- (UIImage*)imageChangeByColor:(UIColor*)color;


#pragma mark -
#pragma mark - Code
/**
 生成二维码图片

 @param code <#code description#>
 @param width <#width description#>
 @param height <#height description#>
 @return <#return value description#>
 */
+ (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;


/**
 生成二维码图片(二维码中心带图片)

 @param code <#code description#>
 @param image <#image description#>
 @param width <#width description#>
 @param height <#height description#>
 @return <#return value description#>
 */
+ (UIImage *)generateQRCode:(NSString *)code image:(UIImage*)image width:(CGFloat)width height:(CGFloat)height;


/**
 生成条形码图片

 @param code <#code description#>
 @param width <#width description#>
 @param height <#height description#>
 @return <#return value description#>
 */
+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;




#pragma mark -
- (BOOL)imageHasAlpha:(UIImage *)image;

- (NSString *)imageToBase64;

+ (UIImage *)Base64ToImage:(NSString *)encodedImageStr;




- (UIImage *)fixOrientation:(UIImage *)aImage;
- (NSString*)saveImagewithName:(NSString *)imageName;
@end
