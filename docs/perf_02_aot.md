&nbsp;:book: [查看本文案例](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/IM/Chat)

<p align="center">
  <h1 align="center">OpenHarmony使用AOT提升应用性能</h1>
</p>

- 摘要：AOT，即Ahead of Time预编译，在应用程序运行之前将代码编译成机器码，获得充分编译优化。放
到端设备上运行的时候就可以获得加速，从而提高应用程序的性能。本文会介绍如何使用AOT提升应用响应性能。

- 关键字：OpenHarmony HarmonyOS 鸿蒙 AOT 预先编译 预编译 Ahead of Time PGO Profile-Guided-Optimization

## 概述

AOT（Ahead Of Time）即预先编译，在应用程序运行前，将代码预先编译成高性能机器代码，避免在运行时的
编译性能消耗和内存消耗，让程序在首次运行就能通过执行高性能机器码获得性能收益。

方舟 AOT 编译器实现了 PGO (Profile-Guided-Optimization）编译优化，即通过结合预先 profiling 的运行
时类型等信息和静态类型信息，预先静态地生成高性能优化机器代码。在方舟 AOT 编译器中，记录预先 profiling 
运行时类型等信息的文件称为 ap(ark profiling)文件。

对性能有高要求的开发者可通过在 DevEco Studio 完成相关的编译配置，使用 AOT 编
译提升应用运行性能。

按方舟 AOT 编译器的运行环境，可以分为 Target AOT 和 Host AOT。

 - Target AOT（推荐）：在真机上运行 AOT 编译器，从 API 10 开始支持。
 - Host AOT：在 Host 端（即运行 DevEco Studio 的电脑）运行 AOT 编译器，API 9支持。

## 环境准备

从DevEco Studio 4.0 Beta2版本开始集成ArkUI Inspector工具，可以从[OpenHarmony-v4.0-beta2 Release Notes#配套关系](https://gitee.com/openharmony/docs/blob/master/zh-cn/release-notes/OpenHarmony-v4.0-beta2.md#%E9%85%8D%E5%A5%97%E5%85%B3%E7%B3%BB)部分下载DevEco Studio 4.0 Beta2版本。

## 使用场景

什么应用，什么场景适合使用AOT？

## 开启AOT编译模式


## 性能实践

我们以一个实际案例来看下如何借助AOT来提升应用程序性能。



## 注意事项

> 当前仅支持 API 9 及以上版本 Stage 模型的 ArkTS 工程。
> 
> 目前仅 HAP 和 HSP 支持该功能。
> 
> Node.js 需要 14.19.1 以上版本。
> 
> 仅支持在 64 位 ROM 上运行。
> 
> 不支持混淆，需要关闭混淆功能。

## 参考资料

[[1] Sample聊天实例应用](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/IM/Chat)。

[[2] OpenHarmony-v4.0-beta2 Release Notes](https://gitee.com/openharmony/docs/blob/master/zh-cn/release-notes/OpenHarmony-v4.0-beta2.md)
