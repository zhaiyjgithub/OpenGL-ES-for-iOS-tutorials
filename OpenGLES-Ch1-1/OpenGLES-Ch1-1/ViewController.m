//
//  ViewController.m
//  OpenGLES-Ch1-1
//
//  Created by zack on 2016/11/30.
//  Copyright © 2016年 zack. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,assign)GLuint vertexBufferID;
@property(nonatomic,strong)GLKBaseEffect * baseEffect;
@end

typedef struct {
    GLKVector3 positionCoords; //使用OpenGL ES 内置的数据类型，这个是一个联合体union
}
SceneVertex;

//这里也是不用直接使用结构体的。因为联合体里面有个包含3个成员的数组。刚好三个成员就是表示xyz空间坐标轴的三个点
//那么以后使用自动脚本生成连续的顶点数组将更加方便
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}}, // low er left corner
    {{ 0.8f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}  // upper left corner
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
   // int length = sizeof(GLKVector3); //一个指针就是4个字节。这个结构体是一个联合体。该结构体中的成员，占据内存最长的一个是3*4 = 12个字节
    //上面的取值方式跟直接数组集合是有区别的。数组里面就是顶点坐标连续在一起的。这个要区分下面寻址方式了。不管怎样，先按照当前教程的方式填充模型数据以及使用当亲啊已经定义好的数据模型
    
    //创建一个OpenGL ES2.0的上下文到当前的view
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    //将view的上下文设置到当前的上下文
    [EAGLContext setCurrentContext:view.context];
    
    //创建一个基本的OpenGL ES 2.0 的effect 对象
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.0, 1.0, 1.0, 1.0);
    
    //设置当前context的背景颜色
    glClearColor(0, 0, 0, 0);
    
    //获取一个独一无二的缓存ID
    glGenBuffers(1, &(_vertexBufferID));
    
    //将这个buffer ID绑定到一个申请的buffer中
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    
    // 将顶点的数据放到刚才申请的buffer中,因为当前的顶点数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
}

//屏幕每帧都会自动调用这个方法，同update，view的渲染使用glkView
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.baseEffect prepareToDraw];
    
    //清除buffer之前的数据
    glClear(GL_COLOR_BUFFER_BIT);
    
    //使能从buffer读取顶点数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //设置顶点的数据指针 sizeof(SceneVertex) = 12 个字节 
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);
    
    //开始绘图
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

//同上，数据的更新使用update
- (void)update{
    
}

@end
