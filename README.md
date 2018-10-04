## 观察者模式
观察者模式让一个对象观察另一个对象的改变。在本章节，你将学习两种实现观察者模式的方法：
1. 使用 KVO
2. 使用一个`Observable`包装。

UML 图如下：
![](http://ohg2bgicd.bkt.clouddn.com/1538641129.png)
这个模式包含两个主要对象：
1. **Subject**是被观察对象。
2. **Observer**是观察对象。

不幸的是，Swift 4现在没有语言层面的 KVO 支持。我们需要继承`Foundation`的`NSObject`,`NSObject`使用`Objective-C`runtime来实现 KVO。如果你不想或者不能继承`NSObject`,你可以自己封装一个`Observable`类来代替。
在本章，你将会使用 KVO 和`Observable`包装器来实现观察者模式。

## When should you use it?

当你想要在另一个对象改变时收到改变消息时需要使用观察者模式。
这个模式经常在 MVC 中使用，view controller 是观察者，model 作为被观察者。这样 model 可以在改变时可以将改变传递回 view controller 而不需要知道 view controller 的类型。因此，不同的 view controller 可以观察共享 model 类型的变化。 

## Playground example

**观察者模式**是一种**表现类型模式**，这是因为**观察者模式**是关于一个对象观察另一个对象。
下面我们先用 KVO 来实现观察者模式，先添加一个`KVOUser`类：
```swift
import Foundation
// MARK: - KVO
// 1
@objcMembers public class KVOUser: NSObject {
    // 2
    dynamic var name: String
    // 3
    public init(name: String) {
        self.name = name
    }
}
```
这段代码做了一下三件事情：

1. `KVOUser`是一个`NSObject`子类，我们将要观察`KVOUser`。`@objcMembers`的作用和往没个属性前面加`@objc`的作用一样。在 Swift 4中，`NSObject`子类的属性没有自动暴露给`Objective-C`runtime。因为`NSObject`使用runtime 来实现 KVO。所以必须添加`@objcMembers`来让 KVO 工作。
2. `dynamic`的意思是这个属性使用`Objective-C`动态派发系统去调用`setter`和`getter`方法。这是为了让 KVO 工作，因为 KVO 交换了这个属性的 setter 方法来插入一些必要的逻辑。
3. 一个简单的构造器，设置了 name 的值。

接下来，添加以下代码：
```swift
// 1
print("---KVO Example---")
// 2
let kvoUser = KVOUser(name: "Ray")
// 3
var kvoObserver: NSKeyValueObservation? = kvoUser.observe(\.name, options: [.initial, .new]) { (user, change) in
    print("User's name is \(user.name)")
}
```
这段代码做了一下三件事情：
1. 在控制台打印”— KVO Example”
2. 创建了一个 KVOUser 实例。
3. 声明了一个`NSKeyValueObservation?`实例，命名为`kvoObserver`。这就是**观察者**对象。我们可以通过调用`kvoUser.observe`方法获得它。

这个方法自动返回一个非可选`NSKeyValueObservation`类型.然而，我们明确声明这个类型为可选是为了在后面可以设置这个变量为`nil`。
这个方法的第一个参数`keyPath`是观察的属性。我们可以通过使用`\.name`的简写形式来表达。根据上下文，Swift 会将其扩展为`\KVOUser.name`的完全 key path，来唯一标识`KVOUser`的 `name`。`options`是一个`NSKeyValueObservingOptions`的组合，这里我们具体说明我们想要收到`initial`和`new`的值。
最后一个参数是一个闭包，提供了`user`和`change`对象。`user`是改变后的 user。如果`.new`动作触发了闭包，`change`可能包含一个`oldValue`。这里，我们打印了当前`user`的`name`。
运行上面的代码可以看到在控制台打印了两行：
```swift
---KVO Example---
User's name is Ray
```
闭包在我们初始化 observer 时被调用了，因为我们指定了`.initial`。这意味着当初始化时发送观察结果。
接下来我们添加下面的代码来触发`.new`KVO 动作：
```swift
kvoUser.name = "zdp"
```
我们可以看到下面的打印：
```swift
User's name is zdp
```
最后我们添加下面的代码：
```swift
kvoObserver = nil
kvoUser.name = "Ray has left buliding"
```
这里我们设置`kvoObserver`为 `nil`,我们可以观察到在设置`kvoObserver`为`nil`后，控制台不再打印信息。
Swift 4 KVO 的一个非常棒的特性就是我们不用明确 remove KVO 的 observer 或者闭包。代替的，observer 是一个 weak 引用，并且他们相关的闭包在 observer 变为 `nil` 时将自动移除。在Swift 以前版本和`Objective-C`中，你不得不明确调用`removeObserver(_:forKeyPath:)`,否则，在我们视图访问一个deallocated的 observer 时，app 将会 crash。
Swift 4 KVO 自动移除 observers 非常棒，但是这并不能弥补 KVO 最大的缺点，因为我们在使用 KVO 时必须继承`NSObject`并且使用`Objective-C`的 runtime。
如果你不想这样做，你可以创建一个自己的`Observable`包装来打破这种限制。
接下来，我们创建一个自己的`Observable`。
```swift
// 1
public class Observable<Type> {
    
    // MARK: - CallBack

    // 2
    fileprivate class Callback {
        fileprivate weak var observer: AnyObject?
        fileprivate let options: [ObservableOptions]
        fileprivate let closure: (Type, ObservableOptions) -> Void
        
        fileprivate init(observer: AnyObject,
                         options: [ObservableOptions],
                         closure: @escaping (Type, ObservableOptions) -> Void) {
            self.observer = observer
            self.options = options
            self.closure = closure
        }
    }
}
// MARK: - ObservableOptions

// 3
public struct ObservableOptions: OptionSet {
    public static let initial = ObservableOptions(rawValue: 1 << 0)
    public static let old = ObservableOptions(rawValue: 1 << 1)
    public static let new = ObservableOptions(rawValue: 1 << 2)
    
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
```
上面代码做了3件事：
1. 声明了一个`Observable<Type>`的泛型类。
2. 声明了一个内置的，`fileprivate`的类，叫做`Callback`。我们使用他来关联 `observer`,`options`和`closure`。注意，`observer`是一个 `weak`属性，所以需要是一个类。因此我们用`AnyObject`类型来表示它。最后，你将看到如何在 observer 变为 `nil`后去自动移除观察observer。
3. 接下来，我们声明了一个`ObservableOptions`,它和 KVO 的`NSKeyValueObservingOptions`非常相似。因为 Swift 现在不允许内置 `OptionsSets`。所以，我们在`Observable<Type>`的外面声明它。

接下来，我们继续给`Observable<Type>`添加代码：
```swift
// MARK: - Properties
public var value: Type
// MARK: - Object Lifecycle
public init(_ value: Type) {
	self.value = value
}
```
我们声明了一个 value 属性和初始化方法。接下来，我们添加操作 observers 的方法：
```swift
    // MARK: - Managing Observers
    
    private var callbacks: [Callback] = []
    
    public func addObserver(
        _ observer: AnyObject,
        removeIfExists: Bool = true,
        options: [ObservableOptions] = [.new],
        closure: @escaping (Type, ObservableOptions) -> Void) {
        if removeIfExists {
            removeObserver(observer)
        }
        let callback = Callback(observer: observer,
                                options: options,
                                closure: closure)
        callbacks.append(callback)
        
        if options.contains(.initial) {
            closure(value, .initial)
        }
    }
    
    public func removeObserver(_ observer: AnyObject) {
        callbacks = callbacks.filter {
            $0.observer !== observer
        }
    }

	private func removeNilObserverCallbacks() {
        callbacks = callbacks.filter {
            $0.observer != nil
        }
    }
    private func notifyCallbacks(value: Type,
                                 option: ObservableOptions) {
        let callbacksToNotify = callbacks.filter {
            $0.options.contains(option)
        }
        callbacksToNotify.forEach {
            $0.closure(value, option)
        }
    }
```
我们需要在改变属性时通知 observer，所以我们需要在 `value`改变时去做一些事情：
```swift
    public var value: Type {
        didSet {
            removeNilObserverCallbacks()
            notifyCallbacks(value: oldValue, option: .old)
            notifyCallbacks(value: value, option: .new)
        }
    }

```
这里，我们在`value`的`didSet`方法中，添加了一些代码。到这里，我们的`Observable<Type>`已经封装完了，整体代码如下：
```swift

import Foundation
// 1
public class Observable<Type> {
    
    // MARK: - CallBack
    fileprivate class Callback {
        fileprivate weak var observer: AnyObject?
        fileprivate let options: [ObservableOptions]
        fileprivate let closure: (Type, ObservableOptions) -> Void
        
        fileprivate init(observer: AnyObject,
                         options: [ObservableOptions],
                         closure: @escaping (Type, ObservableOptions) -> Void) {
            self.observer = observer
            self.options = options
            self.closure = closure
        }
    }
    
    // MARK: - Properties
    public var value: Type {
        didSet {
            removeNilObserverCallbacks()
            notifyCallbacks(value: oldValue, option: .old)
            notifyCallbacks(value: value, option: .new)
        }
    }
    
    // MARK: - Object Lifecycle
    public init(_ value: Type) {
        self.value = value
    }
    
    // MARK: - Managing Observers
    
    private var callbacks: [Callback] = []
    
    public func addObserver(
        _ observer: AnyObject,
        removeIfExists: Bool = true,
        options: [ObservableOptions] = [.new],
        closure: @escaping (Type, ObservableOptions) -> Void) {
        if removeIfExists {
            removeObserver(observer)
        }
        let callback = Callback(observer: observer,
                                options: options,
                                closure: closure)
        callbacks.append(callback)
        
        if options.contains(.initial) {
            closure(value, .initial)
        }
    }
    
    public func removeObserver(_ observer: AnyObject) {
        callbacks = callbacks.filter {
            $0.observer !== observer
        }
    }
    
    private func removeNilObserverCallbacks() {
        callbacks = callbacks.filter {
            $0.observer != nil
        }
    }
    private func notifyCallbacks(value: Type,
                                 option: ObservableOptions) {
        let callbacksToNotify = callbacks.filter {
            $0.options.contains(option)
        }
        callbacksToNotify.forEach {
            $0.closure(value, option)
        }
    }
}

// MARK: - ObservableOptions

// 3
public struct ObservableOptions: OptionSet {
    public static let initial = ObservableOptions(rawValue: 1 << 0)
    public static let old = ObservableOptions(rawValue: 1 << 1)
    public static let new = ObservableOptions(rawValue: 1 << 2)
    
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

```
接下来，我们测试一下：
```swift
//MARK: - Observable Example

public class User {
    public let name: Observable<String>
    public init(name: String) {
        self.name = Observable(name)
    }
}
public class Observer { }
print("")
print("--- Observable Example ---")
```
`User`是一个**Subject**,它有一个`name`属性，我们将观察这个属性。`Observer`是一个观察者** observer**，这可以是一个`NSObject`实例或者任意的类。
到这里，控制台只打印了以下内容：
```swift

--- Observable Example ---
```
我们接下来添加以下代码测试：
```swift
let user = User(name: "Madeline")

var observer: Observer? = Observer()

user.name.addObserver(observer!,
                      options: [.initial, .new]) {
                        name , change in
                        print("User's name is \(name)")
    
}
```
运行到这里，可以看到控制台打印内容如下：
```swift

--- Observable Example ---
User's name is Madeline
```
接下来，添加以下代码：
```swift
user.name.value = "Amelia"
```
控制台打印如下：
```swift

--- Observable Example ---
User's name is Madeline
User's name is Amelia
```
接下来测试吧 observer 置为`nil`,看下会不会自动移除。
```swift
observer = nil

user.name.value = "Amelia is outta here!"
```
控制台内容如下：
```swift

--- Observable Example ---
User's name is Madeline
User's name is Amelia
```
通过内容，我们可以看到，我们把 observer 置为 `nil`后，再改变 value，我们将观察不到任何信息。

## What should you be careful about?

对简单的 models 或者一些从来不会改变的属性使用观察者模式是一种过分的行为，这可能会导致一些不必要的工作。
在我们实施观察者模式之前，我们需要确定我们希望改变什么以及在什么条件下改变。如果我们不能确定对象或者属性发生改变的原因，我们最好不要立马实施 KVO/Observable。
作为一个特殊标识，如果一个属性从来不会改变，就不要去把它做为一个 observable 的属性。

## Tutorial project

这里我们会继续给以前的 app 增加功能。我们将使用这个模式在”Seletct Question Group”页面展示用户最新的分数。并且可以保存分数，当我们杀掉 app 后再次进来还会显示分数。在这个例子中，我们将使用`Observable`来代替 KVO。实现效果如下：

<img src="http://ohg2bgicd.bkt.clouddn.com/2018-10-04%2021.23.38.gif?imageMogr2/auto-orient/thumbnail/375x/blur/1x0/quality/100|imageslim" width="375px" />


## 预告
下节我们将学习 Builder Pattern。下节，我们将会使用 Builder Pattern 给 app 增加让用户自己创建问题组的功能。
