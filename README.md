## 介绍 MVC
MVC 设计模式把对象分为三个不同的类型： Models，Views和 Controllers。
UML 图表示如下：
![](https://nightwish.oss-cn-beijing.aliyuncs.com/15341242390937.jpg)
MVC 是在 iOS 编程中是非常常见的，因为 Apple 在 UIKit 中大量选用了这种设计模式。
* **Models**保持应用数据，通常为 structs 或者简单的 classes。
* **Views**在屏幕上显示看的见的元素和 controls，通常为`UIView`的子类。
* **Controllers**在 models 和 views 中间协调，通常为`UIViewController`的子类。

Controllers 允许对它的 model 和 view 强引用，所以它可以直接操作model 和 view。Controllers 可以有不止一个 model 或者 view。
相反的，models 和 views 不应该保持他们所属 controller 的强引用。这会导致一个循环引用。
作为替代，通过属性监听，models 和它们的 controller 进行通信。views 通过`IBAction`和 controller 进行通信。
这可以让你在几个 controllers 中可以复用 models 和 views。
>注意：Views 可能有一个弱引用 delegate 指向拥有它的 controller。比如，一个 `UITableView`可能持有一个拥有它的 view controller 弱引用作为它的 `delegate` 或者 `dataSource`。然而，table view 不用明确知道这是拥有它的 view controller。
Controllers 非常难以复用，因为它们的逻辑是非常具体的描述它们所做的任务。因此，MVC 不尝试去复用 Controllers。
## 什么时候使用 MVC
一般我们一开始做一个 app 时，我们使用 MVC。
接下来，我们可能使用除了 MVC 额外的设计模式，但是没关系，在需要时我们再引入更多的设计模式。
## Playground example
设计模式可以分为三类
* 结构类型：描述一个大的子系统如何组合对象。
* 表现类型：描述对象如何和其他对象联系。
* 创建类型：创建对象。

很明显，MVC 是一个结构类型的模式。
接下来，我们看一下如何组合对象，来构成一个地址屏幕 app。
model：
```swift
// MARK: - Address
public struct Address {
    public var street: String
    public var city: String
    public var state: String
    public var zipCode: String
}
```
view：

```swift
// MARK: - AddressView
public final class AddressView: UIView {
    @IBOutlet public var streetTextField: UITextField!
    @IBOutlet public var cityTextField: UITextField!
    @IBOutlet public var stateTextField: UITextField!
    @IBOutlet public var zipCodeTextField: UITextField!
}
```
controller：

```swift
// MARK: - AddressViewController
public final class AddressViewController: UIViewController {
    
    // MARK: - Properties
    public var address: Address? {
        didSet {
            updateViewFromAddress()
        }
    }
    public var addressView: AddressView! {
        guard isViewLoaded else { return nil }
        return view as! AddressView
    }
    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromAddress()
    }
    
    private func updateViewFromAddress() {
        guard let addressView = addressView,
            let address = address else { return }
        addressView.streetTextField.text = address.street
        addressView.cityTextField.text = address.city
        addressView.stateTextField.text = address.state
        addressView.zipCodeTextField.text = address.zipCode
    }
    // MARK: - Actions
    @IBAction public func updateAddressFromView(_ sender: AnyObject) {
        guard let street = addressView.streetTextField.text, street.count > 0,
            let city = addressView.cityTextField.text, city.count > 0,
            let state = addressView.stateTextField.text, state.count > 0,
            let zipCode = addressView.zipCodeTextField.text, zipCode.count > 0
            else {
                // TO-DO: show an error message, handle the error, etc
                return
        }
        address = Address(street: street, city: city,
                          state: state, zipCode: zipCode)
    }
}
```
我们在，`address`属性变化时去更新 `view`，并且在 `view`有交互时通过` IBAction`去更新 `model`。
上面只是给出了一个简单的例子来表示 MVC 是如何工作的。我们可以看到 controller 如何持有 model 和 views，并且通过 controller 交互。
## 使用时应该注意的地方
MVC 是一个好的开始，但是它有局限性。不是每一个对象都能很好的归类于 model，view ，controller 的范围中。因此，只是用 MVC 的应用在 controllers 中有很多逻辑，导致 view controller 越来越大。
为了解决这个问题，需要在需要时引入其他的设计模式。
## 教程项目
通过这一整章，我们会做一个应用叫做：Rabble Wabble(就是一个类似背单词的 app)。这一小篇的效果如下：
<img src="https://nightwish.oss-cn-beijing.aliyuncs.com/MVC.gif" width="375px" />
功能类似一个背单词的 app，点击空白处显示答案，点正确，正确数加1，点错误错误数加1。很简单吧，利用这个功能，我们可以了解下 MVC 各个模块通信方式。通过下面的学习，我们将逐步完善这个应用。
