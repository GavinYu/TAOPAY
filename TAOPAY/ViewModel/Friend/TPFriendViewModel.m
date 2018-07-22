//
//  TPFriendViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendViewModel.h"

#import "TPAppConfig.h"

#import "TPAddressBookModel.h"
#import "TPFriendListModel.h"

#import <Contacts/Contacts.h>

@implementation TPFriendViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
    }
    return self;
}

//MARK: -- 添加好友
- (void)addFriendWithFriendId:(NSString *)friendId
                    withPhone:(NSString *)phone
                      success:(void(^)(id json))success
                      failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestAddFriend:friendId phone:phone success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
            failure(response.message);
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        failure(msg);
    }];
}

//MARK: -- 弹出获取手机通讯录的权限
- (void)requestAuthorizationForAddressBook {
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0){
        CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    [self getmyAddressbook];
                } else {
                    NSLog(@"授权失败, error=%@", error);
                }
            }];
        } else if (authorizationStatus == CNAuthorizationStatusAuthorized){
            [self getmyAddressbook];
        }
        
    }else {
        [SVProgressHUD showErrorWithStatus:@"请升级系统"];
    }
}
//MARK: -- 获取手机的通讯录
- (void)getmyAddressbook {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        DLog(@"没有授权...");
    }
    
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSMutableDictionary *myDict = [[NSMutableDictionary alloc]init];
        DLog(@"-------------------------------------------------------");
        NSData *imageData = contact.imageData;
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        DLog(@"givenName=%@, familyName=%@", givenName, familyName);
        
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        
        __block NSString *phone = @"";
        [phoneNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CNLabeledValue *tmpValue = (CNLabeledValue *)obj;
            CNPhoneNumber *phoneNumber = tmpValue.value;
            if (phoneNumber.stringValue.length > 0) {
                phone = phoneNumber.stringValue;
                
                *stop = YES;
            }
        }];
        
        DLog(@"phone=%@", phone);
        
        [myDict setValue:nameStr forKey:@"name"];
        [myDict setValue:phone forKey:@"phone"];
        [myDict setValue:imageData forKey:@"avatar"];
        
        DLog(@"mydict is ==== %@",myDict);
        TPAddressBookModel *tmpModel = TPAddressBookModel.new;
        tmpModel = [TPAddressBookModel modelWithDictionary:myDict];
        [self.dataSource addObject:tmpModel];
    }];
}

@end
