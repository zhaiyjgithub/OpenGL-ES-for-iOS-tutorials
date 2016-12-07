//
//  ViewController.m
//  Ch3-1
//
//  Created by zack on 2016/12/6.
//  Copyright © 2016年 zack. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoors;
}
SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}}, // upper left corner
};

@interface ViewController ()
@property(nonatomic,strong)GLKBaseEffect * baseEffect;
@property(nonatomic,strong)AGLKVertexAttribArrayBuffer * vertexBuffer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView * view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view controller`s view is not glkView");
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                         bytes:vertices usage:GL_STATIC_DRAW];
    
    int offset = offsetof(SceneVertex, positionCoors);
    NSLog(@"offset:%d",offset);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoors) shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}


@end
