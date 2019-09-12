//
//  GetContactsBook.m
//  PowerWallet
//
//  Created by PowerWallet on 2017/2/16.
//  Copyright © 2017年 Krisc.Zampono. All rights reserved.
//

#import "GetContactsBook.h"
#import <AddressBook/AddressBook.h>
#import <ContactsUI/ContactsUI.h>
#import "UserManager.h"
#import "CertificationCenterRequest.h"
#import "JQFMDB.h"

static GetContactsBook *instance;

@interface GetContactsBook ()

@property (nonatomic, strong) CertificationCenterRequest * requestVer;

@end

@implementation GetContactsBook

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

+ (GetContactsBook *)shareControl {
    @synchronized (self) {
        if (!instance) {
            instance = [[GetContactsBook alloc] init];
        }
    }
    return instance;
}

#pragma mark - 获取联系人
- (NSMutableDictionary *)getPersonInfo {
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArrayDic = [NSMutableArray arrayWithCapacity:0];
    
    //typedef CFTypeRef ABAddressBookRef;
    //typedef const void * CFTypeRef;
    //指向常量的指针
    ABAddressBookRef addressBook = nil;
    //判断当前系统的版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        //如果不小于6.0，使用对应的api获取通讯录，注意，必须先请求用户的同意，如果未获得同意或者用户未操作，此通讯录的内容为空
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);//等待同意后向下执行//为了保证用户同意后在进行操作，此时使用多线程的信号量机制，创建信号量，信号量的资源数0表示没有资源，调用dispatch_semaphore_wait会立即等待。若对此处不理解，请参看GCD信号量同步相关内容。
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            //如果用户同意，才会执行此block里面的方法
            //此方法发送一个信号，增加一个资源数
            dispatch_semaphore_signal(sema);});
        //如果之前的block没有执行，则sema的资源数为零，程序将被阻塞
        //当用户选择同意，block的方法被执行， sema资源数为1；
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //        dispatch_release(sema);
    }//如果系统是6.0之前的系统，不需要获得同意，直接访问else{  addressBook = ABAddressBookCreate(); }
    //通讯录信息已获得，开始取出
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //联系人条目数（使用long而不使用int是为了兼容64位）
    long peopleCount = 0;
    if (results) {
        peopleCount = CFArrayGetCount(results);
    }
    for (int i=0; i<peopleCount; i++)
    {
        NSMutableDictionary *tempDic = [@{} mutableCopy];
        ABRecordRef record = CFArrayGetValueAtIndex(results, i);
        
        //取得完整名字（与上面firstName、lastName无关）
        CFStringRef  fullName=ABRecordCopyCompositeName(record);
        //        NSLog(@"%@",(__bridge NSString*)fullName);
        [tempDic setObject:(__bridge NSString*)fullName ? (__bridge NSString *)fullName : @"" forKey:@"name"];
        
        // 读取电话,不只一个
        NSString *phoneStr = @"";
        ABMultiValueRef phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        long phoneCount = ABMultiValueGetCount(phones);
        //大于5个号码 判断为垃圾号码 可能是杀毒软件添加的 我们去掉这些号码
        if (phoneCount >5) {
            continue;
        }
        for (int j=0; j<phoneCount; j++) {
            // label
            CFStringRef lable = ABMultiValueCopyLabelAtIndex(phones, j);
            // phone number
            CFStringRef number = ABMultiValueCopyValueAtIndex(phones, j);
            // localize label
            CFStringRef local = ABAddressBookCopyLocalizedLabel(lable);
            //此处可使用一个字典来存储通讯录信息
            NSString * mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j);
            mobile = [self phoneNumClear:mobile];
            phoneStr = (mobile.length == 11 && phoneStr.length == 0) ? [phoneStr stringByAppendingString:mobile] : [phoneStr stringByAppendingString:@""];
            if (local)CFRelease(local);
            if (lable) CFRelease(lable);
            if (number)CFRelease(number);
            
        }
        [tempDic setObject:phoneStr  forKey:@"mobile"];
        [_dataArrayDic addObject:tempDic];
        if (fullName)CFRelease(fullName);
        if (phones) CFRelease(phones);
        record = NULL;
    }
    if (results)CFRelease(results);
    
    results = nil;if (addressBook)CFRelease(addressBook);
    addressBook = NULL;
    
    //排序
    //建立一个字典，字典保存key是A-Z  值是数组
    NSMutableDictionary*index=[NSMutableDictionary dictionaryWithCapacity:0];
    for (NSDictionary*dic in self.dataArrayDic) {
        NSString* str=[dic objectForKey:@"name"];
        NSString* phone = [dic objectForKey:@"mobile"];
        //获得中文拼音首字母，如果是英文或数字则#
        if (!str || [str isEqualToString:@""]) {
            continue;
        }
        if (!phone) {
            continue;
        }
        NSString *firstLetter = nil;
        
        if ([str canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            firstLetter = [[NSString stringWithFormat:@"%c",[str characterAtIndex:0]]uppercaseString];
        }else
        {
            if ([self transformToPinyin:str]&&![[self transformToPinyin:str]isEqualToString:@""]) {
                firstLetter = [[NSString stringWithFormat:@"%c",[[self transformToPinyin:str] characterAtIndex:0]]uppercaseString];
            }else
            {
                firstLetter = @"#";
            }
        }
        //如果首字母是数字或者特殊符号
        if (firstLetter.length>0) {
            if (!isalpha([firstLetter characterAtIndex:0])) {
                firstLetter = @"#";
            }
        }
        if ([[index allKeys]containsObject:firstLetter]) {
            //判断index字典中，是否有这个key如果有，取出值进行追加操作
            [[index objectForKey:firstLetter] addObject:dic];
        }else{
            NSMutableArray*tempArray=[NSMutableArray arrayWithCapacity:0];
            [tempArray addObject:dic];
            [index setObject:tempArray forKey:firstLetter];
        }
    }
    
    [self.dataArray addObjectsFromArray:[index allKeys] ? [index allKeys] : @[]];
    
    return index;
}

