import taskPool from '@ohos.taskpool'


function concurrentTask(durationMs: number) {
  "use concurrent"
  console.info("[concurrentTask] task start, the args is " + durationMs)
  setTimeout(() => {
    console.info("[concurrentTask] task end ")
  }, durationMs)
  console.info("[concurrentTask] task return")
  return '[concurrentTask] returned'
}

function createTask() {
  let task = new taskPool.Task(concurrentTask, 10 * 1000)
  console.info("[createTask] created successfully")
  return task
}

function executeTask(task: taskPool.Task) {
  console.info("[executeTask] executing")
  try {
    taskPool.execute(task, taskPool.Priority.HIGH).then(() => {
      console.info("[executeTask] executed successfully")
    })
  } catch (e) {
    console.error("[executeTask] execute failed, " + e.toString())
  }
}

function cancelTask(task: taskPool.Task) {
  console.info("[cancelTask] canceling ")
  try {
    taskPool.execute(task, taskPool.Priority.HIGH)
    let start = new Date().getTime()
    // 延时1s，确保任务已执行
    while (new Date().getTime() - start < 1000) {
      continue
    }
    taskPool.cancel(task)
  } catch (e) {
    console.error("[cancelTask] cancel failed" + e.toString())
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  task: taskPool.Task = null

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Blank()
        Row() {
          Button("Create Task").onClick(() => {
            this.task = createTask()
            this.message = "Task Created"
          })
          Button("Execute Task").onClick(() => {
            executeTask(this.task)
            this.message = "Task Executed"
          })
          Button("Cancel Task").onClick(() => {
            cancelTask(this.task)
            this.message = "Task Cancel involved"
          })
        }

      }
      .width('100%')
    }
    .height('100%')
  }
}