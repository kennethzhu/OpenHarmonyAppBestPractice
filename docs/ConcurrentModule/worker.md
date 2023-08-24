<p align="center">
  <h1 align="center">OpenHarmony使用Worker开发多线程任务</h1>
</p>

## 概念介绍

在和应用界面进行交互操作时，如按钮点击、屏幕滑动，想同时执行一些耗时的操作，如网络请求、数据下载。在应用开发中，通常使用UI线程和后台线程来分别处理这些操作，UI线程主要负责处理UI事件和用户交互操作，后台线程负责耗时操作。通过创建后台线程可以避免UI线程被阻塞，提高应用程序的响应速度和用户体验。

OpenHarmony的ArkUI应用开发框架提供了Worker和TaskPool等支持后台多线程任务的方式，本文会通过开发范例介绍Worker的使用。在ArkUI应用开发中，有2类线程：宿主线程和Worker线程。创建Worker的线程被称为宿主线程，Worker脚本程序工作的线程被称为Worker线程。Worker线程是与主线程并行的独立线程，通常在Worker线程中处理耗时的操作。需要注意的是，在Worker后台线程中执行的代码不能直接修改UI元素，UI元素的更新必须发生在UI线程中。

## API接口

ArkUI的Worker线程模块提供了构造函数接口用于创建Worker线程，并为UI线程和Worker线程提供了线程间通讯接口。关于Worker API能力详细信息，请参考[@ohos.worker](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/reference/apis/js-apis-worker.md)。本节只进行关键接口解读。

### 宿主线程中的构造函数

