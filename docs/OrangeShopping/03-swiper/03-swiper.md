# openharmony 如何实现轮播图

### 场景说明

轮播图出现在各种网站和app首页，很容易抓取浏览者的注意力，在介绍产品的同时强化品牌影响力。作为一种常见的动画呈现形式，自然为openharmony应用开发框架所支持。

本例基于openharmony项目sample桔子购物，为大家介绍滑块视图容器**Swiper**，该组件提供子组件滑动轮播显示的能力。**sample源码获取**：[桔子购物sample · OpenHarmony - Gitee.com](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/OrangeShopping)。

**注意事项**：获取源码请不要直接点击下载zip，这样会导致一些模块无法导入。请确认本地已经安装git，打开git bash，如果没有安装`git lfs`请运行`git lfs install`进行安装，因为该仓包含一些lfs管理的大文件。git lfs安装成功后，通过git clone的方式将sample仓下载到本地。源码页面也提供了单独下载该工程的命令，请下滑到其页面末尾获取。

### 效果呈现

首页轮播图的实现效果如下：

![swiper](swiper.gif)

### 实现介绍

如果你想要获取轮播图的**使用示例**，可以查看：[轮播组件(Swiper) · OpenHarmony/docs - Gitee.com](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-layout-development-create-looping.md)

在该sample中，轮播图实现的**核心代码**位于：`OrangeShopping/feature/navigationHome/src/main/ets/components/home/Swiper.ets`

摘录如下：

```typescript
import { INDEX_DATA } from '../../mock/ProductsData'

@Component
export struct SwiperComponent {
  @StorageProp('curBp') curBp: string = 'md'

  build() {
    Swiper() {
      ForEach(INDEX_DATA, item => {
        Image(item.img)
          .objectFit(ImageFit.Cover)
          .width('100%')
          .height('100%')
          .borderRadius(16)
      })
    }
    .padding({ left: 12, right: 12 })
    .height(170)
    .autoPlay(true)
    .itemSpace(20)
    .displayCount(this.curBp === 'sm' ? 1 : this.curBp === 'md' ? 2 : 3)
    .indicatorStyle({
      selectedColor: $r('app.color.red'),
      color: $r('app.color.white')
    })
  }
}
```



##### 1、Swiper组件介绍

首先，对于屏幕尺寸进行说明：xs代表最小宽度类型设备，sm代表小屏，md代表中屏，lg代表大屏。通过Swiper的`.displayCount()`属性，对不同尺寸的窗口设置不同的每页子组件显示个数。此处状态变量curBp被StorageProp装饰器所装饰，将与AppStorage建立单向数据绑定，该状态变量的值将使用AppStorage中的值进行初始化，AppStorage中的属性值的更改会导致绑定的UI组件进行状态更新。装饰器在这里不做赘述，有兴趣可以查看文档：[应用级变量的状态管理 · HarmonyOS应用开发](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/ets-state-mgmt-application-level-0000001119769576)。

在Swiper组件中通过ForEach函数遍历INDEX_DATE这个SwiperModel数组，将每一个SwiperModel对象中的图片用Image组件展示出来。代码中涉及到的Swiper组件的特有属性用法如下：

