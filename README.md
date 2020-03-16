# BBLayout
## 介绍：

>  本框架能同时布局多个view，只需将要布局的试图放到layout里，设置对齐方式以及间距即可完成布局。

## BB缩写含义

> 期望写布局就像玩积木[(Building Blocks)](https://baike.baidu.com/item/积木/10820775?fromtitle=building%20blocks&fromid=18082107&fr=aladdin)一样简单便捷有乐趣。所以，BBLayout又叫积木布局。

## Usage

### Sample Code (Objective-C)

1. 定义对象或者属性

   ```objective-c
   BBLayoutView *layoutView = nil;
   ```

2. 创建layoutView

   ```objective-c
   CGRect rc = CGRectMake(0, naviBarHeight(), SCREEN_WIDTH, 50);
   _layoutView = [BBLayoutView layoutWithFrame:rc horizontalAlignment:BBLayoutHorizontalAlignmentCenter];
   
   ```

3. 添加要布局的view

   ```objective-c
   [_layoutView addView:v1 leading:10];
   [_layoutView addView:v2] leading:20];
   [_layoutView addView:v3] leading:30];
   [_layoutView addView:v4] leading:5];
   ```

4. 加到父view上

   ```objective-c
   [self.view addSubview:_layoutView];
   ```

## Demo效果(代码中都有的)

![](https://github.com/shaozg/BBLayout/blob/master/BBLayout/DemoVC/demo.gif)

## 其它



> 优势：

* 布局依赖低，view之间不会明确依赖关系
* 支持多行模式布局
* 支持6种水平布局和5种垂直对齐方式