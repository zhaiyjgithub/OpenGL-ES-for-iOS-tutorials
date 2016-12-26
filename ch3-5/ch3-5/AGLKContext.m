//
//  AGLKContext.m
//  Ch3-1
//
//  Created by zack on 2016/12/6.
//  Copyright © 2016年 zack. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext


- (void)setClearColor:(GLKVector4)clearColor{
    _clearColor = clearColor;
    
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}

- (void)clear:(GLenum)mask{
    glClear(mask);
}

- (void)enable:(GLenum)capability{
    glEnable(capability);
}

- (void)disable:(GLenum)capability{
    glDisable(capability);
}



@end
