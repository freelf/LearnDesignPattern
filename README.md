## 介绍委托模式
委托模式使一个对象能够使用另一个对象来提供数据或者执行一些任务，这个模式有三个部分，UML 图如下：
![](https://nightwish.oss-cn-beijing.aliyuncs.com/15344108237603.jpg)
<!-- more -->
* 一个**对象需要委托**：也就是委托对象。通常这个对象有一个`weak` 属性 `delegate`，防止循环引用。
* 一个**委托协议**：这个协议定义了委托应该实现或者可能实现的方法。
* 一个**委托**：实现委托方法的对象。

通过依赖一个委托协议代替一个混合对象使得实现更加有弹性，只要一个对象实现了协议就可以作为一个委托对象。
## 什么时候使用
使用委托模式可以拆分大型类或者创建通用的、可重用的组件。委托关系在 Apple 的框架中很常见，尤其是 `UIKit`。名字中有 `DataSource` 和 `Delegate` 的对象实际上都遵守了代理模式。
在 Apple 的框架中为什么不是一个协议，而是两个？
Apple 的框架通常使用 `DataSource` 来对提供数据的委托方法进行分组，使用 `Delegate` 来对接收数据或者事件的委托方法分组。比如：`UITableViewDataSource` 是想要提供一个 `UITableViewCell` 来展示， `UITableViewDelegate` 通知那行被选中了。
通常 `dataSource` 和 `delegate` 被设置为一个对象，比如拥有 `UITableView`的 view controller。然而，不是必须这样做。把它设置到另一个对象更有好处。
## Playground example
委托协议是一个表现类型的设计模式。这是因为委托都是一个对象和另一个对象交流有关。
下面的代码将创建一个`MenuViewController`，这个 VC 有一个 `tableView`，并且是这个 `tableView` 的委托和数据源。
首先创建 `MenuViewController`：

```swift
import UIKit

class MenuViewController: UIViewController {
  // 1
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.dataSource = self
      tableView.delegate = self
    }
  }
  // 2
  let items = ["Item 1", "Item 2", "Item 3"]
}
```
添加下面的代码，设置 `MenuViewController` 为 `tableView` 的数据源和委托：

```swift
// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {
    let cell = 
      tableView.dequeueReusableCell(withIdentifier: "Cell",
                                    for: indexPath)
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    // To do next....
  }
}
```
`UITableViewDelegate` 和 `UITableViewDataSource` 都是委托协议，他们定义了委托对象必须实现的方法。
可以非常简单的定义你自己的委托。比如：你可以创建一个委托来通知用户点击的 menuItem：

```swift
protocol MenuViewControllerDelegate {
  func menuViewController( _ menuViewController: MenuViewController, didSelectItemAtIndex index: Int)
}
```
接下来，给 `MenuViewController` 添加一个属性：

```swift
var delegate: MenuViewControllerDelegate?
```
iOS 中的习惯是当一个对象创建后来设置委托对象。所以，当创建一个 `MenuViewController` 后，来设置它的委托对象。
最后，当用户点击一个 item，你应该去通知委托对象。我们把 `tableView` 委托的 `didSelectd` 方法添加以下方法：

```swift
delegate?.menuViewController(self, didSelectItemAtIndex: indexPath.row)
```
在委托方法中，一般我们都把需要委托的对象作为参数传过去，在这个例子中就是 `MenuViewController`，这样，委托对象就可以在需要的时候去使用或者检查调用者了。
现在，你已经创建了你自己的委托协议，在一个真实的 app 中，item 在被点击了经常需要处理一些逻辑，比如跳转到一个新的视图。
## 应该注意的地方
委托非常有用，但是经常被滥用。不要为一个对象创建太多的委托。如果一个对象需要几个委托，可能表示这个类做了太多事情。这是应该考虑为特定的情况分解对象的功能，而不是一个包罗万象的类。
很难说清楚多少是多，但是有一个黄金法则。如果你经常在两个类之间来回切换来了解发生了什么，那就说明太多了。同样的，如果你不能理解某个委托的用处，也说明太多了。
## 教程项目
上一篇 MVC 之后，我们已经实现了可以一些功能，比如，点击屏幕可以显示答案，点击正确和错误按钮可以记录正确和错误的个数。
接下来我们需要实现让用户可以选择问题组的一个列表，并且在 `QuestionViewControlle` 中添加了取消按钮、显示当前问题下标和回答完问题再点击正确或者错误按钮返回的操作。这些操作使用委托模式实现。具体效果如下图：
<img src="https://nightwish.oss-cn-beijing.aliyuncs.com/delegate.gif" width="375px" />
## 预告
下一章我们会学习策略模式，并且继续完善 RabbleWabble。
