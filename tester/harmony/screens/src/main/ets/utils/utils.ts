/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { util } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { http } from '@kit.NetworkKit'
import { fileIo } from '@kit.CoreFileKit';
import resourceManager from '@ohos.resourceManager';

import { ErrorCode } from './ErrorCode';
import { RNImageSRC } from './RNImageSRC';
import { PhotoManipulatorError } from './PhotoManipulatorError';

export function isCoilImg(uri: string | null): boolean {
  if (!uri) {
    return false;
  }
  return uri.startsWith("http://") || uri.startsWith("https://") || uri.startsWith("file://")
    || (uri.startsWith("data:") && uri.includes("base64") && (uri.includes("img")
      || uri.includes("image"))) || !uri.startsWith("asset:");
}

export function getImageUri(url: string): string {
  if(url.startsWith("file")){
    let realUrl = url.substring(url.indexOf("/data/"));
    url =  realUrl;
  }
  if (url.indexOf("//") > 0) {
    let realUrl = url.substring(url.indexOf("//") + 2);
    url = "assets/" + realUrl;
  }
  return url;
}

/**
 * handle src.
 */
export async function obtainImageInfoFromPath(resourceManager: resourceManager.ResourceManager, src: string): Promise<RNImageSRC> {
  // write the image to system
  let rn8mage:RNImageSRC;
  //处理require类型图片
  if (!isCoilImg(src)) {
    let imageSource: image.ImageSource
    let sourceOptions: image.SourceOptions =
      {
        sourceDensity: 120,
      };
    let resource = resourceManager.getRawFileContentSync(getImageUri(src));
    let arrayBuffer = resource.buffer.slice(resource.byteOffset, resource.byteLength + resource.byteOffset)
    // arrayBuffer.
    imageSource = image.createImageSource(arrayBuffer, sourceOptions)
    let imageInfo = imageSource.getImageInfoSync().size;
    rn8mage = new RNImageSRC(imageInfo.width, imageInfo.height, getImageUri(src), imageSource );
    return rn8mage;
  } else {
    //处理http、https类型图片
    if (src.startsWith("http://") || src.startsWith("https://")) {
      let dir = globalThis.context.cacheDir
      let filePath = dir + "/" + util.generateRandomUUID(true).toString() + src.substring(src.lastIndexOf("/") + 1, src.length)
      let httpRequest: http.HttpRequest = http.createHttp();
      let options: http.HttpRequestOptions = {
        expectDataType: http.HttpDataType.ARRAY_BUFFER, // 可选，指定返回数据的类型。
        priority: 1, // 可选，默认为1。
        readTimeout: 60000, // 可选，默认为60000ms。
        connectTimeout: 60000, // 可选，默认为60000ms。
        usingCache: true
      };
      await httpRequest.request(src, options).then((dataHttpResponse: http.HttpResponse) => {
        if (dataHttpResponse.responseCode === http.ResponseCode.OK) {
          let imageSource: image.ImageSource = image.createImageSource(dataHttpResponse.result as ArrayBuffer);
          let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
          // 写入文件
          fileIo.writeSync(file.fd, dataHttpResponse.result as ArrayBuffer);
          // 关闭文件
          fileIo.closeSync(file.fd);
          let imageInfo = imageSource.getImageInfoSync(0);
          rn8mage = new RNImageSRC(imageInfo.size.width, imageInfo.size.height, filePath, imageSource)
          httpRequest.destroy();

        } else {
          httpRequest.destroy();
          throw new PhotoManipulatorError(ErrorCode.LOAD_IMAGE_FAILED, "image url is INVALID")
        }
      })
      return rn8mage;
    } else {//处理file类型图片
      let url: string = getImageUri(src);
      let imageSource = image.createImageSource(url);
      if (imageSource === undefined) {
        throw new PhotoManipulatorError(ErrorCode.LOAD_IMAGE_FAILED, "image url is INVALID")
      }
      let imageInfo = imageSource.getImageInfoSync();
      rn8mage = new RNImageSRC(imageInfo.size.width, imageInfo.size.height, src, imageSource);
      return rn8mage;
    }
  }
}




