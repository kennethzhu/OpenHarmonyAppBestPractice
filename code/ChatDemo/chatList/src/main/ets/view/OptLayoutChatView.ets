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

import Logger from '../utils/Logger'
import { ChatModel, ChatContact } from '../viewModel/MsgBase'

const TAG: string = 'ChatList_ChatView'

@Reusable
@Component
struct ReusableOptLayoutChatView {
  @State chatItem: ChatModel = undefined

  aboutToReuse(params) {
    this.chatItem = params.chatItem
    Logger.info(TAG, 'aboutToReuse=' + this.chatItem.toString())
  }

  build() {
    OptLayoutChatView({ chatItem: this.chatItem })
  }
}

@Preview
@Component
struct OptLayoutChatView {
  private chatItem: ChatModel
  @StorageLink('img_syncLoad') img_syncLoad: boolean = AppStorage.get('img_syncLoad')

  build() {
    Flex() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Image(this.chatItem.user.userImage)
          .width(48)
          .height(48)
          .borderRadius(5)
          .syncLoad(this.img_syncLoad ? true : false)

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
      .padding({ left: 5 })

      Column() {
        Flex() {
          Text(this.chatItem.user.userName)
            .fontColor(Color.Black)
            .fontSize(16)
            .font({ weight: 450 })
            .padding({ bottom: 5 })
          Blank()
          Text(this.chatItem.lastTime)
            .fontSize(12)
            .fontColor("#999999")
            .maxLines(1)
            .textAlign(TextAlign.End)
            .padding({ right: 5 })
        }
        .align(Alignment.End)

        Text(this.chatItem.lastMsg)
          .fontColor("#999999")
          .fontSize(14)
          .maxLines(1)
      }
      .padding({ left: 12, top: 5 })
      .alignItems(HorizontalAlign.Start)
    }
    .width("100%")
    .height(70)
    .padding({ left: 15, right: 10, top: 10, bottom: 10 })
  }
}

export { OptLayoutChatView, ReusableOptLayoutChatView }
