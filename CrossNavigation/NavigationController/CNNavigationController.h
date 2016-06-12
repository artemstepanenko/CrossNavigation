//
//  CNNavigationController.h
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 12/06/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNViewControllerProtocol.h"

@interface CNNavigationController : UINavigationController <CNViewControllerProtocol>

@property (nonatomic) IBInspectable NSString *leftID;
@property (nonatomic) IBInspectable NSString *topID;
@property (nonatomic) IBInspectable NSString *rightID;
@property (nonatomic) IBInspectable NSString *bottomID;

@end
