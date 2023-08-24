&nbsp;:book: [查看本文案例](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/IM/Chat)

<p align="center">
  <h1 align="center">OpenHarmony组件复用示例</h1>
</p>

- 摘要：在开发应用时，有些场景下的自定义组件具有相同的组件布局结构，仅有状态变量等承载数据的差异。这样的组件缓存起来，需要使用到该组件时直接复用，
减少了创建和渲染的时间，可以提高帧率和用户性能体验。本文会介绍开发OpenHarmony应用时如何使用组件复用能力。

- 关键字：OpenHarmony HarmonyOS 鸿蒙 ForEach LazyForEach 循环渲染

## 概述

在开发应用时，有些场景下的自定义组件具有相同的组件布局结构，仅有状态变量等承载数据的差异。这样的组件缓存起来，需要使用到该组件时直接复用，
减少重复创建和渲染的时间，从而提高应用页面的加载速度和响应速度。

在OpenHarmony应用开发时，自定义组件被@Reusable装饰器修饰时表示该自定义组件可以复用。在父自定义组件下创建的可复用组件从组件树上移除后，会被加入父自定义组件的可复用节点缓存里。
在父自定义组件再次创建可复用组件时，会通过更新可复用组件的方式，从缓存快速创建可复用组件。这就是OpenHarmony的组件复用机制。

本文会介绍开发OpenHarmony应用时如何使用组件复用能力。

## 环境准备

