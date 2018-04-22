//
//  YReflection.m
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YReflection.h"

#import <objc/runtime.h>

SEL YSelectorWithKeyPattern(NSString *key, const char *suffix) {
  NSUInteger keyLength = [key maximumLengthOfBytesUsingEncoding:NSUTF8StringEncoding];
  NSUInteger suffixLength = strlen(suffix);
  
  char selector[keyLength + suffixLength + 1];
  
  BOOL success = [key getBytes:selector maxLength:keyLength usedLength:&keyLength encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, key.length) remainingRange:NULL];
  if (!success) return NULL;
  
  memcpy(selector + keyLength, suffix, suffixLength);
  selector[keyLength + suffixLength] = '\0';
  
  return sel_registerName(selector);
}

SEL YSelectorWithCapitalizedKeyPattern(const char *prefix, NSString *key, const char *suffix) {
  NSUInteger prefixLength = strlen(prefix);
  NSUInteger suffixLength = strlen(suffix);
  
  NSString *initial = [key substringToIndex:1].uppercaseString;
  NSUInteger initialLength = [initial maximumLengthOfBytesUsingEncoding:NSUTF8StringEncoding];
  
  NSString *rest = [key substringFromIndex:1];
  NSUInteger restLength = [rest maximumLengthOfBytesUsingEncoding:NSUTF8StringEncoding];
  
  char selector[prefixLength + initialLength + restLength + suffixLength + 1];
  memcpy(selector, prefix, prefixLength);
  
  BOOL success = [initial getBytes:selector + prefixLength maxLength:initialLength usedLength:&initialLength encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, initial.length) remainingRange:NULL];
  if (!success) return NULL;
  
  success = [rest getBytes:selector + prefixLength + initialLength maxLength:restLength usedLength:&restLength encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, rest.length) remainingRange:NULL];
  if (!success) return NULL;
  
  memcpy(selector + prefixLength + initialLength + restLength, suffix, suffixLength);
  selector[prefixLength + initialLength + restLength + suffixLength] = '\0';
  
  return sel_registerName(selector);
}

