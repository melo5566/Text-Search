//
//  DataObject.m
//  Text Search
//
//  Created by Wu Peter on 2016/3/6.
//  Copyright © 2016年 Wu Peter. All rights reserved.
//

#import "DataObject.h"

@implementation DataObject

- (id)initWithDataObject:(NSDictionary *)dataDict {
    if (self) {
        @try {
            _updateAt = dataDict[@"updatedAt"];
            _tractionIndex = [dataDict[@"tractionIndex"] integerValue];
            _author = dataDict[@"author"];
            _anonymous = [dataDict[@"anonymous"] boolValue];
            _wannaknowCount = [dataDict[@"wannaknowCount"] integerValue];
            __id = dataDict[@"_id"];
            _answerCount = [dataDict[@"answerCount"] integerValue];
            _university = dataDict[@"university"];
            _created = dataDict[@"created"];
            _objectId = dataDict[@"objectId"];
            _ACL = dataDict[@"ACL"];
            _viewCount = [dataDict[@"viewCount"] integerValue];
            _createdAt = dataDict[@"createdAt"];
            _content = dataDict[@"content"];
            _title = dataDict[@"title"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;
}

@end
