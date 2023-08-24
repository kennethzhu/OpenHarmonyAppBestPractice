import util from '@ohos.util';

function bufferToString(buffer: ArrayBuffer): string {
  let textDecoder = util.TextDecoder.create('utf-8', {
    ignoreBOM: true
  });
  let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
    stream: true
  });
  return resultPut;
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  fileName = 'demo.json'

  async aboutToAppear() {
    await getContext().resourceManager.getRawFileContent('demo.json').then((value) => {
      let jsonStr = JSON.parse(bufferToString(value.buffer))
      console.info(jsonStr.description)
      this.message = jsonStr.description
    }).catch((error) => {
      console.error('catch---------------' + JSON.stringify(error))
    }
    )
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}