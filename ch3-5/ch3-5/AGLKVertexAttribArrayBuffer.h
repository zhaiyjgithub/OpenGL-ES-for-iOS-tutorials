//
//  AGLKVertexAttribArrayBuffer.h
//  Ch3-1
//
//  Created by zack on 2016/12/6.
//  Copyright © 2016年 zack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef enum{
    AGLKVertexAttribPosition = GLKVertexAttribPosition,
    AGLKVertexAttribNormal = GLKVertexAttribNormal,
    AGLKVertexAttribColor = GLKVertexAttribColor,
    AGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    AGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
} AGLKVertexAttrib;

@interface AGLKVertexAttribArrayBuffer : NSObject
@property(nonatomic,assign)GLsizei stride; //步幅
@property(nonatomic,assign)GLsizeiptr bufferSizeBytes; //缓存数据指针
@property(nonatomic,assign)GLuint name;//

- (id)initWithAttribStride:(GLsizei)aStride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr usage:(GLenum)usage;
- (void)reinitWithAttribStride:(GLsizei)aStride numberOfVertices:(GLint)count bytes:(const GLvoid *)dataPtr;
- (void)prepareToDrawWithAttrib:(GLint)index numberOfCoordinates:(GLint)numberOfCoordinates attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouleEnable;
- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLint)count;
@end
