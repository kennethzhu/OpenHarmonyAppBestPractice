import computeNBody from '../model/CalculteUtil'

let timeSpent = AppStorage.link('workerResult')

@Entry
@Component
struct Index {
  @State message: string = 'Click button to calculate.'
  @StorageLink('timeSpent') @Watch('timeSpentChanged') timeSpent: String = ''

  timeSpentChanged() {
    this.message = AppStorage.get('timeSpent')
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Divider()
        Button('Click Me').onClick(() => {
          console.log('click')
          this.message = 'Calculating...'
          computeNBody()
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}