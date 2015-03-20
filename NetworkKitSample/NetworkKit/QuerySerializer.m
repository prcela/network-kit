//
//  QuerySerializer.m
//  MdmStory
//
//  Created by Kresimir Prcela on 07/01/14.
//  Copyright (c) 2014 100kas. All rights reserved.
//

#import "QuerySerializer.h"

@implementation QuerySerializer

+(NSString*)serialize:(NSDictionary*)query
{
    NSMutableArray *params = [NSMutableArray new];
    for (NSString *key in query)
    {
        id obj = [query objectForKey:key];
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            for (NSString *keydic in obj)
            {
                id value = obj[keydic];
                if ([value isKindOfClass:[NSArray class]])
                {
                    for (id childObj in value)
                    {
                        if ([childObj isKindOfClass:[NSString class]])
                        {
                            NSString *str = (NSString*)childObj;
                            [params addObject:[NSString stringWithFormat:@"%@[]=%@", key, str]];
                        }
                        else if ([childObj isKindOfClass:[NSDictionary class]])
                        {
                            for (NSString *childKey in childObj)
                            {
                                [params addObject:[NSString stringWithFormat:@"%@[%@][%lu][%@]=%@", key, keydic, (unsigned long)[value indexOfObject:childObj], childKey, childObj[childKey]]];
                            }
                        }
                    }

                }
                else
                {
                    [params addObject: [NSString stringWithFormat:@"%@[%@]=%@", key, keydic, value]];
                }
                
            }
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            for (id childObj in obj)
            {
                if ([childObj isKindOfClass:[NSString class]])
                {
                    NSString *str = (NSString*)childObj;
                    [params addObject:[NSString stringWithFormat:@"%@[]=%@", key, str]];
                }
                else if ([childObj isKindOfClass:[NSDictionary class]])
                {
                    for (NSString *keydic in childObj)
                    {
                        [params addObject:[NSString stringWithFormat:@"%@[%lu][%@]=%@", key, (unsigned long)[obj indexOfObject:childObj], keydic, childObj[keydic]]];
                    }
                }
            }
        }
        else if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])
        {
            [params addObject: [NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }
    return [params componentsJoinedByString:@"&"];
}

@end
