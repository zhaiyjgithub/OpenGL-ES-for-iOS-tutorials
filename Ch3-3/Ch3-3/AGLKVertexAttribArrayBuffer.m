//
//  AGLKVertexAttribArrayBuffer.m
//  Ch3-1
//
//  Created by zack on 2016/12/6.
//  Copyright © 2016年 zack. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@implementation AGLKVertexAttribArrayBuffer


/**
  把顶点数据保存到申请的缓存中

 @param aStride 步幅
 @param count 顶点的个数
 @param dataPtr 顶点坐标的数组
 @param usage <#usage description#>
 @return <#return value description#>
 */
- (id)initWithAttribStride:(GLsizei)aStride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr usage:(GLenum)usage{

    if (self = [super init]) {
        self.stride = aStride;
        self.bufferSizeBytes = count * self.stride;
        
        glGenBuffers(1, &_name);
        glBindBuffer(GL_ARRAY_BUFFER, self.name);
        glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, usage);
        
        NSAssert(0 != self.name, @"failed to generate buffer name"); 
    }
    return self;
}


/**
 重置当前绑定的缓存数据

 @param aStride <#aStride description#>
 @param count <#count description#>
 @param dataPtr <#dataPtr description#>
 */
- (void)reinitWithAttribStride:(GLsizei)aStride numberOfVertices:(GLint)count bytes:(const GLvoid *)dataPtr{
    self.stride = aStride;
    self.bufferSizeBytes = count * self.stride;
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);
}


/**
 使能坐标读取以及指定顶点坐标的组成等参数

 @param index <#index description#>
 @param numberOfCoordinates <#numberOfCoordinates description#>
 @param offset <#offset description#>
 @param shouleEnable <#shouleEnable description#>
 */
- (void)prepareToDrawWithAttrib:(GLint)index numberOfCoordinates:(GLint)numberOfCoordinates attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouleEnable{
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    
    if (shouleEnable) {
        glEnableVertexAttribArray(index);
    }
    
    glVertexAttribPointer(index, numberOfCoordinates, GL_FLOAT, GL_FALSE, (self.stride), NULL + offset);
}


/**
 绘制模型

 @param mode <#mode description#>
 @param first <#first description#>
 @param count <#count description#>
 */
- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLint)count{
    glDrawArrays(mode, first, count);
}

@end
