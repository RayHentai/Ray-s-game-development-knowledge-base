# 22 Text Mesh Pro 工具类

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## TMP_TextEventHandler类

**它是一个TMP的辅助组件，用于辅助处理获取鼠标悬停在TMP文本上的时候的一些事件**

主要作用是监听并响应 TMP 文本中的特定区域或标签（如链接 `<link> `和特定字符）的点击和鼠标悬停事件

**这个类可以让你对文本的某些部分进行交互式操作，适用于创建如超链接、工具提示、弹出信息等效果**

---

### 使用

在任一TMP控件下添加该组件
该组件上包含了各种的响应事件，提供给外部绑定相关的事件

链接：onLinkSelection - 当用户悬停超链接时触发
字符：onCharacterSelection - 当用户悬停某个字符时触发
单词：onWordSelection - 当用户悬停某个单词时触发
行：onLineSelection - 当用户悬停某一行文本时触发
精灵图片：onSpriteSelection - 当用户悬停某一精灵图片时触发

```csharp
TMP_TextEventHandler tmpHandler = this.GetComponent<TMP_TextEventHandler>();
tmpHandler.onLinkSelection.AddListener(MyLinkSelectionHandler);
tmpHandler.onWordSelection.AddListener(MyWordSelectionHandler);
tmpHandler.onLineSelection.AddListener(MyLineSelectionHandler);
tmpHandler.onSpriteSelection.AddListener(MySpriteSelectionHandler);
tmpHandler.onCharacterSelection.AddListener(MyCharSelectionHandler);

//int类型的参数通常是传入当前这个类型的文本在当前整个文本中的索引值
//提供了链接，字符，精灵图片，单词，行五个类型文本的鼠标悬停事件监听

public void MyLinkSelectionHandler(string linkInfo, string linkText, int index)
{
    print("**********超链接*************");
    print(linkInfo);
    print(linkText);
    print(index);
}
public void MyCharSelectionHandler(char charInfo, int i)
{
    print("**********字符*************");
    print(charInfo);
    print(i);
}
public void MySpriteSelectionHandler(char spirteInfo, int i)
{
    print("**********精灵图片*************");
    print(spirteInfo);
    print(i);
}
public void MyWordSelectionHandler(string word, int i1, int i2)
{
    print("**********单词*************");
    print(word);
    print(i1);
    print(i2);
}
public void MyLineSelectionHandler(string lineInfo, int i1, int i2)
{
    print("**********行*************");
    print(lineInfo);
    print(i1);
    print(i2);
}
```

---

## TMP_TextUtilities类

**TMP_TextUtilities是TMP中提供的一个实用工具类**
通常提供进行点击事件的相关处理的方法
当我们需要通过点击文本来获取其对应信息的时候，可以使用该工具类中的方法

---

### 常用API

**注意：**
- 下面的方法返回的都是索引值，如果没有获取到信息，返回的索引为-1
- 利用获取到的索引可以在TMP文本控件中的textInfo属性中的
	- linkInfo
	- wordInfo
	- characterInfo
	- lineInfo
	- 来获取信息

```csharp
//1 获取给定位置文本中的具体信息
//获取链接索引
int FindIntersectingLink(TMP_Text text, Vector3 position, Camera camera)
//获取单词索引
int FindIntersectingWord(TMP_Text text, Vector3 position, Camera camera)
//获取单字符索引
int FindIntersectingCharacter(TMP_Text text, Vector3 position, Camera camera)
//获取行索引
int FindIntersectingLine(TMP_Text text, Vector3 position, Camera camera)

//2 获取离给定位置最新的文本中的具体信息
//获取链接索引
int FindNearestLink(TMP_Text text, Vector3 position, Camera camera)
//获取单词索引
int FindNearestWord(TMP_Text text, Vector3 position, Camera camera)
//获取单字符索引
int FindNearestCharacterOnLine (TMP_Text text, Vector3 position, Camera camera)
//获取行索引
int FindNearestLine(TMP_Text text, Vector3 position, Camera camera)
```

**更多API：**
https://docs.unity3d.com/Packages/com.unity.textmeshpro@4.0/api/TMPro.TMP_TextUtilities.html

---

### 使用

**注意：**
- 这个类需要在文本被点击的时候使用
- 因此需要给这个文本控件添加一个继承了IPointerClickHandler的接口的脚本
- 在这个接口的方法中去使用该工具类

```csharp
public void OnPointerClick(PointerEventData eventData)
{
    print("123");
    int linkIndex = TMP_TextUtilities.FindIntersectingLink(tmpUIText, eventData.position, null);
    //如果不为-1 就证明点击到了一个超链接信息
    if(linkIndex != -1)
    {
        //这是得到超链接显示的文本信息
        print(tmpUIText.textInfo.linkInfo[linkIndex].GetLinkText());
        //这是得到富文本标签<link=?>中的?具体的地址信息
        print(tmpUIText.textInfo.linkInfo[linkIndex].GetLinkID());
    }
    //通过获取链接文本的索引值，在textInfo的linkInfo数组中找到对应的链接，并用的GetLinkText()以及GetLinkID()来获取对应的链接文本和ID
    
    int charIndex = TMP_TextUtilities.FindIntersectingCharacter(tmpUIText, eventData.position, null, true);
    if(charIndex != -1)
    {
        print(tmpUIText.textInfo.characterInfo[charIndex].character);
    }
    //通过获取字符文本的索引值，在textInfo的characterInfo数组中找到相应的链接，并用.character变量直接获取字符值
}
```

---

## 其他工具类

在使用TMP进行开发时
除了经常会用到的TMP_TextEventHandler 和 TMP_TextUtilities 类以外，TMP还提供了很多工具类
**比如：**
- TMP_Math：提供一些基础的数学计算
- TMP_FontAssetUtilities：提供字体资源的操作和查询等方法
- TMP_TextParsingUtilities：提供解析文本内容的工具
等等

**更多API的使用见官方文档：**
[https://docs.unity3d.com/Packages/com.unity.textmeshpro@4.0/api/TMPro.html](https://docs.unity3d.com/Packages/com.unity.textmeshpro@4.0/api/TMPro.html "https://docs.unity3d.com/Packages/com.unity.textmeshpro@4.0/api/TMPro.html")

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 场景一：
- 场景二：
- 反例（不该用的时候）：

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

---

## 我的踩坑记录

> ⭐ 这里最有价值！把自己犯过的错误写下来，写上日期

- （日期）踩坑描述 → 解决方法

---

## 延伸阅读

> 这个知识点延伸出去的方向，学完后可以探索

- [[]]相关知识点
- 

---

*最后更新：*
