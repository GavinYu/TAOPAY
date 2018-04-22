//
//  TPConstInline.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#ifndef TPConstInline_h
#define TPConstInline_h

/// 网络图片的占位图片
static inline UIImage *YWebImagePlaceholder(){
  return [UIImage imageNamed:@""];
}

/// 网络头像
static inline UIImage *YWebAvatarImagePlaceholder(){
  return [UIImage imageNamed:@""];
}

/// 适配
static inline CGFloat YPxConvertToPt(CGFloat px){
  return ceil(px * [UIScreen mainScreen].bounds.size.width/414.0f);
}


/// 辅助方法 创建一个文件夹
static inline void YCreateDirectoryAtPath(NSString *path){
  BOOL isDir = NO;
  BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
  if (isExist) {
    if (!isDir) {
      [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
      [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
  } else {
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
  }
}
/// 微信重要数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *YTAOPAYDocDirPath(){
  return [DocumentDirectory stringByAppendingPathComponent:Y_TAOPAY_DOC_NAME];
}
/// 通过NSFileManager来获取指定重要数据的路径
static inline NSString *YFilePathFromTAOPAYDoc(NSString *filename){
  NSString *docPath = YTAOPAYDocDirPath();
  YCreateDirectoryAtPath(docPath);
  return [docPath stringByAppendingPathComponent:filename];
}

/// 微信轻量数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *YTAOPAYCacheDirPath(){
  return [CachesDirectory stringByAppendingPathComponent:Y_TAOPAY_CACHE_NAME];
}
/// 通过NSFileManager来访问 获取指定轻量数据的路径
static inline NSString *YFilePathFromTAOPAYCache(NSString *filename){
  NSString *cachePath = YTAOPAYCacheDirPath();
  YCreateDirectoryAtPath(cachePath);
  return [cachePath stringByAppendingPathComponent:filename];
}


#endif /* TPConstInline_h */
