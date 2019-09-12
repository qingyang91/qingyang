//
//  SSL.h
//  PowerWallet
//
//  Created by Krisc.Zampono on 2017/8/4.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest(SSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end
