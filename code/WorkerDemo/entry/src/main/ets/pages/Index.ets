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
            this.threadWorker = new worker.ThreadWorker("entry/ets/workers/Worker.ts")
            // 处理来自worker线程的消息
            this.threadWorker.onmessage = function (message) {
              console.info("message from worker: " + message.data)
              AppStorage.Set<String>('workerResult', message.data)
            }
            this.threadWorker.postMessage("message from main thread.")

            this.threadWorker.terminate()
          }
        )
      }
      .width('100%')
    }
    .height('100%')
  }
}