- (NSString *)transformToPinyin:(NSString *)str {
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}

#pragma  mark 字母转换大小写--6.0
-(NSString*)upperStr:(NSString*)str{
    // 全部转换为小写
    NSString *lowerStr = [str lowercaseStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"lowerStr: %@", lowerStr);
    return lowerStr;
}
#pragma mark 排序
-(NSArray*)sortMethod
{
    NSArray*array=  [self.dataArray sortedArrayUsingFunction:cmp context:NULL];
    return array;
}
//构建数组排序方法SEL
//NSInteger cmp(id, id, void *);
NSInteger cmp(NSString * a, NSString* b, void * p)
{
    if([a compare:b] == 1){
        return NSOrderedDescending;//(1)
    }else
        return  NSOrderedAscending;//(-1)
}

+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@", (__bridge NSError *)error);
                }else if (!granted) {
                    block(NO);
                }else {
                    block(YES);
                }
            });
        });
    }else {
        block(YES);
    }
}

- (void)upLoadAddressBook {
    NSMutableArray *addressBook = [[UserDefaults objectForKey:@"contacts"] mutableCopy];
    if (![UserManager sharedUserManager].isLogin) {
        return;
    }
    if (addressBook.count == 0) {
        addressBook = [self uploadAddress];
        if (addressBook.count == 0) {
            return;
        }
    }else {
        [addressBook removeAllObjects];
        addressBook =  [self uploadAddress];
    }
    
    NSMutableArray *package = [self deleteduplicateWith:addressBook];
    package = [self saveAddressBook:package];
    if (package != nil && package.count>0) {
        NSString *jsonString = [[NetworkSingleton sharedManager] DataTOjsonString:package];
        NSLog(@"%@",jsonString);
        [self.requestVer updateContactsWithDictionary:@{@"data":jsonString,@"type":@"3"} success:^(NSDictionary *dictResult) {
            //        NSLog(@"通讯录上传成功");
            printf("通讯录上传成功");
            JQFMDB *db = [JQFMDB shareDatabase:@"ContactsBook.sqlite"];
            
            for (NSDictionary *tDict in package) {
                NSString *phoneStr = tDict[@"mobile"];
                [db jq_insertTable:@"contacts" dicOrModel:@{@"name":tDict[@"name"],@"user_id":tDict[@"user_id"]}];
                NSString *whereStr = [NSString stringWithFormat:@"where name = '%@'",tDict[@"name"]];
                [db jq_updateTable:@"contacts" dicOrModel:@{@"mobile":phoneStr} whereFormat:whereStr];
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadAddressSuccess" object:nil];
        } failed:^(NSInteger code, NSString *errorMsg) {
            printf("通讯录上传失败");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadAddressSuccess" object:nil];
        }];
    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadAddressSuccess" object:nil];
    }
}
///获取数据库通讯录
-(NSMutableArray *)saveAddressBook:(NSArray *)addressBook{
    NSString *tableName = [NSString stringWithFormat:@"contacts"];
    JQFMDB *db = [JQFMDB shareDatabase:@"ContactsBook.sqlite"];
    [db jq_createTable:tableName dicOrModel:@{@"name":@"TEXT",@"user_id":@"TEXT",@"mobile":@"TEXT"}];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *selectStr = [NSString stringWithFormat:@"where user_id = '%@'",[UserManager sharedUserManager].userInfo.uid];
    NSMutableArray *personArr = [[db jq_lookupTable:tableName dicOrModel:@{@"name":@"TEXT",@"user_id":@"TEXT",@"mobile":@"TEXT"} whereFormat:nil] mutableCopy];
    
    if (![personArr isEqualToArray:addressBook]) {
        //数据库中多余的
        for (NSDictionary *tDict in personArr) {
            if (![addressBook containsObject:tDict]) {
                NSString *whereStr = [NSString stringWithFormat:@"where name = '%@' AND user_id = '%@'",tDict[@"name"],tDict[@"user_id"]];
                [db jq_deleteTable:tableName whereFormat:whereStr];
            }
        }
        personArr = [[db jq_lookupTable:tableName dicOrModel:@{@"name":@"TEXT",@"user_id":@"TEXT",@"mobile":@"TEXT"} whereFormat:nil] mutableCopy];
        
        
        if (![personArr isEqualToArray:addressBook]) {
            for (NSDictionary * tDict in addressBook){
                if (![personArr containsObject:tDict]) {
                    [array addObject:tDict];
                }
            }
        }
        return array;
    }else{
        return nil;
    }
}

//去重
- (NSMutableArray *)deleteduplicateWith:(NSMutableArray *)addressBook {
    NSMutableArray * contact = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrContent = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * tDict in addressBook.lastObject) {
        if (![contact containsObject:tDict[@"mobile"]]) {
            [contact addObject:tDict[@"mobile"]];
            [arrContent addObject:tDict];
        }
    }
    return arrContent;
}

