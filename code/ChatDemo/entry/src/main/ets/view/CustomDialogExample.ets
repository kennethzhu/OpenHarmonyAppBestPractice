/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController
  @StorageLink('lazy_for_each') lazy_for_each: boolean = AppStorage.get('lazy_for_each')
  @StorageLink('reusable') reusable: boolean = AppStorage.get('reusable')
  @StorageLink('img_syncLoad') img_syncLoad: boolean = AppStorage.get('img_syncLoad')
  @StorageLink('page_layout') page_layout: boolean = AppStorage.get('page_layout')
  @StorageLink('list_cachedCount') list_cachedCount: boolean = AppStorage.get('list_cachedCount')

  build() {
    Column() {
      Prompt({ img: $r('app.media.pic1'), text: $r('app.string.add_friends'), controller: this.controller })
      Prompt({ img: $r('app.media.pic2'), text: $r('app.string.group_chat'), controller: this.controller })
      Prompt({ img: $r('app.media.pic3'), text: $r('app.string.scan'), controller: this.controller })
      Prompt({ img: $r('app.media.pic4'), text: $r('app.string.collection_payment'), controller: this.controller })

      ToggleComponent({ text_option: $r('app.string.prop_lazy_for_each'), isOn: $lazy_for_each })
      ToggleComponent({ text_option: $r('app.string.prop_reusable'), isOn: $reusable })
      ToggleComponent({ text_option: $r('app.string.prop_syncLoad'), isOn: $img_syncLoad })
      ToggleComponent({ text_option: $r('app.string.prop_layout'), isOn: $page_layout })
      ToggleComponent({ text_option: $r('app.string.prop_cachedCount'), isOn: $list_cachedCount })
    }
    .backgroundColor("#2E363E")
    .borderRadius(5)
    .padding({ left: 5, bottom: 5 })
    .width(135)
  }
}

@Component
struct Prompt {
  @State img: Resource = $r("app.media.empresa")
  text: string | Resource
  controller: CustomDialogController

  build() {
    Row() {
      Image(this.img)
        .height(20)
        .width(20)
        .margin({ top: 5, right: 10 })
      Text(this.text)
        .fontSize(16)
        .fontColor("#ffffff")
        .margin({ top: 5 })
    }
    .width('100%')
    .padding(8)
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      this.controller.close()
      AlertDialog.show(
        {
          message: $r('app.string.alert_dialog'),
        }
      )
    })
  }
}

@Component
struct ToggleComponent {
  text_option: string | Resource
  @Link isOn: boolean

  build() {
    Column() {
      Row() {
        Text(this.text_option)
          .fontSize(16)
          .fontColor("#ffffff")
          .margin({ top: 5 })
        Toggle({ type: ToggleType.Switch, isOn: this.isOn })
          .selectedColor('#007DFF')
          .switchPointColor('#FFFFFF')
          .onChange((isOn: boolean) => {
            this.isOn = isOn
          })
      }
      .width('100%')
      .padding(5)
      .justifyContent(FlexAlign.Start)
    }
  }
}

export { CustomDialogExample }
