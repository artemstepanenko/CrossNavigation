//
//  CNTabBarController.h
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 17/05/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNViewControllerProtocol.h"

@interface CNTabBarController : UITabBarController <CNViewControllerProtocol>

@property (nonatomic) IBInspectable NSString *leftID;
@property (nonatomic) IBInspectable NSString *topID;
@property (nonatomic) IBInspectable NSString *rightID;
@property (nonatomic) IBInspectable NSString *bottomID;

@end
