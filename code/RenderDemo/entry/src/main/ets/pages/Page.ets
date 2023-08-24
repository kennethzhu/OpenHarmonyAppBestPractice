import router from '@ohos.router';

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
            // 两个数组项内均含有'3'，ForEach内的key没有发生变化
            // 意味着ForEach不会更新该Child实例，@Prop也不会在父组件处被更新
            this.arr = (this.arr[0] == 1) ? [3, 4, 5] : [1, 2, 3];
          })
        Divider().height(5)
        Divider().height(5)
        Button('Back').onClick(() => {
          router.back()
        })
      }
    }
  }
}