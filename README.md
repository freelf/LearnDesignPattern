## 备忘录模式
备忘录模式允许一个对象可以被保存和恢复。包括三个部分。
1. **Originator**: 需要被保存和恢复的对象。
2. **Memento**: 代表保存的状态。
3. ** Caretaker**: 从 originator 请求保存，并且接收一个 memento 作为响应。caretaker 负责保管这些 memento，并在稍后向 originator 提供这些 memento来恢复 originator 的状态。
虽然不是严格要求，iOS通常使用`Encoder`来讲 originator 的状态保存到 memento，并且使用`Decoder`把 memento 恢复到 originator。这使编码和解码的逻辑可以通用。比如：`JSONEncoder`和`JSONDecoder`允许一个对象可以编码为 `JSON` 数据，也可以从`JSON`数据中解码。
UML 图如下：
![](http://ohg2bgicd.bkt.clouddn.com/1538272701.png)

## When should you use it?

当我们想要保存并且以后需要恢复一个对象的状态时需要用到备忘录模式。
比如：我们可以使用这个模式来实现一个游戏系统，originator 就是游戏的状态(比如：等级，健康状态，生命值等等)，memento 就是保存的数据，caretaker 就是游戏系统。
我们可以持续保存一系列数据，表示一个以前的存档。我们也可以用这个模式在 IDEs或者图表软件中实现一些 undo/redo 的特性。

## Playground example

**备忘录模式**是**表现模式**得一种。这是因为这个模式是和保存和恢复表现相关的模式。我们在这个例子中创建一个简单的游戏系统。
首先我们需要定义一个 **originator**，用以下代码来创建：
```swift
import Foundation

// MARK: - Originator
public class Game: Codable {
  
  public class State: Codable {
    public var attemptsRemaining: Int = 3
    public var level: Int = 1
    public var score: Int = 0
  }
  public var state = State()
  
  public func rackUpMassivePoints() {
    state.score += 9002
  }
  
  public func monstersEatPlayer() {
    state.attemptsRemaining -= 1
  }
}
```
这里，你定义了一个`Game`类，它有一个内部`State`保存 game 属性，并且它有操作游戏内动作的方法。我们还要声明`Game`和`State`遵守`Codable`协议。
什么是`Codable`? Apple 在 Swift 4中引进了`Codable`。任何类型都可以遵守`Codable`,用 Apple 的话来说就是：转换本身的外部代表。本质上，就是一个可以存储和恢复其自己的类型。听起来很类似？是的，这的确就是我们想让 originator 拥有的能力。
因为`Game`和`State`的所有属性都遵守了`Codable`协议，编译器会自动生成`Codable`协议所必须实现的方法。`String`,`Int`,`Double`和大多数`Swift`提供的类型都遵守了`Codable`协议。
`Codable`是一个`typealias`,结合了`Encodable`和`Decodable`协议：
```swift
typealias Codable = Decodable & Encodable
```
可编码类型可以通过`Encoder`编码为外部表示。外部表示的实际类型取决于你所使用的`Encoder`。`Foundation`提供了几种默认的编码器，比如`J SONEncoder`是为了把对象转化为 JSON 数据。
可以通过`Decoder`把外部表现转化为可解码类型。`Foundation`也提供了解码器。比如`JSONDecoder`可以把 JSON 数据转化为对象。
接下来我们需要一个**memento**，在上面的代码下面添加如下代码：
```swift
// MARK: - Memento
typealias GameMemento = Data
```
理论上，我们一点也不需要这样声明。这里就是说明你`GameMemento`实际上是`Data`。这将是`Encoder`存储的数据，并且是`Decoder`恢复的元数据。
接下来，我们需要添加一个**caretaker**,添加如下代码：
```swift
// MARK: - CareTaker
public class GameSystem {
  
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  private let userDefaults = UserDefaults.standard
  
  public func save(_ game: Game, title: String) throws {
    let data = try encoder.encode(game)
    userDefaults.set(data, forKey: title)
  }
  
  public func load(title: String) throws -> Game {
    guard let data = userDefaults.data(forKey: title),
      let game = try? decoder.decode(Game.self, from: data)
      else {
        throw Error.gameNotFound
    }
    return game
  }
  
  public enum Error: String, Swift.Error {
    case gameNotFound
  }
}
```
我们先来模拟一下游戏过程：
```swift
// MARK: - Example
var game = Game()
game.monstersEatPlayer()
game.rackUpMassivePoints()
```
然后存储一下：
```swift
// Save Game
let gameSystem = GameSystem()
try gameSystem.save(game, title: "Best Game Ever")
```
然后读取一下记录：
```swift
// Load Game
game = try! gameSystem.load(title: "Best Game Ever")
print("Loaded Game Score: \(game.state.score)")
```
Emmm,是不是很不错！

## What should you be careful about?

当添加和移除`Codable`属性时需要当心，编码和解码都是可以抛出错误的。如果我们使用`try!`强制解包，并且丢失了必要的数据，app 会 crash。
为了规避这种问题，除非你确定操作可以成功，应该尽量避免使用`try!`。当改变模型时也需要提前规划。比如：我们可以给模型添加版本号或者使用带版本号的数据库。然而我们需要考虑入魂儿处理版本升级。我们可以选择当我们有一个新的版本时删掉旧的数据，或者创建一个升级路径把旧的数据转化为新的数据，或者使用这两种方法的结合。

## Tutorial project

下面我们继续给我们以前的 app 增加功能。我们将使用备忘录模式添加一个 app 重要的特性：保存`QuestionGroup`分数的能力。
实现效果：

<img src="http://ohg2bgicd.bkt.clouddn.com/2018-10-03%2010.57.41.gif" width="375px" />

再次运行会在控制台打印：
```swift
Hiragana: correctCount 5, incorrectCount 6
Katakana: correctCount 5, incorrectCount 5
Basic Phrases: correctCount 0, incorrectCount 0
Numbers: correctCount 0, incorrectCount 0
```
[Demo](https://github.com/zhangdongpo/LearnDesignPattern/tree/Memento)

## 预告
下节我们将学习观察者模式。
