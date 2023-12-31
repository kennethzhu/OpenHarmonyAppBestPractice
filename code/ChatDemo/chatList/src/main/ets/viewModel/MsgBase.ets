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

import image from '@ohos.multimedia.image'

/**
 * 聊天list中item对象
 * @param user 用户名
 * @param lastMsg 最后一天信息
 * @param time 时间
 */
export class ChatModel {
  user: ChatContact
  lastMsg: string
  lastTime: string
  unreadMsgCount: number

  constructor(user: ChatContact, lastMsg: string ,lastTime: string,unreadMsgCount: number) {
    this.user = user
    this.lastMsg = lastMsg
    this.lastTime = lastTime
    this.unreadMsgCount = unreadMsgCount
  }

  toString(): string {
    return this.user.toString() + "  " + this.lastMsg
  }
}

enum MsgType {
  TEXT = 1,
  IMAGE = 2,
  TEXT_AND_IMAGE = 3,
  NET_IMAGE = 4
}

// 聊天信息
export class MessageBase {
  img: image.PixelMap
  msgId: string
  from: ChatContact
  to: ChatContact
  msgBody: MessageBody
  msgType: MsgType
  msgTime: number

  constructor(id: string, from: ChatContact, to: ChatContact, msg: MessageBody, type: number, time?: number) {
    this.msgId = id
    this.from = from
    this.to = to
    this.msgBody = msg
    this.msgType = type
    this.msgTime = time
  }

  toString(): string {
    return this.msgId + "  " + this.from + "  " + this.to + "  " + this.msgBody + "  " + this.msgType + "  "
      + this.msgTime
  }
}

export class MessageBody {
  toString(): string {
    return ""
  }
}

// 文本消息
export class TextMessage extends MessageBody {
  constructor(msg: string | Resource) {
    super()
    this.msg = msg
  }

  msg: string | Resource
}

// 图片消息
export class ImageMessage extends MessageBody {
  toString(): string {
    return this.height + "  " + this.width + "  " + this.img
  }

  constructor(hei: number, wid: number, img: string) {
    super()
    this.height = hei
    this.width = wid
    this.img = img
  }

  height: number
  width: number
  img: string
}

// wantParams:图片+文本消息
export class ImgTextMessage extends MessageBody {
  toString(): string {
    return this.msg + ' ' +
    this.height + "  " + this.width + "  " + this.img
  }

  constructor(hei: number, wid: number, img: string | Resource, msg: string) {
    super()
    this.height = hei
    this.width = wid
    this.img = img
    this.msg = msg
  }

  height: number
  width: number
  img: string | Resource
  msg: string
}

// wantParams:图片文件
export class FileMessage extends MessageBody {
  height: number | string
  width: number | string
  img: image.PixelMap

  constructor(hei: number | string, wid: number | string, img: image.PixelMap) {
    super()
    this.height = hei
    this.width = wid
    this.img = img
  }
}

// contact
export class ChatContact {
  userId: string
  userName: string | Resource
  userImage: string | Resource

  toString(): string {
    return this.userId + "  " + this.userName + "  " + this.userImage
  }

  constructor(id: string, name: string | Resource, image?: string | Resource) {
    this.userId = id
    this.userName = name
    this.userImage = $r("app.media.personality3")
    if (image != null) {
      this.userImage = image
    }
  }
}

export class FriendMoment {
  id: string
  user: ChatContact
  text: string
  time: string
  imageList: Array<string>

  constructor(id: string, user: ChatContact, text: string, time?: string, List?: Array<string>) {
    this.id = id
    this.user = user
    this.time = time
    this.text = text
    if (List != null) {
      this.imageList = List
    }
  }

  toString(): string {
    return this.id + "  " + this.user.toString() + "  " + this.text + "  " + this.time
  }
}