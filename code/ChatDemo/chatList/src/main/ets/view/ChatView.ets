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
import { ChatModel } from '../viewModel/MsgBase'
import Logger from '../utils/Logger'

const TAG: string = 'ChatList_ChatView'

@Reusable
@Component
struct ReusableChatView {
  @State chatItem: ChatModel = undefined

  aboutToReuse(params) {
    this.chatItem = params.chatItem
    Logger.info(TAG, 'aboutToReuse=' + this.chatItem.toString())
  }

  build() {
    ChatView({ chatItem: this.chatItem })
  }
}

@Component
struct ChatView {
  private chatItem: ChatModel
  @StorageLink('img_syncLoad') img_syncLoad: boolean = AppStorage.get('img_syncLoad')

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
        Row() {
          Row() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(this.chatItem.user.userImage)// 用户头像
                .width(48)
                .height(48)
                .margin({ left: 10 })
                .borderRadius(5)
                .autoResize(false)
                .syncLoad(this.img_syncLoad ? true : false) // 图片同步加载

              if (this.chatItem.unreadMsgCount > 0){ // 红点消息大于0条时渲染红点
                Text(`${this.chatItem.unreadMsgCount}`)
                  .borderRadius(10)
                  .width(20)
                  .height(20)
                  .backgroundColor("#ea6055")
                  .fontSize(12)
                  .textAlign(TextAlign.Center)
                  .fontColor(Color.White)
                  .margin({ top: -10, right: -10 })
              }
             else {}
            }
          }
          .layoutWeight(1)

          Column() {
            Text(this.chatItem.user.userName)
              .fontColor(Color.Black)
              .fontSize(16)
            Text(this.chatItem.lastMsg)
              .fontColor("#999999")
              .fontSize(14)
              .margin({ top: 6 })
          }
          .padding({ left: 15 })
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(7)

          Column() {
            Text(this.chatItem.lastTime)
              .width(50)
              .fontColor("#999999")
              .textAlign(TextAlign.End)
              .maxLines(1)
              .fontSize(12)
              .margin({ right: 9, bottom: 20 })
          }
          .padding({ left: 15 })
          .alignItems(HorizontalAlign.End)
          .layoutWeight(1)
        }
        .width("100%")
        .onClick(() => {
          // router.pushUrl({
          //   url: 'pages/ChatDetailPage',
          //   params: {
          //     chatName: this.chatItem.user.userName,
          //     chatId: this.chatItem.user.userId,
          //     // Ability来的want的分享数据
          //     wantParams: this.wantParams,
          //     wantFileParams: this.wantFileParams
          //   }
          // })
        })
    }
    .width("100%")
    .height(70)
    .padding({ left: 8, right: 10, top: 10, bottom: 10 })
  }
}

export { ChatView, ReusableChatView }
