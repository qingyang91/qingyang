//
//  SSL.m
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/4.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "NSURLRequest+SSL.h"

@implementation NSURLRequest(SSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}
@end