-(NSMutableArray *)uploadAddress {
    NSMutableArray *addressBook;
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray * titleArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrData = [NSMutableArray arrayWithCapacity:0];
    if ([self getPersonInfo]&&[self sortMethod]) {
        dataDic = [self getPersonInfo];
        titleArr = [[self sortMethod] mutableCopy];
        arrData = [NSMutableArray arrayWithCapacity:0];
        
        [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *indexString = obj;
            NSInteger index = idx;
            [arrData addObject:[@[] mutableCopy]];
            NSArray *tempArr = dataDic[indexString];
            [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrData[index] addObject:obj];
            }];
        }];
    }
    if (arrData.count>0) {
        NSMutableArray *packageArray = [@[] mutableCopy];
        [packageArray addObject:[@[] mutableCopy]];
        __weak __typeof(self)weskSelf = self;
        [arrData enumerateObjectsUsingBlock:^(NSArray  *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj1 enumerateObjectsUsingBlock:^(NSDictionary *obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *phoneStr = [weskSelf phoneNumClear:obj2[@"mobile"]];
                [[packageArray lastObject] addObject:[NSDictionary dictionaryWithObjects:@[obj2[@"name"],phoneStr,[UserManager sharedUserManager].userInfo.uid == nil ? @"" : [UserManager sharedUserManager].userInfo.uid] forKeys:@[@"name",@"mobile",@"user_id"]]];
            }];
        }];
        [UserDefaults setObject:packageArray forKey:@"contacts"];
        addressBook = packageArray;
    }
    return addressBook;
}

///过滤手机号
- (NSString *)phoneNumClear:(NSString *)str {
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    str = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    str = [[str componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    NSString *phone = [[NSString alloc] initWithFormat:@"%@",str];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"　" withString:@""];
    return phone;
}

//- (NSMutableArray *)phoneNumClears:(NSArray *)array {
//    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
//    for (__strong NSString *phone in array) {
//        if(phone.length > 0){
//            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
//            phone = [[phone componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
//            phone = [[phone componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
//
//            NSString *phoneStr = [[NSString alloc] initWithFormat:@"%@",phone];
//            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
//            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
//            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@")" withString:@""];
//            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"　" withString:@""];
//            [phoneArray addObject:phoneStr];
//        }
//    }
//    return phoneArray;
//}

- (CertificationCenterRequest *)requestVer {
    if (!_requestVer) {
        _requestVer = [[CertificationCenterRequest alloc] init];
    }
    return _requestVer;
}

@end

