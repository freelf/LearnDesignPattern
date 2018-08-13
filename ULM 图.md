# ULM 图
在学习设计模式之前，需要先来学习 UML 图。为什么先要学习 UML 图呢？因为后面的设计模式，我们都可以用一幅 UML 图来表示，所以当我们看到一幅 UML 图，就可以明白这是什么设计模式。然后如何用代码去实现它。
## 什么是 UML 图
UML 图包含类、协议、属性、方法和关系。
一个方块表示一个类。下面有一个非常简单的类 Dog：
![Dog](http://ohg2bgicd.bkt.clouddn.com/1534068645.png)
为了表示一个类继承另外一个类，使用一个空心箭头：
![继承](http://ohg2bgicd.bkt.clouddn.com/1534068758.png)
但是我们通常不把空心箭头叫做“inherits from”，而是叫成“is a”，例如：可以用下面的图表示 SheepDog 继承自 Dog 。
![](http://ohg2bgicd.bkt.clouddn.com/15340697063981.jpg)
我们可以这样来理解这个图“SheepDog 是一个 Dog”。
在 UML 中使用一个简单的箭头表示属性，在 UML 中叫做“关联”。
![](http://ohg2bgicd.bkt.clouddn.com/15340698551173.jpg)
通常把属性这个箭头叫做“has a”，比如下图：
![](http://ohg2bgicd.bkt.clouddn.com/15340699550757.jpg)
也可以通过在箭头下面描述一个区间来表示一对多的关系，如下图表示一个 Farmer 有好多 Dog：
![](http://ohg2bgicd.bkt.clouddn.com/15340700470394.jpg)
可以在一个 UML 图中使用多个箭头和方块，下面这个图表示一个 Farmer 有一个 SheepDog，这个  SheepDog 是一个 Dog。
![](http://ohg2bgicd.bkt.clouddn.com/15340702450982.jpg)
在 UML 图中，也可以使用方块表示一个协议，为了区别类，需要在协议名前面加上<<protocol>>。
下图表示一个 PetOwning 协议：
![](http://ohg2bgicd.bkt.clouddn.com/15340703702062.jpg)
使用一个空心箭头和虚线来表示一个类遵守了一个协议：
![](http://ohg2bgicd.bkt.clouddn.com/15340704239696.jpg)
你可以把它理解成“实现”或者“符合”。
使用一个普通箭头和虚线来表示依赖。ULM 有意模糊依赖的概念。因此，无论什么时候使用依赖的关系都应该注释上使用的目的。比如，可以使用依赖箭头表示以下情况：
* 一个 weak 属性或者 delegate；
* 一个作为参数传递给一个方法的对象，并且没有作为属性引用；
* 一种松耦合或者回调，比如：一个从 view 到 controller 的 IBAction

下图表示 Dog 代理到 PetOwning 对象：
![](http://ohg2bgicd.bkt.clouddn.com/15340823104115.jpg)
也可以在 ULM 中表示属性和方法，例如，下图表示 PetOwning 协议有一个 name 属性和 petNeedsFood(_:)方法：
![](http://ohg2bgicd.bkt.clouddn.com/15340824409631.jpg)
如果一个箭头的意义很明确，可以删除一些解释性文字，通常可以删除继承，属性和实现的解释文字。然而，应该保留依赖的文字。因为，他们的意义通常不太明确。
下面是一副表示 Farmer 和 Dog 的完整的 UML 图。Dog 代理到 PetOwning 对象。
![](http://ohg2bgicd.bkt.clouddn.com/15340826726564.jpg)
UML 图是学习设计模式得基础，我们已经简单学了一些基础的 UML 图。下面将去学习一些设计模式。


