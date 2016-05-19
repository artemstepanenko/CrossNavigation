//
//  CNViewControllerCore.h
//  CNStoryboardExample
//
//  Created by Artem Stepanenko on 5/19/16.
//  Copyright © 2016 Artem Stepanenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cn_direction.h"

@class UIViewController;
@protocol CNViewControllerProtocol;

@interface CNViewControllerCore : NSObject

@property (nonatomic) NSString *leftID;
@property (nonatomic) NSString *topID;
@property (nonatomic) NSString *rightID;
@property (nonatomic) NSString *bottomID;
@property (nonatomic) Class leftClass;
@property (nonatomic) Class topClass;
@property (nonatomic) Class rightClass;
@property (nonatomic) Class bottomClass;

- (instancetype)initWithViewController:(UIViewController<CNViewControllerProtocol> *)viewController;

- (void)presentViewController:(UIViewController<CNViewControllerProtocol> *)viewController
                    direction:(CNDirection)direction
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion;

- (void)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)(void))completion;

- (void)dismissViewControllerToDirection:(CNDirection)direction
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion;

- (void)viewDidLoad;

@end
