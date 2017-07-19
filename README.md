CoreML
===
## 前言
使用CoreML能讓我們快速上手使用別人訓練好的模型。我們幾乎不需要了解任何機器學習的知識，就可以通過CoreML來體驗機器學習的樂趣，如果你想使用已經有的模型，還可以使用Apple提供了一個Python工具 `coremltools`，可以幫我們把 Caffe、Keras 或 scikit-learn模型轉換為 CoreML 的模型。

---

直接切入主題請下載[初使專案](https://github.com/NickYuu/Swift_CoreML)開始，裡面有一份初使專案及完成的專案。

## import CoreML 及 Vision
在ViewController中 import CoreML 及 Vision。
```swift
import CoreML
import Vision
```

## 下載及導入模型
Apple有提供幾個模型讓我們使用，請到 [machine learning](https://developer.apple.com/machine-learning/) 頁面，往下拉，我們使用 `Places205-GoogLeNet` 模型。
![](https://i.imgur.com/rczx0xO.png)

下載後開啟起始專案，將模型直接拉近專案內，右邊的視窗可以看到模型的一些資訊，下面為模型的輸入及輸出，這個模型可以幫我們預測205種的地點圖片，我們要輸入一張224x224大小的RGB圖片，而模型的輸出有兩部分`sceneLabel`表示預測可能性最高的結果，`sceneLabelProbs`表示了所有預測結果及評分。
![](https://i.imgur.com/JGPFQHh.png)


## 載入模型
載入模型非常直覺的 `GoogLeNetPlaces()` ，執行預測會發現他要我們傳入一個不知什麼東西的 `CVPixelBuffer`。
![](https://i.imgur.com/RVeLRaI.png)


這時候剛剛 import 的 `Vision` ，就能幫我們處理這件事情。
```swift
func predict(_ input: UIImage) {
guard let ciImage = CIImage(image: input) else {
fatalError("轉換 CIImage 失敗")
}
// 載入模型
guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
fatalError("載入CoreML模型失敗")
}

// 建立 Vision Request
....

}
```

## 建立Vision Request
Vision 除可以幫我們載入模型，還會讓我們可以很容易的將圖片輸入，並執行預測返回結果給我們。
```swift
func predict(_ input: UIImage) {
...
// 建立 Vision Request
let request = VNCoreMLRequest(model: model) {
(request, error) in
guard let results = request.results as? [VNClassificationObservation],
let firstResult = results.first else {
fatalError("取得結果失敗")
}

DispatchQueue.main.async {
self.descriptionLB.text = "我覺得是： " + firstResult.identifier
self.probabilityLB.text = "信心分數： \(firstResult.confidence * 100)"
}
}

// 執行並處理 Request
...
}
```
目前還沒有執行，等一下我們會讓他在global queue執行，所以更新`UI`記得要拉回mine queue做。


## 執行Vision Request
我們要在這邊傳入一個 `CIImage` ，也就是這個方法前面我們轉換的。



```swift
func predict(_ input: UIImage) {
guard let ciImage = CIImage(image: input) else {
fatalError("轉換 CIImage 失敗")
}
// 載入模型
guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
fatalError("載入CoreML模型失敗")
}

// 建立 Vision Request
let request = VNCoreMLRequest(model: model) {
(request, error) in
guard let results = request.results as? [VNClassificationObservation],
let firstResult = results.first else {
fatalError("取得結果失敗")
}

DispatchQueue.main.async {
self.descriptionLB.text = "我覺得是： " + firstResult.identifier
self.probabilityLB.text = "信心分數： \(firstResult.confidence * 100)"
}
}

// 執行並處理 Request
let handler = VNImageRequestHandler(ciImage: ciImage)

DispatchQueue.global(qos: .userInteractive).async {
try? handler.perform([request])
}
}
```

就可以跑起來了，新版的模擬器好高級喔Home鍵還可以按。

![](https://i.imgur.com/hOpTiN5.gif)


