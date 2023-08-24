import router from '@ohos.router';

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
      Divider().height(5)
      Divider().height(5)
      Button('Second Page').onClick(() => {
        router.pushUrl({ url: 'pages/Page' })
      })
    }
  }
}