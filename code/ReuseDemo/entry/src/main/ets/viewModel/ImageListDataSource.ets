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

import { BasicDataSource } from './BasicDataSource'
import Logger from '../utils/Logger'

const TAG: string = 'ReUseDemo-ImageListDataSource'

export class MyImage {
  image_id: string
  image_path: string

  constructor(image_id: string, image_path: string) {
    this.image_id = image_id
    this.image_path = image_path
  }

  toString(): string {
    return '[MyImage] image_id= ' + this.image_id + ',image_path= ' + this.image_path
  }
}

export class ImageListDataSource extends BasicDataSource {
  private imageList: MyImage[] = []

  public constructor() {
    super()
    for (let i = 0;i < 10000; i++) {
      let imageStr = `/resources/images/photo${(i % 50).toString()}.jpg`

      this.imageList.push(new MyImage(i.toString(), imageStr))
    }
  }

  public totalCount(): number {
    return this.imageList.length
  }

  public getData(index: number): MyImage {
    Logger.info(TAG, 'getData, index=' + index)
    return this.imageList[index]
  }

  public addData(index: number, data: MyImage): void {
    this.imageList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: MyImage): void {
    this.imageList.push(data)
    this.notifyDataAdd(this.imageList.length - 1)
  }
}