| 名称             | 参数类型                                                     | 描述                                                         |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| autoPlay         | boolean                                                      | 子组件是否自动播放，自动播放状态下，导航点不可操作。默认值：false |
| itemSpace        | number \| string                                             | 设置子组件与子组件之间间隙。默认值：0                        |
| displayCount8+   | number \| string                                             | 设置一页中显示子组件的个数，设置为“auto”时等同于SwiperDisplayMode.AutoLinear的显示效果。默认值：1 |
| indicatorStyle8+ | {left?: [Length](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-types-0000001281480778#ZH-CN_TOPIC_0000001281480778__length),top?: [Length](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-types-0000001281480778#ZH-CN_TOPIC_0000001281480778__length),right?: [Length](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-types-0000001281480778#ZH-CN_TOPIC_0000001281480778__length),bottom?: [Length](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-types-0000001281480778#ZH-CN_TOPIC_0000001281480778__length),size?: [Length](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-types-0000001281480778#ZH-CN_TOPIC_0000001281480778__length),mask?: boolean,color?: [ResourceColor](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-types-0000001281480778#ZH-CN_TOPIC_0000001281480778__resourcecolor8),selectedColor?: [ResourceColor](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-types-0000001281480778#ZH-CN_TOPIC_0000001281480778__resourcecolor8)} | 设置导航点样式：- left: 设置导航点距离Swiper组件左边的距离。- top: 设置导航点距离Swiper组件顶部的距离。- right: 设置导航点距离Swiper组件右边的距离。- bottom: 设置导航点距离Swiper组件底部的距离。- size: 设置导航点的直径。- mask: 设置是否显示导航点蒙层样式。- color: 设置导航点的颜色。- selectedColor: 设置选中的导航点的颜色。 |

如果想要了解更多Swiper组件属性，请查阅：

[Swiper容器组件 · HarmonyOS应用开发](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-container-swiper-0000001333321221)

涉及的Image组件的特有属性用法如下：

| 名称      | 参数类型                                                     | 默认值 | 描述                 |
| --------- | ------------------------------------------------------------ | ------ | -------------------- |
| objectFit | [ImageFit](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-appendix-enums-0000001281201130#ZH-CN_TOPIC_0000001281201130__imagefit) | Cover  | 设置图片的缩放类型。 |

如果想要了解更多Image组件属性，请查阅：

[Image-基础组件 · HarmonyOS应用开发](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-basic-components-image-0000001281001226)

如果想要获取Image组件的使用示例，请查阅：

[显示图片(Image) · OpenHarmony/docs - Gitee.com](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-graphics-display.md)

ImageFit参数包含如下选项：

| 名称      | 描述                                                         |
| :-------- | :----------------------------------------------------------- |
| Contain   | 保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内。   |
| Cover     | 保持宽高比进行缩小或者放大，使得图片两边都大于或等于显示边界。 |
| Auto      | 自适应显示                                                   |
| Fill      | 不保持宽高比进行放大缩小，使得图片充满显示边界。             |
| ScaleDown | 保持宽高比显示，图片缩小或者保持不变。                       |
| None      | 保持原有尺寸显示。                                           |

##### 2、导入和导出

export：在声明时将 SwiperComponent 这个组件导出，导出的组件可以被其他ets文件导入。

import：首行使用import从相对路径`../../mock/ProductsData`这个文件中导入`INDEX_DATA`常量数组

```
export const INDEX_DATA: Array<SwiperModel> = [
  { id: 0, img: $r('app.media.banner_movie1') },
  { id: 1, img: $r("app.media.banner_movie3") },
  { id: 2, img: $r('app.media.banner_movie1') },
  { id: 3, img: $r("app.media.banner_movie3") }
]
```

SwiperModel的定义：

```
export class SwiperModel {
  constructor(public id: number, public img: Resource) {
    this.id = id
    this.img = img
  }
}
```

`constructor` 方法是类的构造函数，用于初始化对象的属性和方法。

##### 3、资源的分类与访问

应用开发中使用的各类资源文件，需要放入特定子目录中存储管理。resources目录包括三大类目录，一类为base目录，一类为限定词目录，还有一类为rawfile目录。stage模型多工程情况下共有的资源文件放到AppScope下的resources目录，base目录默认存在。

base目录的二级子目录为**资源组目录**，用于存放字符串、颜色、布尔值等基础元素，以及媒体、动画、布局等资源文件。

在工程中，通过`$r('app.type.name')`的形式引用应用资源，`$r`是一个全局函数，接收一个字符串路径并返回这个资源文件。app代表应用内resources目录中定义的资源；type代表资源类型（或资源的存放位置），可以取“color”、“float”、“string”、“plural”、“media”，name代表资源命名，由开发者定义资源时确定。

应用使用某资源时，系统会根据当前设备状态优先从相匹配的限定词目录中寻找该资源。只有当resources目录中没有与设备状态匹配的限定词目录，或者在限定词目录中找不到该资源时，才会去base目录中查找。rawfile是原始文件目录，不会根据设备状态去匹配不同的资源。

本例中对图片的引用 `"app.media.banner_movie1"` 和对颜色的引用`$r('app.color.white')`，分别对应`resources/base/media/banner_movie1.png`这张图片和`resources/base/element/color.json`这个json文件中的white颜色值。

关于**资源的分类与访问**，此处不做详细描述。官方资料见参考文档：[资源分类与访问 · HarmonyOS应用开发](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/resource-categories-and-access-0000001435940589)

### 参考文档

[1] [桔子购物sample · OpenHarmony - Gitee.com](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/OrangeShopping)

[2] [轮播组件(Swiper) · OpenHarmony/docs - Gitee.com](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-layout-development-create-looping.md)

[3] [应用级变量的状态管理 · HarmonyOS应用开发](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/ets-state-mgmt-application-level-0000001119769576)

[4] [Swiper容器组件 · HarmonyOS应用开发](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-container-swiper-0000001333321221)

[5] [Image-基础组件 · HarmonyOS应用开发](https://developer.harmonyos.com/cn/docs/documentation/doc-references/ts-basic-components-image-0000001281001226)

[6] [显示图片(Image) · OpenHarmony/docs - Gitee.com](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-graphics-display.md)

[7] [资源分类与访问 · HarmonyOS应用开发](https://developer.harmonyos.com/cn/docs/documentation/doc-guides/resource-categories-and-access-0000001435940589)





