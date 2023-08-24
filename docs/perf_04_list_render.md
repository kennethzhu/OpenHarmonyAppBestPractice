&nbsp;:book: [查看本文案例](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/IM/Chat)

<p align="center">
  <h1 align="center">OpenHarmony循环渲染控制</h1>
</p>

- 摘要：在应用开发时，界面元素循环渲染是一种常见的界面更新技术，它通过循环迭代的方式将界面元素逐个渲染到屏幕上。
  在循环渲染中，通常会使用一个循环来遍历所有的界面元素，并在每个元素上执行渲染操作。本文会介绍开发OpenHarmony应用时需要注意的一些渲染控制注意事项，帮助开发者学习正确地在应用开发中使用渲染控制，进行高性能开发。

- 关键字：OpenHarmony HarmonyOS 鸿蒙 ForEach LazyForEach 循环渲染

## 概述

在应用开发时，界面元素循环渲染是一种常见的界面更新技术，它通过循环迭代的方式将界面元素逐个渲染到屏幕上。
在循环渲染中，通常会使用一个循环来遍历所有的界面元素，并在每个元素上执行渲染操作。

本文会介绍开发OpenHarmony应用时需要注意的一些渲染控制注意事项，帮助开发者学习正确地在应用开发中使用渲染控制，进行高性能开发。

## 环境准备

