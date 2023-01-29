# 从零开始的BRP---MBRP

本仓库会配合语雀以及Bilibili使用
**语雀地址**：[从零开始的BRP]([从零开始的BRP (yuque.com)](https://www.yuque.com/mineself/sra9a9))
**Bilibili个人空间地址**：[mineself的个人空间](https://space.bilibili.com/3638820?spm_id_from=333.788.0.0)



### 前言

=====================================================

简单来说，这就是个人笔记库，本人的写所有Shader都会放在上面，
制作这个系列有几个目的：**作品集、分享、复习**

总的来说，写Shader写到现在，遇到的问题不少，
**每次我的思考方式都是这样的：**
如果很简单，那么就直接对着写，然后稍微分析一下；
如果是有难度的内容，那么很容易在编写时就出现问题，那么就需要先排错然后再逐行分析代码，怎么样都得把原来这么写的理由找出来，**但是**如果到网上去找资料的话，尤其是跟着教程的内容，比如说入门精要，你会发现类似csdn这种地方，很多都是直接把代码贴过来了，你想要看到的其中分析的内容非常难找到，有些分析也是大体思路，但我想找到的是其中一句的分析是很难的，有也是一笔带过

**还有一个问题就是：**
即使我分析出其中的内容，我也写不出这些内容，大概思路有，可就是在细节方面上没法写下去
自己独立写完(不看资料)和对照着写其实差距是非常大的

那么这个系列就会较为详细地对这些内容进行分析，在每一节课中都会放置1P进行手写代码(有时肯定会忘记一些内容的，但是问题不大；有些内容不是一时半会能写出来的，对于这种内容应该不会完全手写)





### 使用方法

=====================================================

会在Github、Bilibili、语雀同步更新

在**Github**可以获取代码/PPT

在**Bilibili**一般会分为3P：
**1P**---效果展示
**2P**---我会使用PPT完整地讲解一遍
**3P**---手写代码以及最后的总结

在**语雀**会贴出代码，一般会使用比较通俗的方式进行分析





### 主题

=====================================================

大致分为以下几类：
**基础类**---主要有光照部分，贴图部分，还有一些用于物体的效果
**特效类**---各类特效，如：护盾效果、溶解效果
**进阶类**---一些比较困难的内容，如：ComputeShader、室内映射、草渲染(GeometryShader)
**卡通渲染**---一些需要特殊处理来获得卡通风格的Shader，最常见的就是原神渲染了
**后处理**---附加在屏幕上的效果
**图形类**---噪声的生成、遮罩的制作、过场动画，这些都是图形的运用
**工具类**---一些实用工具，比如制作Cubemap的工具
**其他**---会有一些可能不是Shader的内容，可能是有关脚本的，可能是一些注意事项，也有可能是针对函数的分析
