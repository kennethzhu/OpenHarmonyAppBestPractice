import util from '@ohos.util';
import Logger from './Logger';

const TAG: string = 'ChatList_JsonParser'


function bufferToString(buffer: ArrayBuffer): string {
  let textDecoder = util.TextDecoder.create('utf-8', {
    ignoreBOM: true
  });
  let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
    stream: true
  });
  return resultPut;
}

function jsonFileToString(fileDir: string): object {
  let jsonStr = JSON.parse('{}')
  getContext().resourceManager.getRawFileContent(fileDir).then((value) => {
    let jsonStr = JSON.parse(bufferToString(value.buffer))
    return jsonStr
  }).catch((error) => {
    Logger.error(TAG, 'jsonParseError:' + JSON.stringify(error))
  })
  return jsonStr
}

export { jsonFileToString }