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

import { ChatListDisplayView } from "@ohos/chatList"
import { FriendsPage } from './FriendsPage'
import { DiscoverPage } from './DiscoverPage'
import { SettingPage } from './SettingPage'
import { TopBar } from '../view/TopBar'

const TAG: string = "[Sample_Chat]"

PersistentStorage.persistProp('lazy_for_each', true);
PersistentStorage.persistProp('reusable', true);
PersistentStorage.persistProp('img_syncLoad', true);
PersistentStorage.persistProp('page_layout', true);
PersistentStorage.persistProp('list_cachedCount', true);

@Entry
@Component
struct Index {
  @StorageLink('page_layout') page_layout: boolean = AppStorage.get('page_layout')

  aboutToAppear(): void {
  }

  onPageShow() {
  }

  build() {
    Row() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            TopBar()
            ChatListDisplayView()
          }
        }
        .tabBar({ icon: $r('app.media.afr'), text: $r('app.string.chat') })

        TabContent() {
          FriendsPage()
        }
        .tabBar({ icon: $r('app.media.contact_list_normal'), text: $r('app.string.contacts') })

        TabContent() {
          DiscoverPage()
        }
        .tabBar({ icon: $r('app.media.find_normal'), text: $r('app.string.discovery') })

        TabContent() {
          SettingPage()
        }
        .tabBar({ icon: $r('app.media.profile_normal'), text: $r('app.string.my') })
      }
      .backgroundColor('#EEEEEE')
      .barWidth(400)
      .barHeight(50)
      .animationDuration(0)
    }
  }
}

