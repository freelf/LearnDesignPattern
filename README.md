## 介绍策略模式
策略模式定义了一系列可交换的对象，这些对象可以在运行时设置或者切换。这个模式有三部分。
* **使用策略的对象**：在 iOS 开发中这个对象通常是一个`UIViewController`，但是理论上可以是任何需要交换表现的对象。
* **策略协议**：定义了每个策略必须实现的方法。
* **策略对象**：遵守策略协议的对象。

UML 图如下：
![](http://ohg2bgicd.bkt.clouddn.com/1538047244.png)
## When should you use it?
当你有两个或多个需要交换的表现时需要使用策略模式。
这个模式和委托模式相似：因为两个模式都是依赖于协议而不出具体对象来提高弹性。通常，任何实现了策略协议的对象可以在运行时被用做协议对象。
不想委托，策略模式使用一系列对象。
委托经常在运行时确定。比如，`UITableView`的`dataSource`和`delegate`可以在 Interface Builder 中设置，但是它们在运行时很少改变。
然而，策略的目的是在运行时可以轻松的交换。

## Playground example

策略模式是一种表现型模式，因为策略模式是关于一个对象使用另一个对象来做一些事情。
下面的代码例子是一个关于电影评分的例子。想象一个 app 使用几个电影评分服务。比如：烂番茄，IMDb和Metacritic。为了不重复为每种服务写代码，我们来使用策略模式来简化实现。可以创建一个定义了通用 API 的协议来获取每种服务。
首先我们定义一个策略协议：
```swift
public protocol MovieRatingStrategy {
  // 1
  var ratingServiceName: String { get }
  
  // 2
  func fetchRating(for movieTitle: String,
           success: (_ rating: String, _ review: String) -> ())
}
```
1. 我们使用`ratingServiceName`来表示提供评分的服务。比如：它可能是烂番茄。
2. 我们使用`fetchRatingForMovieTitle(_:success:)`来获取异步获取电影评分。在真实的 app 中，可能需要一个失败的 closure。

接下来，添加烂番茄客户端的实现代码：
```swift
public class RottenTomatoesClient: MovieRatingStrategy {
  public let ratingServiceName = "Rotten Tomatoes"
  
  public func fetchRating(
    for movieTitle: String,
    success: (_ rating: String, _ review: String) -> ()) {
    
    // In a real service, you'd make a network request...
    // Here, we just provide dummy values...
    let rating = "95%"
    let review = "It rocked!"
    success(rating, review)
  }
}

```
然后，添加 IMDb 客户端的实现代码：
```swift
public class IMDbClient: MovieRatingStrategy {
  public let ratingServiceName = "IMDb"
  
  public func fetchRating(
    for movieTitle: String,
    success: (_ rating: String, _ review: String) -> ()) {
    
    let rating = "3 / 10"
    let review = """
    It was terrible! The audience was throwing rotten
    tomatoes!
    """
    success(rating, review)
  }
}
```
因为所有提供服务的客户端都遵守了`MovieRatingStrategy`。使用策略的对象不必要直接指导它们的类型，代替的，它们仅仅依赖协议。
作为例子，添加下面代码：
```swift
import UIKit

public class MoviewRatingViewController: UIViewController {
  
  // MARK: - Properties
  public var movieRatingClient: MovieRatingStrategy!
  
  // MARK: - Outlets
  @IBOutlet public var movieTitleTextField: UITextField!
  @IBOutlet public var ratingServiceNameLabel: UILabel!
  @IBOutlet public var ratingLabel: UILabel!
  @IBOutlet public var reviewLabel: UILabel!
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    ratingServiceNameLabel.text =
      movieRatingClient.ratingServiceName
  }
  
  // MARK: - Actions
  @IBAction public func searchButtonPressed(sender: Any) {
    guard let movieTitle = movieTitleTextField.text
      else { return }
    
    movieRatingClient.fetchRating(for: movieTitle) {
      (rating, review) in
      self.ratingLabel.text = rating
      self.reviewLabel.text = review
    }
  }
}

```
当这个 view controller 在 app 中实例化时，需要设置`movieRatingClient`属性。注意，view controller 不知道`MovieRatingStrategy`具体实现。
使用哪个 MovieRatingStrategy 的决定可以推迟到运行时，可以让用户选择。

## What should you be careful about？

小心滥用这个模式。实际情况下，如果一个表现不会改变，可以直接放到使用的view controller 或者对象的上下文中。使用这个模式得技巧是知道什么时候切换行为。并且可以在确定需要的地方 lazy 的去做。

## Tutorial project

我们接着委托模式继续做那个 app。我们添加一个可以随机顺序回答问题的机制。这样我们就可以不按顺序回答问题了。但是，有些人可能想要顺序回答问题。这里我们用策略模式来实现。实现效果：
![](http://ohg2bgicd.bkt.clouddn.com/2018-09-27%2019.02.31.gif?imageMogr2/auto-orient/thumbnail/350x/blur/1x0/quality/100%7Cimageslim)
[Demo]()
## 预告
下一节将要介绍单例模式。