使用Worker的接口方法前，需要先构造ThreadWorker实例，ThreadWorker类继承[WorkerEventTarget](#https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/reference/apis/js-apis-worker.md/#workereventtarget9)。

> 注意：Worker还提供构造函数`worker.Worker(scriptURL: string, options?: WorkerOptions)`，由于已经标记废弃，请避免使用该废弃的接口。

ThreadWorker构造函数如下：

```javascript
constructor(scriptURL: string, options?: WorkerOptions)
```

**其中，参数解释：**

| 参数名    | 类型                            | 必填     | 说明                                                         |
| --------- | ------------------------------- | -------- | ------------------------------------------------------------ |
| scriptURL | string                          | 是       | Worker执行脚本的路径 |
| options   | [WorkerOptions](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/reference/apis/js-apis-worker.md/#workeroptions) | 否      | Worker构造的选项。  


我们来看一个构造的示例。不用担心其中的脚步文件如何编写，使用DevEco Studio创建Worker文件的时候，会生成模板。

```javascript
import worker from '@ohos.worker';
// worker线程创建

// Stage模型-目录同级（entry模块下，workers目录与pages目录同级）
const workerStageModel01 = new worker.ThreadWorker('entry/ets/workers/worker.ts', {name:"first worker in Stage model"});
// Stage模型-目录不同级（entry模块下，workers目录是pages目录的子目录）
const workerStageModel02 = new worker.ThreadWorker('entry/ets/pages/workers/worker.ts');
```

### 宿主线程中发送消息

宿主线程通过转移对象所有权或者拷贝数据的方式向Worker线程发送消息，提供了两个postMessage<sup>9+</sup>接口，其中一个如下所示：

```javascript
postMessage(message: Object, options?: PostMessageOptions): void
```

**其中，参数如下：**

| 参数名  | 类型                                      | 必填 | 说明                                                         |
| ------- | ----------------------------------------- | ---- | ------------------------------------------------------------ |
| message | Object                                    | 是   | 发送至Worker的数据，该数据对象必须是可序列化。 |
| options | PostMessageOptions| 否   | 当填入该参数时，与传入ArrayBuffer[]的作用一致，该数组中对象的所有权会被转移到Worker线程，<br>在宿主线程中将会变为不可用，仅在Worker线程中可用。<br>若不填入该参数，默认设置为 undefined，通过拷贝数据的方式传输信息到Worker线程。 |

**示例代码如下：**

```js
const workerInstance = new worker.ThreadWorker("entry/ets/workers/worker.ts");

workerInstance.postMessage("hello world");

var buffer = new ArrayBuffer(8);
workerInstance.postMessage(buffer, [buffer]);
```
### 宿主线程中监听消息

在宿主线程中，通过监听事件来处理接收到的Worker线程中的消息。worker模块提供了若干监听接口，我们以onmessage为例进行讲解，其他监听方式类似，可以参考API参考文档，不再赘述。
Worker对象的onmessage属性表示宿主线程接收到来自其创建的Worker通过parentPort.postMessage接口发送的消息时被调用的事件处理程序，处理程序在宿主线程中执行。


```javascript
onmessage?: (event: MessageEvents) => void
```

**其中，参数如下：**

| 参数名 | 类型                             | 必填 | 说明                   |
| ------ | -------------------------------- | ---- | ---------------------- |
| event  | MessageEvents | 是   | 收到的Worker消息数据。 |

示例代码如下：

```javascript
const workerInstance = new worker.ThreadWorker("entry/ets/workers/worker.ts");
workerInstance.onmessage = function(e) {
    // e : MessageEvents, 用法如下：
    // let data = e.data;
    console.log("onmessage");
}

```
### Worker线程中构造实例

[ThreadWorkerGlobalScope](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/reference/apis/js-apis-worker.md/#threadworkerglobalscope9)是Worker线程用于与宿主线程通信的类，通过postMessage接口发送消息给宿主线程、通过close接口销毁Worker线程。ThreadWorkerGlobalScope类继承GlobalScope9+。

> 注意：Worker还提供worker.parentPort接口，该接口属于废弃接口，应避免使用。

在Worker脚本文件中，如`entry\src\main\ets\workers\Worker.ts`，构建实例如下：

```javascript
import worker, { ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@ohos.worker';

var workerPort: ThreadWorkerGlobalScope = worker.workerPort;
```

### Worker线程中监听消息

ThreadWorkerGlobalScope的onmessage属性表示Worker线程收到来自其宿主线程通过postMessage接口发送的消息时被调用的事件处理程序，处理程序在Worker线程中执行。

```javascript
onmessage?: (this: ThreadWorkerGlobalScope, ev: MessageEvents) =&gt; void
```
**其中，参数如下所示：**

| 参数名 | 类型                                                 | 必填 | 说明                     |
| ------ | ---------------------------------------------------- | ---- | ------------------------ |
| this   | ThreadWorkerGlobalScope | 是   | 指向调用者对象。         |
| ev     | MessageEvents                    | 是   | 收到宿主线程发送的数据。 |

**示例代码如下：**

```js
// main thread
import worker from '@ohos.worker';
const workerInstance = new worker.ThreadWorker("entry/ets/workers/worker.ts");
workerInstance.postMessage("hello world");
```

```js
// worker.ts
import worker from '@ohos.worker';
const workerPort = worker.workerPort;
workerPort.onmessage = function(e) {
    console.log("receive main thread message");
}
```

### Worker线程中发送消息

Worker线程通过转移对象所有权或者拷贝数据的方式向宿主线程发送消息。提供了两个postMessage9+接口，其中一个如下所示：

```javascript
postMessage(messageObject: Object, options?: PostMessageOptions): void
```

**其中，参数如下所示：**

| 参数名  | 类型                                      | 必填 | 说明                                                         |
| ------- | ----------------------------------------- | ---- | ------------------------------------------------------------ |
| message | Object                                    | 是   | 发送至宿主线程的数据，该数据对象必须是可序列化，序列化支持类型见[其他说明](#序列化支持类型)。 |
| options | PostMessageOptions | 否   | 当填入该参数时，与传入ArrayBuffer[]的作用一致，该数组中对象的所有权会被转移到宿主线程，在Worker线程中将会变为不可用，仅在宿主线程中可用。<br/>若不填入该参数，默认设置为 undefined，通过拷贝数据的方式传输信息到宿主线程。 |

### 线程的关闭和销毁

销毁worker的方式有两种；

- 被动销毁 

worker线程的生命周期跟随应用。若应用退出则释放worker资源。worker线程在执行过程中出现异常终止掉worker。

- 主动销毁 

主动销毁worker的方式有两种，第一种在宿主线程调用`worker.terminate()`；第二种在worker线程调用`workerPort.close()`。 worker销毁前会触发onexit回调，注意，onexit回调只会在宿主线程中执行。

宿主线程中销毁worker线程的示例代码：

```javascript
const worker = new worker.ThreadWorker("entry/ets/workers/worker.ts");
worker.terminate();
```
Worker线程中销毁worker线程的示例代码：

```javascript
// worker.ts
import worker from '@ohos.worker';
const workerPort = worker.workerPort;
workerPort.onmessage = function(e) {
    workerPort.close()
}
```

## 实现场景

我们模拟一个简单的UI线程和Worker线程交互的场景。UI线程发送一个简单的消息给Worker线程，触发Worker线程中的一个耗时模拟操作，然后把结果返回UI线程进行界面展示。有点像，一个人站在山谷前，大喊一声，过一段时间会从山谷中返回声音。这个人就是UI线程，返回回音的山谷就是后台线程。

除了这个场景，也可以参考OpenHarmony社区的多线程案例程序：[https://gitee.com/openharmony/applications_app_samples/tree/master/code/LaunguageBaseClassLibrary/ConcurrentModule](https://gitee.com/openharmony/applications_app_samples/tree/master/code/LaunguageBaseClassLibrary/ConcurrentModule)。


## 设计思路

对于UI线程，只需要简单地包含一个text和一个button。text用于展示后台线程返回的信息，button按钮被点击后向后台线程发送消息。UI线程还需要处理后台返回的消息。

对于后台线程，需要处理接收到UI消息，模拟一个耗时操作，然后返回。

## 开发步骤
<!-- panels:start -->

<!-- div:title-panel -->
### 创建Worker

<!-- div:left-panel -->

DevEco Studio提供了非常方便的创建Worker的方法。

在DevEco Studio工程中，选择entry，右键菜单选择New-Worker，输入Worker名称即可，比如就使用默认的Worker。

Studio会自动为生成文件`entry\src\main\ets\workers\Worker.ts`，并在模块级配置文件`entry\build-profile.json5`中添加`workers`配置，如图所示，可以看出使用的相对路径：'./src/main/ets/workers/Worker.ts'。

<!-- div:right-panel -->

文件`entry\build-profile.json5`片段:
 
```json
  "buildOption": {
    "sourceOption": {
      "workers": [
        './src/main/ets/workers/Worker.ts',
      ]
    }
  },   
```
<!-- panels:end -->
<!-- panels:start -->

<!-- div:title-panel -->
### 宿主进程代码实现
<!-- div:left-panel -->

我们先看下宿主进程中，代码如何实现。

我们知道，Worker线程不可以直接操作UI。在宿主线程中，监听到的worker线程返回消息无法直接赋值给@State变量进行UI界面渲染的。需要通过其他方式进行传值，本示例中我们使用AppStorage和@Watch装饰器。

如代码所示，创建一个workerResult变量，当该变量发生变化后，会通过执行监听函数workerResultChanged()，把存储的值赋值给@State变量。

在宿主线程中创建的worker实例为threadWorker，它负责通过脚本文件创建worker线程，并负责执行和worker线程的通讯交互。

在宿主线程中，界面中包含一个文本，展示文字，如果从worker进程中接收到的消息等，还有一个按钮，点击时会触发发worker线程发送消息。

在Button的onClick()函数中，主要实现了2个功能，一个是定义宿主线程接收到worker消息的回调函数。从代码中可以看出，当接收到消息后，会保存到AppStorage里。

另外一个功能点是，通过调用postMessage接口，向worker线程发送消息。

在宿主线程中，还支持很多监听函数，限于篇幅，不再展示，可以参考API自行实现。
<!-- div:right-panel -->

```javascript
import worker from '@ohos.worker';
let workerResult = AppStorage.Link('workerResult')

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @StorageLink('workerResult') @Watch('workerResultChanged') workerResult: String = ''
  threadWorker: worker.ThreadWorker = new worker.ThreadWorker("entry/ets/workers/Worker.ts")

  workerResultChanged() {
    this.message = AppStorage.Get('workerResult')
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Button('Click').onClick(
          () => {
            this.threadWorker.onmessage = function (message) {
              AppStorage.Set<String>('workerResult', message.data)
            }
            this.threadWorker.postMessage("message from main thread.")
          }
        )
      }
      .width('100%')
    }
    .height('100%')
  }
}
```

<!-- panels:end -->
<!-- panels:start -->

<!-- div:title-panel -->
### Worker进程代码实现

<!-- div:left-panel -->

我们再看下Worker进程中，代码如何实现。Work线程脚本文件`entry\src\main\ets\workers\Worker.ts`。

语句`var workerPort: ThreadWorkerGlobalScope = worker.workerPort;`用于构建Worker线程中的实例对象，该实例可以与宿主线程进行消息交互。

在workerPort.onmessage监听函数中，控制台打印输出从宿主线程中接收到的消息，然后通过workerPort.postMessage接口向宿主线程第一次发送消息，告诉宿主线程
请等待worker线程的操作。

然后，使用setTimeout函数模拟一个耗时操作，5000ms后再次向宿主线程发送消息，携带一个随机数字，用于区分多次返回消息的差异。

在worker线程中的其他监听函数，如workerPort.onmessageerror、workerPort.onerror，或者销毁worker线程的操作可以参考API自行实现。

<!-- div:right-panel -->

文件`entry\src\main\ets\workers\Worker.ts`片段:
 
```javascript
import worker from '@ohos.worker';
import { ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@ohos.worker';

var workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = function (e: MessageEvents) {
  console.info("onmessage: " + e.data)
  workerPort.postMessage("Waiting for the worker ...")
  setTimeout(() => {
    console.info('send to main thread')
    workerPort.postMessage("Echo from worker Random: " 
    + Math.round(100 * Math.random()))
  },
    5000)
} 
```

<!-- panels:end -->

### 运行测试效果

代码编写完毕，可以测试运行查看效果。推荐在模块级配置文件`entry\build-profile.json5`中,修改运行时为"HarmonyOS"，这样就可以在DevEco Studio中使用Simulator模拟器进行运行测试，手头没有设备也可以轻松体验OpenHarmony应用开发。实现效果如下：

|发送消息前|等待返回|消息返回|
|--------------------------------|--------------------------------|--------------------------------|
|![image](./screenshots/device/ui.jpg)|![image](./screenshots/device/medium.jpg)|![image](./screenshots/device/worker.jpg)|


## 注意事项

Worker线程不可以直接操作UI，`@State`等变量无法直接进行赋值渲染，需要通过其他方式进行传值。在本开发范例中， 就借助了AppStorage。

Worker线程不使用时，请及时销毁，避免耗用资源。Worker有资源限制，如果创建数量太多，可以报如下错误：

```shell
Error message: Worker initialization failure, the number of workers exceeds the maximum.
SourceCode:
this.threadWorker = new worker.ThreadWorker("entry/ets/workers/Worker.ts");
```

## 参考资料

[多线程任务 Sample](https://gitee.com/openharmony/applications_app_samples/tree/master/code/LaunguageBaseClassLibrary/ConcurrentModule)

[使用Worker进行线程间通信](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/application-models/itc-with-worker.md/)

[@ohos.worker API 参考](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/reference/apis/js-apis-worker.md/)

[@Watch装饰器](https://docs.openharmony.cn/pages/v3.1/zh-cn/application-dev/ui/ts-other-states-watch.md/)

[AppStorage：应用全局的UI状态存储](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/arkts-appstorage.md/)