准备一个DevEco Studio，使用真机或者Simulator模拟器来验证。更多关于DevEco Studio的信息，请访问：[https://developer.harmonyos.com/cn/develop/deveco-studio/](https://developer.harmonyos.com/cn/develop/deveco-studio/)。

## 循环接口

OpenHarmony SDK提供了2个循环接口，一个是常规循环遍历的ForEach，一个是懒加载延迟遍历的LazyForEach，分别定义在文件SDK的ets\component\for_each.d.ts和ets\component\lazy_for_each.d.ts。

ForEach接口定义如下，需要传入3个参数:

- arr: Array<any>
  
    第一个参数为需要循环遍历的Array数组。

- itemGenerator: (item: any, index?: number) => void
  
    第二个参数数组元素处理函数，为遍历到的每个数组元素逐个进行界面渲染。该函数无返回值。

- keyGenerator?: (item: any, index?: number) => string
  
    第三个参数为键值生成函数，可选函数，为遍历到的每个数组元素生成一个唯一的键值，并由该函数返回生成的键值。如果没有指定，默认为:
  
  ```javascript
  (item, index) => `${index}_${JSON.stringify(item)}`
  ```

```javascript
interface ForEachInterface {
    /**
     * Set the value, array, and key.
     * @form
     * @since 9
     */
    (arr: Array<any>, itemGenerator: (item: any, index?: number) => void, keyGenerator?: (item: any, index?: number) => string): ForEachInterface;
}
declare const ForEach: ForEachInterface;
```

LazyForEach接口定义如下，需要传入3个参数:

- dataSource: IDataSource
  
    第一个参数为需要遍历的数据源，开发者需要实现数据源接口IDataSource。这是和ForEach区别的地方。

- 其他2个参数
  
    其他2个参数和ForEach接口的第二个、第三个参数用法一致，不再赘述。

```javascript
interface LazyForEachInterface {
    /**
     * Enter the value to obtain the LazyForEach.
     * @since 7
     */
    (dataSource: IDataSource, itemGenerator: (item: any, index?: number) => void, keyGenerator?: (item: any, index?: number) => string): LazyForEachInterface;
}
declare const LazyForEach: LazyForEachInterface;
```

## 开发实践

我们看下ForEach的实际使用案例，LazyForEach使用方法类似。

<!-- panels:start -->

<!-- div:title-panel -->

### 在ForEach数据源中添加元素

<!-- div:left-panel -->

我们看个反面的示例，在ForEach数据源中添加元素导致数组项键值重复。

需要遍历的数组为this.array，初始只有3个简单的元素：1,2,3。

ForEach对这个数组进行循环，渲染一个Text组件，显示数组元素。

为每个数组项生成一个键值：item => item.toString()。键值即数组项的字符串形式。

页面底部有个Text，每次点击时，会调用onClick函数，为数组添加一个元素：4。

实际运行该程序时，会发现，页面上只增加了一次：Item 4。这是为什么呢？

上文提到，数组项的键值生成函数为item => item.toString()，会为每个数组项生成的键值分别为：1,2,3,4。

相同数值的数组项的键值是一样的，本例子键值都为4。键值一样，在界面上没有重复渲染已经存在的组件。

ForEach循环渲染时，键值有如下特性：

- 唯一性：键值生成函数生成的每个数组项的键值Key是不同的。

- 稳定性：当数组项ID发生变化时，ArkUI框架认为该数组项被替换或更改。

- ArkUI框架会对重复的ID告警，这种情况下框架的行为是未知的，特别是UI的更新在该场景下可能不起作用。

如果想每次新增元素4都在界面上展示，可以更换键值生成函数为下述函数`(item, index) => item.toString() + index.toString())`。或者不指定，使用默认函数。

<!-- div:right-panel -->

```javascript
@Entry
@Component
struct Index {
  @State arr: number[] = [1, 2, 3];

  build() {
    Column() {
      ForEach(this.arr,
        (item) => {
          Text(`Item ${item}`)
            .fontSize(30)
        },
        item => item.toString())
        // (item, index) => item.toString() + index.toString())
        // (item, index) => `${index}_${JSON.stringify(item)}`)
      Text('Add arr element')
        .fontSize(30)
        .onClick(() => {
          this.arr.push(4); // arr新增的元素，其在ForEach内的键值均为'4'
          console.info("Arr elements: ", this.arr);
        })
    }
  }
}
```

<!-- div:title-panel -->

### ForEach数据源更新

<!-- div:left-panel -->

看完数据源添加新元素，我们再看下数据源更新的场景。需要了解的是，ForEach数据源更新时，数组项键值Key与原数组项键值Key重复不会重新创建该数组项。

我们看个反向的示例。

子组件Child比较简单，根据父组件传入的数值，使用Text进行展示。

当点击展示的Text组件时，对应的数值自增1。状态变量使用@Prop修饰，不会更新父组件中对应的数值。

父组件中，有3个元素的数组，该数组在[1,2,3]和[3,4,5]间切换，模拟数据源更新。

实际运行该程序时，会发现，页面上包含4部分内容。

- 'Parent: the array values:' 

输出数组的当前值，为[1,2,3]或[3,4,5]。

- 'Parent: element one by one:'

调用子组件输出数组的当前值，未使用ForEach循环，一个一个的调用的Child组件。该部分展示数据和上一部分会一直保持一致。

- 'Parent: for each element:'

使用ForEach循环，调用子组件循环输出数组的当前值。

- 'Parent: replace entire arr'

该文本的作用是，点击后会模拟更新数据源在在[1,2,3]和[3,4,5]间切换。

介绍完界面后，我们做个尝试。在启动应用后，我们点击'Parent: for each element:'部分的第3个元素，点击几次后，比如，组件显示：Child 10。

然后，点击文本'Parent: replace entire arr'，会发现数组变为[3,4,5]，但是第3部分'Parent: replace entire arr'展示的内容为：Child 10、Child 4、Child 5，
而不是Child 3、Child 4、Child 5。这是为什么呢？

我们分析下原因。初始的时候，ForEach循环，渲染3个组件，键值和数组项对应如下。

如果点击第3个元素几次后，键值还是3，但是展示的数据由3变为10。

| 键值    | 数组项 |
| ----- | --- |
| Key:1 | 1   |
| Key:2 | 2   |
| Key:3 | 3   |

当数据源切换时，对应的键值和数组项如下所示。由于子组件中键值Key为3的组件已经存在，不会重新渲染，只重新渲染键值为3和4的组件。因此，展示的数据分别为：10、4、5。

这就解释了为什么是10,4,5而不是3,4,5。

| 键值    | 数组项 |
| ----- | --- |
| Key:3 | 3   |
| Key:4 | 4   |
| Key:5 | 5   |

<!-- div:right-panel -->

```javascript
@Component
struct Child {
  @Prop value: number;

  build() {
    Text(`Child:${this.value}`)
      .fontSize(30)
      .onClick(() => {
        this.value++ // 点击改变@Prop的值
      })
  }
}

@Entry
@Component
struct Page {
  @State arr: number[] = [1, 2, 3];

  build() {
    Row() {
      Column() {
        // 对照组
        Text('Parent: the array values:')
        Text(`${this.arr[0]}`).fontSize(30)
        Text(`${this.arr[1]}`).fontSize(30)
        Text(`${this.arr[2]}`).fontSize(30)
        Divider().height(5)
        Text('Parent: element one by one:')
        Child({ value: this.arr[0] })
        Child({ value: this.arr[1] })
        Child({ value: this.arr[2] })
        Divider().height(5)
        Text('Parent: for each element:')
        ForEach(this.arr,
          item => {
            Child({ value: item })
          },
          item => item.toString())
        Divider().height(5)
        Text('Parent: replace entire arr')
          .fontSize(30)
          .onClick(() => {
            // 两个数组项内均含有'3'，ForEach内的id没有发生变化
            // 意味着ForEach不会更新该Child实例，@Prop也不会在父组件处被更新
            this.arr = (this.arr[0] == 1) ? [3, 4, 5] : [1, 2, 3];
          })
      }
    }
  }
}
```

<!-- panels:end -->

## 注意事项

> 以ForEach为例讲解，LazyForEach的运行机制是一样的。

## 总结

本文介绍了使用ForEach、LazyForEach开发OpenHarmony应用时需要注意的一些渲染控制注意事项。希望可以帮助
开发者学习正确地在应用开发中使用渲染控制，进行高性能开发。如有任何问题，欢迎交流讨论。

## 参考资料

[[1] Sample聊天实例应用](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/IM/Chat)

[[2] 性能提升的推荐方法](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/ui/arkts-performance-improvement-recommendation.md/)

[[3] 渲染控制优秀实践](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/arkts-rendering-control-best-practices.md)
