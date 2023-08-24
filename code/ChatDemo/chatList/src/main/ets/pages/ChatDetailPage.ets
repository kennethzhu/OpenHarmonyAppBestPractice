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

import { BasicDataSource } from '../viewModel/BasicDataSource';
import { MessageBase, ChatContact, MessageBody, TextMessage, ImageMessage } from '../viewModel/MsgBase';
import router from '@ohos.router';
import { ImgTextMessage, FileMessage } from '../viewModel/MsgBase';
import image from '@ohos.multimedia.image';
import fileio from '@ohos.fileio';
import Logger from '../utils/Logger';

const TAG = "[Sample_Chat]"

@Preview
@Entry
@Component
struct ChatDetailPage {
  @State str: string = ''
  @State chatName: string = ''
  @State msgLength: number = 0
  userMyself = new ChatContact('1', $r('app.string.myself'))
  userFriend = new ChatContact('2', $r('app.string.friend'))
  msg = new TextMessage($r('app.string.message1'))
  msg2 = new TextMessage($r('app.string.message2'))
  tdate = new Date()
  megbody = new MessageBase("1", this.userMyself, this.userFriend, this.msg2, 1, this.tdate.getSeconds())
  @State keyboardStr: string = ''
  private chatDetailData = new ChatDetailData()
  private scroller: Scroller = new Scroller()
  @State imgFile: image.PixelMap = undefined
  @State wantId: number = 0
  @State fdImg: number = undefined
  @State userMyselfName: string = undefined
  @State userFriendName: string = undefined
  @State listHeight: number = 0

  build() {
    Column() {
      Row() {
        Image($r('app.media.left'))
          .id('returnBtn')
          .height(30)
          .width(30)
          .onClick(() => {
            router.back()
          })

        Text(router.getParams()['chatName'])
          .fontSize(15)
        Stack({ alignContent: Alignment.Center }) {
          Image($r('app.media.icon_more'))
            .height(40)
            .width(40)
        }
        .id('moreBtn')
      }
      .height(50)
      .width("100%")
      .backgroundColor("#f5f5f5")
      .padding({ left: 0, right: 10 })
      .justifyContent(FlexAlign.SpaceBetween)

      List({ scroller: this.scroller, initialIndex: this.msgLength - 1 }) {
        LazyForEach(this.chatDetailData, (msg: MessageBase) => {
          ListItem() {
            ChatItemView({ msg: msg, imgFile: $imgFile })
          }
        }, (msg: MessageBase) => msg.msgId)
      }
      .listDirection(Axis.Vertical)
      .divider({ strokeWidth: 2, color: "#f3f3f3" })
      .padding({ left: 10, right: 10, bottom: 10 })
      .layoutWeight(1)
      .width('100%')
      //底部输入框
      Row({ space: 5 }) {
        Image($r('app.media.chatting_setmode_voice'))
          .height(20)
          .width(20)
        TextInput({ placeholder: "", text: this.keyboardStr })
          .id('bottomTextInput')
          .height(40)
          .width('80%')
          .enterKeyType(EnterKeyType.Send)
          .onChange((value: string) => {
            this.keyboardStr = value
          })
          .onSubmit((enterKey) => {
            this.tdate = new Date()
            let msg = new TextMessage(this.keyboardStr)
            let msgBody = new MessageBase(this.chatDetailData.totalCount()
              .toString(), this.userMyself, this.userFriend, msg, 1, this.tdate.getSeconds())
            this.chatDetailData.pushData(msgBody)
            this.msgLength = this.chatDetailData.totalCount()
            this.scroller.scrollToIndex(this.msgLength - 1)
            this.keyboardStr = ''
          })
        Image($r('app.media.chatting_expression'))
          .id('chatExpression')
          .height(20)
          .width(20)
          .onClick(() => {
            let imagestr = `/resources/images/photo${((router.getParams()['chatId']) % 50)}.jpg`
            let msg = new ImageMessage(40, 50, imagestr)
            let msgBody = new MessageBase(this.chatDetailData.totalCount().toString(), this.userMyself, this.userFriend, msg, 2)
            this.chatDetailData.pushData(msgBody)
            this.msgLength = this.chatDetailData.totalCount()
            this.scroller.scrollToIndex(this.msgLength - 1)
          })
        Image($r('app.media.type_select'))
          .height(20)
          .width(20)
          .margin({ right: 10 })
      }
      .backgroundColor("#e3e3e3")
      .width("100%")
      .padding(10)
    }
    .backgroundColor("#f3f3f3")
    .height("100%")
  }

  async convertResourceToString(resource: Resource) {
    let context = getContext(this)
    let manager = context.resourceManager
    return await manager.getStringValue(resource.id)
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }

