import taskpool from '@ohos.taskpool';
import { offsetMomentum, energy, advance, bodies } from './NBody_ETS_6';

@Concurrent
function computeTask(): number {
  const n: number = 5000000;
  console.info('start calculating...')
  let start: number = new Date().getTime()
  offsetMomentum();
  console.info(energy().toFixed(9));
  for (let i: number = 0; i < n; i++) {
    advance(0.01);
  }
  console.info(energy().toFixed(9));
  let end: number = new Date().getTime()
  // this.message = 'total time costed = ' + (end - start) + ' ms.';
  return end - start;
}

function computeNBody() {
  let task: taskpool.Task = new taskpool.Task(computeTask)
  console.info("[executeTask] executing")
  try {
    taskpool.execute(task, taskpool.Priority.HIGH).then((res: number) => {
      console.info('[computeNBody] executed successfully, total time costed = ' + res + ' ms.')
      AppStorage.set<String>('timeSpent', 'Total time costed = ' + res + ' ms.')
    })
  } catch (e) {
    console.error("[executeTask] execute failed, " + e.toString())
  }
}

export default computeNBody;