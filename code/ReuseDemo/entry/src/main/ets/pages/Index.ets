import { ImageListDataSource, MyImage } from '../viewModel/ImageListDataSource'
import Logger from '../utils/Logger'

const TAG: string = 'ReUseDemo-Index'

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
      Image(this.item.image_path)// 用户头像
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