  makeDataLocal() {
    let tdate = new Date()
    let userMyself = new ChatContact('1', $r('app.string.myself'))
    let userFriend = new ChatContact('2',  `朋友${router.getParams()['chatId']
      .toString()}`, `/resources/images/photo${(parseInt(
      router.getParams()['chatId']) % 50).toString()}.jpg`)
    let sum = 0
    for (let i = 0; i < 1000; i++) {
      let msg: TextMessage | ImageMessage
      let msgBody: MessageBase
      if (sum % 2 === 0) {
        msg = new TextMessage(`我是第${i.toString()}条消息`)
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), userFriend, userMyself, msg, 1, tdate.getSeconds())
        } else {
          msgBody = new MessageBase(i.toString(), userMyself, userFriend, msg, 1, tdate.getSeconds())
        }
      } else {
        let imagestr = `/resources/images/photo${(i % 50).toString()}.jpg`
        msg = new ImageMessage(40, 50, imagestr)
        if (i % 2 === 0) {
          msgBody = new MessageBase(i.toString(), userFriend, userMyself, msg, 2, tdate.getSeconds())
        } else {
          msgBody = new MessageBase(i.toString(), userMyself, userFriend, msg, 2, tdate.getSeconds())
        }
      }
      if (i % 2 === 0) sum++
      this.chatDetailData.pushData(msgBody)
    }
    this.msgLength = this.chatDetailData.totalCount()
  }

  async aboutToAppear() {
    this.makeDataLocal()
  }

}

@Component
struct ChatItemView {
  private msg: MessageBase
  @Link imgFile: image.PixelMap
  @State image: PixelMap = undefined

  build() {
    Column() {
      if (this.msg.from.userId != '1') {
        // 聊天页面对方的消息
        Row() {
          Image(this.msg.from.userImage)
            .width(40)
            .height(40)
            .borderRadius(5)
          Column() {
            Text(this.msg.from.userName)
            if (this.msg.msgType === 1) {
              Text((this.msg.msgBody as TextMessage).msg)
                .fontSize(15)
                .fontColor("#000")
                .backgroundColor(Color.White)
                .padding(10)
            } else if (this.msg.msgType === 2) {
              Image((this.msg.msgBody as ImageMessage).img)
                .width((this.msg.msgBody as ImageMessage).width)
                .height((this.msg.msgBody as ImageMessage).height)
            }
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 5 })
        }
        .width("100%")
        .alignItems(VerticalAlign.Top)
        .margin({ top: 15 })
        .padding({ right: 50 })
      } else {
        // 聊天页面本人消息
        Row() {
          Image(this.msg.from.userImage)
            .width(40)
            .height(40)
            .borderRadius(5)
          Column() {
            Text(this.msg.from.userName)
            if (this.msg.msgType === 1) {
              Text((this.msg.msgBody as TextMessage).msg)
                .fontSize(15)
                .fontColor("#000")
                .backgroundColor("#7fec7d")
                .borderRadius(5)
                .padding(10)
            } else if (this.msg.msgType === 2) {
              Image((this.msg.msgBody as ImageMessage).img)
                .width((this.msg.msgBody as ImageMessage).width)
                .height((this.msg.msgBody as ImageMessage).height)
            } else if (this.msg.msgType === 3) {
              // 接收分享的页面
              Column() {
                Text((this.msg.msgBody as ImgTextMessage).msg)
                  .backgroundColor("#FFFFFF")
                  .width("100%")
                  .fontSize(15)
                  .fontColor("#000")
                  .borderRadius(5)
                  .padding(10)
                Image((this.msg.msgBody as ImgTextMessage).img)
                  .width((this.msg.msgBody as ImgTextMessage).width)
                  .height((this.msg.msgBody as ImgTextMessage).height)
                  .objectFit(ImageFit.Contain)
              }
              .margin({ left: "40%" })
              .padding({ left: "2%", right: "2%", bottom: "2%" })
              .backgroundColor("#FFFFFF")
            } else if (this.msg.msgType == 4) {
              Image((this.msg.msgBody as FileMessage).img)
                .width((this.msg.msgBody as FileMessage).width)
                .height((this.msg.msgBody as FileMessage).height)
                .objectFit(ImageFit.Contain)
            }
          }
          .alignItems(HorizontalAlign.End)
          .margin({ right: 5 })
        }
        .alignItems(VerticalAlign.Top)
        .width("100%")
        .direction(Direction.Rtl)
        .padding({ left: 50 })
        .margin({ top: 15 })
      }
    }
  }
}

class ChatDetailData extends BasicDataSource {
  msgList: Array<MessageBase> = []

  public totalCount(): number {
    return this.msgList.length
  }

  public getData(index: number): any {
    return this.msgList[index]
  }

  public addData(index: number, data: MessageBase): void {
    this.msgList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: MessageBase): void {
    this.msgList.push(data)
    this.notifyDataAdd(this.msgList.length - 1)
  }
}

