//
//  DataObject.h
//  Text Search
//
//  Created by Wu Peter on 2016/3/6.
//  Copyright © 2016年 Wu Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataObject : NSObject
@property (nonatomic) BOOL                  anonymous;
@property (nonatomic) NSUInteger            viewCount;
@property (nonatomic) NSUInteger            tractionIndex;
@property (nonatomic) NSUInteger            wannaknowCount;
@property (nonatomic) NSUInteger            answerCount;
@property (nonatomic, strong) NSString      *updateAt;
@property (nonatomic, strong) NSString      *objectId;
@property (nonatomic, strong) NSString      *createdAt;
@property (nonatomic, strong) NSString      *content;
@property (nonatomic, strong) NSString      *university;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSDictionary  *_id;
@property (nonatomic, strong) NSDictionary  *author;
@property (nonatomic, strong) NSDictionary  *created;
@property (nonatomic, strong) NSDictionary  *ACL;
- (id) initWithDataObject:(NSDictionary *)dataDict;
@end