准备一个DevEco Studio，使用真机或者Simulator模拟器来验证。更多关于DevEco Studio的信息，请访问：[https://developer.harmonyos.com/cn/develop/deveco-studio/](https://developer.harmonyos.com/cn/develop/deveco-studio/)。

## 组件复用接口

OpenHarmony SDK文件ets\component\common.d.ts的自定义组件的生命周期里定义了aboutToReuse方法，如下：

自定义组件的生命周期回调函数用于通知用户该自定义组件的生命周期，这些回调函数是私有的，在运行时由开发框架在特定的时间进行调用，不能从应用程序中手动调用这些回调函数。

当一个可复用的自定义组件从复用缓存中重新加入到节点树时，触发aboutToReuse生命周期回调，并将组件的构造参数传递给aboutToReuse。aboutToReuse函数的参数是字典类型的，键为组件的构造参数变量名称，值为组件的构造参数实际取值。

该声明周期函数从API version 10开始，该接口支持在ArkTS卡片中使用。

```javascript
declare class CustomComponent extends CommonAttribute {
......
 /**
   * aboutToReuse Method
   *
   * @param { { [key: string]: unknown } } params - Custom component init params.
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @since 10
   */
  aboutToReuse?(params: { [key: string]: unknown }): void;
......
}
```


## 开发实践

我们看下组件复用的实际使用案例。示例中，会创建一个图片列表页面，使用懒加载LazyForEach，以及组件复用能力。

<!-- panels:start -->

<!-- div:title-panel -->

### 创建数据源

<!-- div:left-panel -->

首先，创建了一个业务对象类MyImage，包含一个image_id图片编号和image_path图片路径。根据实际业务的不同，会有差异，此例仅用于演示。

然后，创建一个数据源类ImageListDataSource，并构造一个列表对象imageList。

可以看到，构造了10000条记录。 在工程的/resources/images文件夹下有50张图片。

每条记录中，包含一个编号，从0到9999。

记录中，还一个一个图片路径，不同的记录，编号不会重复，图片路径可能重复。

至此，数据源类创建完毕。

<!-- div:right-panel -->

```javascript
export class MyImage {
  image_id: string
  image_path: string
  constructor(image_id: string, image_path: string) {
    this.image_id = image_id
    this.image_path = image_path
  }
}

export class ImageListDataSource extends BasicDataSource {
  private imageList: MyImage[] = []
  public constructor() {
    super()
    for (let i = 0;i < 10000; i++) {
      let imageStr = `/resources/images/photo${(i % 50).toString()}.jpg`
      this.imageList.push(new MyImage(i.toString(), imageStr))
    }
  }
  public totalCount(): number {
    return this.imageList.length
  }
  public getData(index: number): MyImage {
    return this.imageList[index]
  }
......
}

```

<!-- div:title-panel -->

### 创建复用组件

<!-- div:left-panel -->

创建好数据源类后，我们再看下可复用组件的代码。

使用装饰器@Reusable来标记一个组件是否属于可复用组件。

我们创建的可复用组件有一个状态变量@State item，构造该自定义组件时，父组件会给子母件传递构造数据。

还需要实现组件复用声明周期回调函数aboutToReuse，在这个函数里，通过params把构造数据传递给可复用组件。

我们在函数aboutToReus里，再单独加个一个打印函数，用于在组件复用时，输出一条日志记录。

> 需要注意的是，正常情况下，aboutToReuse函数里除了构造参数传值，不要做任何耗时操作。

在可复用组件的build()方法里，为每条记录渲染一行，包含图片、图片编号和图片路径。

图片编号可以识别渲染的是哪一条数据，用于验证组件复用了正确的组件。


<!-- div:right-panel -->

```javascript
@Reusable
@Component
struct MyListItem {
  @State item: MyImage = new MyImage('', '')

  aboutToReuse(params) {
    this.item = params.item
    Logger.info(TAG, 'aboutToReuse-,item=' + this.item.toString())
  }

  build() {
    Row({ space: 10 }) {
      Image(this.item.image_path)
        .width(50)
        .height(50)
        .borderRadius(5)
        .autoResize(false)
        .syncLoad(true)
      Blank()
      Text(this.item.image_id)
        .fontColor(Color.Black)
        .fontSize(15)
      Blank()
      Text(this.item.image_path)
        .fontColor(Color.Black)
        .fontSize(15)
    }
  }
}

```

<!-- div:title-panel -->

### 入口组件

<!-- div:left-panel -->

在我们的@Ent 
 */-·-	件里，在List父组件里，可以调用可复用组件MyListItem。

通过`{ item: item }`完成父子组件参数传递。

`reuseId`参数是可选的，用于标记可复用组件的复用类型。属性参数的注释如下：

```javascript
  /**
   * Reuse id is used for identify the reuse type for each custom node.
   * 
   * @param { string } id - The id for reusable custom node.
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @since 10
   */
  reuseId(id: string)
```


<!-- div:right-panel -->

入口组件的示例代码如下：

```javascript
@Entry
@Component
struct Index {
  private data: ImageListDataSource = new ImageListDataSource()

  build() {
    List({ space: 3 }) {
      LazyForEach(this.data, (item: MyImage) => {
        ListItem() {
          MyListItem({ item: item })
            // .reuseId(item.image_id)
        }
      }, item => item)
    }
  }
}

```

<!-- panels:end -->

## 注意事项

> 可以访问站点[https://gitee.com/openharmony/developtools_ace_ets2bundle/tree/master/compiler/test/utForPartialUpdate/render_decorator/@recycle](https://gitee.com/openharmony/developtools_ace_ets2bundle/tree/master/compiler/test/utForPartialUpdate/render_decorator/@recycle)查看组件复用的一些示例，这些是用于测试的例子。
@Reusable之前的装饰器的名称为@Recycle，旧名称不使用了。

> ForEach渲染控制具有全展开的特性，不能触发组件复用。

## 总结

本文介绍了开发OpenHarmony应用时如何使用组件复用能力，提供代码示例，期望帮助关注组件复用的开发者朋友们。

如有任何问题，欢迎交流讨论。

## 参考资料

[[1] Sample聊天实例应用](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/IM/Chat)

[[2] 自定义组件的生命周期](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-custom-component-lifecycle.md#abouttoreuse10)

[[3] 组件复用场景](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/arkts-state-management-best-practices.md#%E7%BB%84%E4%BB%B6%E5%A4%8D%E7%94%A8%E5%9C%BA%E6%99%AF)

[[3] 组件复用一些示例](https://gitee.com/openharmony/developtools_ace_ets2bundle/tree/master/compiler/test/utForPartialUpdate/render_decorator/@recycle)
