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

import Logger from './Logger'
import { ChatModel, ChatContact } from '../viewModel/MsgBase'
import { ChatListData } from '../viewModel/ChatListDataSource'
import Constants from '../utils/Constants'
import { userNameBuckets, lastMsgBuckets } from './chatModelMockElement'
import { jsonFileToString } from './JsonParser'

const TAG: string = 'ChatList_DataFactory'

function makeDataLocal(listData: ChatListData): void {
  Logger.info(TAG, 'makeDataLocal')
  for (let i = 0;i < Constants.DATA_MOCK_COUNT; i++) {
    listData.pushData(makeChatModel(i))
  }
}

function makeDataList(listData: Array<ChatModel>): void {
  Logger.info(TAG, 'makeDataList')
  for (let i = 0;i < Constants.DATA_MOCK_COUNT; i++) {
    listData.push(makeChatModel(i))
  }
}

function makeChatModel(id: number): ChatModel {
  let imageStr = `/resources/images/photo${(getRandomNum(Constants.IMAGE_MOCK_COUNT)).toString()}.jpg`
  let contactTemp = new ChatContact(id.toString(), userNameBuckets[getRandomNum(Constants.IMAGE_MOCK_COUNT)], imageStr)
  let lastMsgTime = getRandomNum(Constants.HOUR_PER_DAY) + ':' + getRandomNum(Constants.MINUTE_PER_HOUR)
  let unreadMsgCount = getRandomNum(Constants.UPPER_LIMIT_UNREAD)
  return new ChatModel(contactTemp, lastMsgBuckets[getRandomNum(Constants.IMAGE_MOCK_COUNT)], lastMsgTime, unreadMsgCount)
}

function getRandomNum(openIntervalMax): number {
  var rand = Math.random();
  return (Math.round(rand * openIntervalMax));
}

export { makeDataLocal, makeDataList }