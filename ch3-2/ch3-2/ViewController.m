//
//  ViewController.m
//  ch3-2
//
//  Created by zack on 2016/12/9.
//  Copyright © 2016年 zack. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

@interface ViewController ()
@property(nonatomic,strong)GLKBaseEffect * baseEffect;
@property(nonatomic,strong)AGLKVertexAttribArrayBuffer * vertexBuffer;
@end

@implementation ViewController

typedef struct{
    GLKVector3  positionCoords; //顶点坐标{x,y,z}
    GLKVector2  textureCoords;//纹理映射坐标{u,v}
}
SceneVertex;

//定义包含映射到纹理的坐标
static const SceneVertex vertices[] ={
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView * view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view is not glkview");
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1);
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) bytes:vertices usage:GL_STATIC_DRAW];
    
    //使用一章图片生成一个2D纹理
    CGImageRef imageRef = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    GLKTextureInfo * textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    //将纹理赋给baseEffect
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    
    //准备好纹理坐标
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    
    //渲染一个有纹理的三角形
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}


@end
