//------------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "MSALTokenCacheKey.h"

@implementation MSALTokenCacheKey

- (id)initWithAuthority:(NSString *)authority
               clientId:(NSString *)clientId
                  scope:(MSALScopes *)scope
                   user:(MSALUser *)user
{
    return [self initWithAuthority:authority
                          clientId:clientId
                             scope:scope
                          uniqueId:user.uniqueId
                     displayableId:user.displayableId
                      homeObjectId:user.homeObjectId];
}

- (id)initWithAuthority:(NSString *)authority
               clientId:(NSString *)clientId
                  scope:(MSALScopes *)scope
               uniqueId:(NSString *)uniqueId
          displayableId:(NSString *)displayableId
           homeObjectId:(NSString *)homeObjectId
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    self.authority = [authority lowercaseString];
    self.clientId = [clientId lowercaseString];
    self.scope = scope;
    if (!self.scope)
    {
        scope = [NSOrderedSet<NSString *> new];
    }
    self.uniqueId = [uniqueId lowercaseString];
    self.displayableId = [displayableId lowercaseString];
    self.homeObjectId = [homeObjectId lowercaseString];
    
    return self;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@",
            self.authority.msalBase64UrlEncode,
            self.clientId.msalBase64UrlEncode,
            self.scope.msalToString.msalBase64UrlEncode,
            self.displayableId.msalBase64UrlEncode,
            self.uniqueId.msalBase64UrlEncode,
            self.homeObjectId.msalBase64UrlEncode];
}

- (BOOL)matches:(MSALTokenCacheKey *)other
{
    return [self.authority isEqualToString:other.authority] &&
    [self.clientId isEqualToString:other.clientId] &&
    [other.scope isSubsetOfOrderedSet:self.scope] &&
    [self.uniqueId isEqualToString:other.uniqueId] &&
    [self.displayableId isEqualToString:other.displayableId] &&
    [self.homeObjectId isEqualToString:other.homeObjectId];
}

@end
