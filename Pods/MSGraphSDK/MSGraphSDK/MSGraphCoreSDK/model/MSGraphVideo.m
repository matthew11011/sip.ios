// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import "NSDate+MSSerialization.h"

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphVideo()
{
    int32_t _bitrate;
    int64_t _duration;
    int32_t _height;
    int32_t _width;
}
@end

@implementation MSGraphVideo

- (int32_t) bitrate
{
    _bitrate = [self.dictionary[@"bitrate"] intValue];
    return _bitrate;
}
- (void) setBitrate: (int32_t) val
{
    _bitrate = val;
    self.dictionary[@"bitrate"] = @(val);
}
- (int64_t) duration
{
    _duration = [self.dictionary[@"duration"] longLongValue];
    return _duration;
}
- (void) setDuration: (int64_t) val
{
    _duration = val;
    self.dictionary[@"duration"] = @(val);
}
- (int32_t) height
{
    _height = [self.dictionary[@"height"] intValue];
    return _height;
}
- (void) setHeight: (int32_t) val
{
    _height = val;
    self.dictionary[@"height"] = @(val);
}
- (int32_t) width
{
    _width = [self.dictionary[@"width"] intValue];
    return _width;
}
- (void) setWidth: (int32_t) val
{
    _width = val;
    self.dictionary[@"width"] = @(val);
}
@end
