## 单例模式
单例模式限制一个类仅仅有一个实例。每个这个类的引用都指向同一个实例。在 iOS 开发中非常常见这种模式，因为 Apple 广泛使用单例模式。
UML 图如下：
![](http://ohg2bgicd.bkt.clouddn.com/1538101105.png)
“singleton plus”模式也很常用，这个模式提供了一个共享单例，但是也允许其他实例被创建。

## When should you use it?

如果一个类有多个实例会导致问题或者不符合逻辑时使用单例模式。
如果在大部分时间共享实例有用，但是你也想要创建一个自定义实例时使用 sigleton plus 模式。`FileManager`就是一个例子。他有一个`default`实例，这是一个单例，但是你也可以自己创建一个。如果你再后台线程使用它，通常需要创建一个自己的。

## Playground example

**单例模式**是**创建模式**的一种。因为单例是关于创建一个共享实例。
单例和 singleton plus 在 Apple 的框架中很普遍。
比如：`UIApplication`是一个纯单例。
```swift
import UIKit

// MARK: - Singleton
let app = UIApplication.shared
// let app2 = UIApplication()
```
如果你把 app2 解注，会编译错误。`UIApplication`不允许创建其他实例。
你也可以创建自己的单例类，比如以下代码：
```swift
public class MySingleton {
  // 1
  static let shared = MySingleton()
  // 2
  private init() { }
}
// 3
let mySingleton = MySingleton.shared
// 4
// let mySingleton2 = MySingleton()
```
1. 首先声明一个 `public static` 属性，叫做`shared`,这是一个单例实例。
2. 把`init`方法私有化，不允许创建其他的实例。
3. 使用`MySingleton.shared`获取单例。
4. 如果你创建额外的实例将会导致编译错误。

singleton plus 例子如下：
```swift
// MARK: - Singleton Plus
let defaultFileManager = FileManager.default
let customFileManager = FileManager()
```
`FileManager`提供了`default`单例。
我们可以创建一个新的实例，并不会导致编译错误。这说明`FileManager`提供了 singleton plus 模式。
我们可以很简单的创建自己的 singleton plus 模式类，比如下面代码：
```swift
public class SingletonPlus {
  // 1
  static let shared = SingletonPlus()
  // 2
  public init() { }
}
// 3
let singletonPlus = SingletonPlus.shared
// 4
let singletonPlus2 = SingletonPlus()
```
1. 我们声明一个`shared`属性，就像单例模式一样。有时这个属性也叫做`default`。
2. 不想纯单例，我们把`init`方法声明为`public`,允许创建额外的实例。
3. 可以通过`MySingletonPlus.shared`获取单例。
4. 也可以创建一个新的实例。

## What should you be careful about?

单例模式非常容易滥用。
如果你某个地方想用单例，首先考虑下其他方式完成任务。
比如：如果你仅仅从一个 view controller 传递消息到另一个 view controller，单例不适合。可以通过一个初始化函数或者属性传递。
如果你确定你确实需要单例，考虑下是否 singleton plus 更有用。
是否多个实例会导致问题？是否自定义实例会有用处？这两个问题的答案将会决定到底使用纯单例还是 singleton plus。
单例通常会为测试带来麻烦。如果你将状态存在全局对象中，比如单例。那么测试的顺序可能很重要。模仿这些顺序很痛苦。这就是导致测试很痛苦的原因。
如果你经常需要一些自定义实例，那么使用普通对象最好。
## Tutorial project

接下在我们继续以前的工程。
上一章我们在使用策略时采用了硬编码的方式。用户不能手动改变策略。这节的任务就是可以让用户自己选择问题展示的方式。可以切换顺序展示还是随机展示。
首先我们需要有一个地方去存储 app 的设置。你需要创建一个单例来实现这个。
实现效果如下：

<img src="http://ohg2bgicd.bkt.clouddn.com/2018-09-28%2012.06.40.gif" width="375px" />

[Demo](#)

## 预告

下节将介绍备忘录模式。
