//
//  ViewController.m
//  Ch3-3
//
//  Created by zack on 2016/12/16.
//  Copyright © 2016年 zack. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"


@interface GLKEffectPropertyTexture (AGLKAdditions) //扩展 GLKEffectPropertyTexture类

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value{
    glBindTexture(self.target, self.name);
    
    glTexParameteri(
                    self.target,
                    parameterID,
                    value);
}

@end


typedef struct{
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};


//默认坐标点,用于测试循环模式
static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

@interface ViewController ()
@property(nonatomic,strong)GLKBaseEffect * baseEffect;
@property(nonatomic,strong)AGLKVertexAttribArrayBuffer * vertexBuffer;
@property(nonatomic,assign)GLfloat sCoordinateOffset;
@property(nonatomic,assign)BOOL isNestestMdoe;
@property(nonatomic,assign)BOOL isCycleMdoe;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView * view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view is not a glkView!");
    
    view.context = [(AGLKContext *)[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2
                    ];
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) bytes:vertices usage:GL_DYNAMIC_DRAW];
    
    CGImageRef imageRef = [UIImage imageNamed:@"grid.png"].CGImage;
    GLKTextureInfo * textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
   //设置纹理的循环模式 重复模式GL_REPEAT：边缘模式GL_CLAMP_TO_EDGE
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}

- (void)update{
    
    int i =0;
    for(i = 0; i < 3; i++)
    {
        vertices[i].textureCoords.t =
        (defaultVertices[i].textureCoords.t +
         self.sCoordinateOffset);
    }
    
    [self.baseEffect.texture2d0
     aglkSetParameter:GL_TEXTURE_WRAP_T
     value:(self.isCycleMdoe ?
            GL_REPEAT : GL_CLAMP_TO_EDGE)];
    
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_MAG_FILTER value:self.isNestestMdoe == YES ?  GL_LINEAR : GL_NEAREST];
    
    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex)
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                   bytes:vertices];
}

- (IBAction)changeSampleMode:(UISwitch *)sender {
    self.isNestestMdoe = sender.isOn;
}

- (IBAction)changeCycleMode:(UISwitch *)sender {
    self.isCycleMdoe = sender.isOn;
}

- (IBAction)changeVertices:(UISlider *)sender {
    self.sCoordinateOffset = sender.value;
}

@end
