//
//  AGLKContext.h
//  Ch3-1
//
//  Created by zack on 2016/12/6.
//  Copyright © 2016年 zack. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext

@property(nonatomic,assign)GLKVector4 clearColor;
- (void)clear:(GLenum)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;

@end
