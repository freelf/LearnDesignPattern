## 构造器模式
构造器模式允许一步一步的创建一个复杂的对象而不是一次创建完成。这个模式包括三个主要类型，UML 图如下：
![构造器模式](https://nightwish.oss-cn-beijing.aliyuncs.com/1538746972.png)
1. **Director**接收输入并且和 builder 协调。**Director**通常是一个 view controller或者是view controller 使用的帮助类。
2. **Product**是被创建的复杂对象，可以是一个class 或者 struct，取决于是否想要引用语义。通常是一个 model。
3. **Builder**接收一步步输入并且控制 product 的创建。经常是一个 class，可以通过引用被复用。

## When should you use it?

当我们想要使用一系列步骤创建一个复杂对象时可以使用构造器模式。当一个 product 需要几个部分输入时这个模式工作尤其优秀。构造器将如何创建product 的输入抽象并且以 director 想要提供输入的任何顺序接收他们。比如：我们可以使用这个模式去实现一个”汉堡构造器”。product 可能是一个`humburger`对象，它有一些输入，比如：肉，配料和胡椒酱。director 可能是一个`employee`对象，这个对象知道如何做汉堡，或者可能是一个 view controller，它可以接收用户的输入。
汉堡构造器可以以任意的顺序接收肉的选择，配料和胡椒酱并且根据需求创建一个汉堡。

## Playground example

**Builder**是一个**创造型模式**。这是因为构造器模式是关于创造复杂产品的一个模式。这里我们将实现一个汉堡构造器的例子。
首先，我们先来创建一个** product**：
```swift
// MARK: - Product
public struct Hamburger {
  public let meat: Meat
  public let sauce: Sauces
  public let toppings: Toppings
}

extension Hamburger: CustomStringConvertible {
  public var description: String {
    return meat.rawValue + " burger"
  }
}

public enum Meat: String {
  case beef
  case chicken
  case kitten
  case tofu
}

public struct Sauces: OptionSet {
  public static let mayonnaise = Sauces(rawValue: 1 << 0)
  public static let mustard = Sauces(rawValue: 1 << 1)
  public static let ketchup = Sauces(rawValue: 1 << 2)
  public static let secret = Sauces(rawValue: 1 << 3)
  
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}

public struct Toppings: OptionSet {
  public static let cheese = Toppings(rawValue: 1 << 0)
  public static let lettuce = Toppings(rawValue: 1 << 1)
  public static let pickles = Toppings(rawValue: 1 << 2)
  public static let tomatoes = Toppings(rawValue: 1 << 3)
  
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}
```
接下来，我们定义一个**builder**
```swift
// MARK: - Builder
public class HamburgerBuilder {
  
  public enum Error: Swift.Error {
    case soldOut
  }
  
  public private(set) var meat: Meat = .beef
  public private(set) var sauces: Sauces = []
  public private(set) var toppings: Toppings = []
  
  private var soldOutMeats: [Meat] = [.kitten]
  
  public func addSauces(_ sauce: Sauces) {
    sauces.insert(sauce)
  }
  
  public func removeSauces(_ sauce: Sauces) {
    sauces.remove(sauce)
  }
  
  public func addToppings(_ topping: Toppings) {
    toppings.insert(topping)
  }
  
  public func removeToppings(_ topping: Toppings) {
    toppings.remove(topping)
  }
  
  public func setMeat(_ meat: Meat) throws {
    guard isAvailable(meat) else { throw Error.soldOut }
    self.meat = meat
  }
  
  public func isAvailable(_ meat: Meat) -> Bool {
    return !soldOutMeats.contains(meat)
  }
  
  public func build() -> Hamburger {
    return Hamburger(meat: meat,
                     sauce: sauces,
                     toppings: toppings)
  }
}
```
接下来，我们添加**director**：
```swift
// MARK: - Director
public class Employee {
  
  public func createCombo1() throws -> Hamburger {
    let builder = HamburgerBuilder()
    try builder.setMeat(.beef)
    builder.addSauces(.secret)
    builder.addToppings([.lettuce, .tomatoes, .pickles])
    return builder.build()
  }
  
  public func createKittenSpecial() throws -> Hamburger {
    let builder = HamburgerBuilder()
    try builder.setMeat(.kitten)
    builder.addSauces(.mustard)
    builder.addToppings([.lettuce, .tomatoes])
    return builder.build()
  }
}
```
接下来测试一下：
```swift
// MARK: - Example
let burgerFlipper = Employee()

if let combo1 = try? burgerFlipper.createCombo1() {
  print("Nom nom " + combo1.description)
}

if let kittenBurger = try?
  burgerFlipper.createKittenSpecial() {
  print("Nom nom nom " + kittenBurger.description)
  
} else {
  print("Sorry, no kitten burgers here... :[")
}

```
可以看到控制台打印：
```swift
Nom nom beef burger
Sorry, no kitten burgers here... :[
```

## What should you be careful about?

构造器模式对需要多次输入创建复杂对象工作起来很好。如果你的 product 没有几个输入或者不能一步步被创建，构造器可能不适合，便利构造器可能更适合。

## Tutorial project 

这里我们继续为以前的 app 增加功能，这节我们将使用构造器模式来添加创建新的`QuestionGroup`功能。实现效果如下：

<img src="https://nightwish.oss-cn-beijing.aliyuncs.com/Builder.gif" width="375px" />

[Demo](https://github.com/zhangdongpo/LearnDesignPattern/tree/Builder)
## 预告
下节我们讲学习 MVVM 设计模式，将会开启一个新的工程。这个工程就到此为止了。
