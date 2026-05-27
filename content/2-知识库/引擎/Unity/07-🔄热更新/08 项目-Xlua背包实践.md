# 08 项目-Xlua背包实践

**所属阶段**：[[00 热更新 总览]]
**综合知识点**：[[]] | [[]] | [[]]
**完成状态**：🔄 进行中 / ✅ 已完成
**查阅次数**：0

---

## 需求分析

1. 巩固AB包+Lua语法+xLua解决方案的3部分知识
2. 学会Unity+Lua+VSCode环境调试
3. 学会Unity结合xLua进行游戏功能开发
4. 学会制作Lua文件迁徙小工具

---

## 项目目标

1. 巩固AB包+Lua语法+xLua解决方案的3部分知识
2. 学会Unity+Lua+VSCode环境调试
3. 学会Unity结合xLua进行游戏功能开发
4. 学会制作Lua文件迁徙小工具

---

## 功能拆解

> 把整个项目拆成独立的功能模块，每个功能是一个可以单独实现的单元

- [ ] 功能一：
- [ ] 功能二：
- [ ] 功能三：
- [ ] 功能四：

---

## 架构设计

> 框架先行：先列出来怎么拆分，再填实现细节

```
项目结构：
├── 场景管理
│   ├── 开始场景
│   ├── 游戏场景
│   └── 结束场景
├── 核心逻辑
│   ├── 
│   └── 
└── 工具/辅助
    ├── 
    └── 
```

---

## UML类图

---
## 核心设计思路 / 理论分析

> 用伪代码或文字描述最关键的逻辑，写代码之前先想清楚

**关键逻辑一**：

```
// 伪代码描述思路
```

**关键逻辑二**：

```
// 伪代码描述思路
```

---

## 项目流程

---

### 准备工作

**Lua的开发环境搭建**

```csharp title:Csharp的主入口
public class Main : MonoBehaviour
{
    void Start()
    {
        LuaMgr.Instance.Init();
        LuaMgr.Instance.DoLuaFile("Main");
    }
}
```

```lua title:Lua的主入口
print("准备就绪")
require("InitClass")
```

**常用类别名准备**

```lua
--对这个文件不检查未定义全局变量
---@diagnostic disable: undefined-global
--用于初始化常用别名
--面向对象相关
require("Object")

--字符串拆分
require("SplitTools")

--Json解析
Json = require("JsonUtility")

--Unity相关
GameObject = CS.UnityEngine.GameObject
Resources = CS.UnityEngine.Resources
Transform = CS.UnityEngine.Transform
Vector2 = CS.UnityEngine.Vector2
Vector3 = CS.UnityEngine.Vecror3
--图集对象
SpriteAtlas = CS.UntyEngine.U2D.SpriteAtlas

--UI相关
UI = CS.UnityEngine.UI
Image = UI.Image
Text = UI.Text
TextMeshProUGUI = CS.TMPro.TextMeshProUGUI
Button = UI.Button
Toggle = UI.Toggle
ScrollRect = UI.ScrollRect

--自定义类
--直接得到单例对象
ABResMgr = CS.ABResMgr.Instance
```

---

### 拼面板

![[Xlua项目 拼面板 控件结构1.png|143]]
![[Xlua项目 拼面板1.png|147]]

![[Xlua项目 拼面板 控件结构2.png|128]]
![[Xlua项目 拼面板2.png|228]]

![[Xlua项目 拼面板 控件结构3.png]]
![[Xlua项目 拼面板3.png|124]]

---

### 数据准备

```lua title:Main
print("准备就绪")
--初始化准备好的类别名

--初始化数据
require("InitClass")
--初始化准备好的Json数据表
require("ItemData")
--初始化玩家信息
require("PlayerData")
PlayerData:Init()

--逻辑
```

**1. 准备配置表，并打AB包** 

```json
[
{"id":1,"name":"弓箭","icon":"Icon_2","type":1,"tips":"威力巨大的武器"},
{"id":2,"name":"手套","icon":"Icon_1","type":1,"tips":"增强免疫力"},
{"id":3,"name":"蓝药","icon":"Icon_3","type":2,"tips":"加魔法的药水"},
{"id":4,"name":"红药","icon":"Icon_4","type":2,"tips":"加血量的药水"},
{"id":5,"name":"红宝石","icon":"Icon_5","type":3,"tips":"合成高级道具的必备之物"},
{"id":6,"name":"蓝宝石","icon":"Icon_6","type":3,"tips":"合成高级道具的必备之物"}
]
```

**2. 准备图集，并打AB包**

![[Xlua项目 数据准备 准备图集.png|248]]

**3. 配置表读取到Lua中**

```lua
--将Json中的数据读取到Lua的表中进行存储
--利用AB包资源管理器加载Json配置表
local txt = ""
ABResMgr:LoadTextAsset("json", "ItemData", function(obj)
    txt = obj:ToString()
end, true)
--获取文本信息 并进行Json解析
local itemList = Json.decode(txt)
--解析出来是一个类似数组的结构
--print(itemList[1].id .. itemList[1].name)
--但是解析出来的表不方便用ID去获取内容

--所以把它转换成一个以ID为key的新table 类似于字典
--而且这张新表是全局的 在任何地方都能使用
ItemData = {}
for _, value in pairs(itemList) do
    ItemData[value.id] = value
end
```

**4. 玩家数据准备**

```lua
--玩家数据表
--目前只做背包功能 只需要道具信息
PlayerData = {}
PlayerData.equips = {} --装备列表
PlayerData.items = {} --道具列表
PlayerData.gems = {} --宝石列表
  
--初始化玩家数据的方法
--后续改这里的数据来源即可
function PlayerData:Init()
    --因为没有服务器数据 写死道具数据作为玩家信息
    table.insert(self.equips,{id = 1, num = 1})
    table.insert(self.equips,{id = 2, num = 1})
    table.insert(self.items,{id = 3, num = 50})
    table.insert(self.items,{id = 4, num = 20})
    table.insert(self.gems,{id = 5, num = 99})
    table.insert(self.gems,{id = 6, num = 88})
end
```

---

### 面板逻辑

---

#### MainPanel

```lua
print("准备就绪")

--初始化准备好的类别名
require("InitClass")

--初始化数据
--初始化准备好的Json数据表
require("ItemData")
--初始化玩家信息
require("PlayerData")
PlayerData:Init()

--逻辑
require("MainPanel")
MainPanel:ShowPanel()
```

```lua
--主面板逻辑
--只要是一个新的对象（面板） 就新建一张表
MainPanel = {}

--下面可以不写 因为Lua中不存在声明变量的概念 可以直接在函数中使用字段
--但是为了其他人能更清晰的知道这个面板有哪些字段 还是在这里写一下
MainPanel.panelObj = nil
MainPanel.btnRole = nil
MainPanel.btnSkill = nil
  
--初始化函数
--需要实例化对象 设置父对象 处理按钮事件监听
function MainPanel:Init()
    --面板对象没有实例化时才去实例化
    if self.panelObj == nil then
        --1 实例化面板 并设置父对象
        ABResMgr:LoadGameObject("ui", "MainPanel", function(obj)
            self.panelObj = GameObject.Instantiate(obj, Canvas)
        end, true)
        
        --2 获取按钮控件 找到面板子对象 再找到子对象挂载的按钮脚本
        self.btnRole = self.panelObj.transform:Find("BtnRole"):GetComponent(typeof(Button))
        self.btnSkill = self.panelObj.transform:Find("BtnSkill"):GetComponent(typeof(Button))
        
        --3 处理按钮事件监听
        --如果直接.传入自己的函数 那么在函数内部 没有办法用self获取面板的信息
        --self.btnRole.onClick:AddListener(self.BtnRoleClick)
        self.btnRole.onClick:AddListener(function()
            --用匿名函数封装事件
            self:BtnRoleClick()
        end)
    end
end

--显示面板
function MainPanel:ShowPanel()
    self:Init()
    self.panelObj:SetActive(true)
end

--隐藏面板
function MainPanel:HidePanel()
    self.panelObj:SetActive(false)
end

--按钮点击事件
function MainPanel:BtnRoleClick()
    print("点击了角色按钮")
end
```

---

#### BagPanel

```lua
--新建空表
BagPanel = {}

--面板信息 字段
BagPanel.panelObj = nil
BagPanel.btnClose = nil
BagPanel.togEquip = nil
BagPanel.togItem = nil
BagPanel.togGem = nil
BagPanel.svBag = nil
BagPanel.Content = nil

--初始化
function BagPanel:Init()
    if self.panelObj == nil then
        --1 实例化面板 绑定父对象
        ABResMgr:LoadGameObject("ui", "BagPanel", function(obj)
            self.panelObj = GameObject.Instantiate(obj, Canvas)
        end, true)

        --2 找控件
        local transform = self.panelObj.transform
        self.btnClose = transform:Find("BtnClose"):GetComponent(typeof(Button))
        local group = transform:Find("Group").transform
        self.togEquip = group:Find("TogEquip"):GetComponent(typeof(Toggle))
        self.togItem = group:Find("TogItem"):GetComponent(typeof(Toggle))
        self.togGem = group:Find("TogGem"):GetComponent(typeof(Toggle))
        self.svBag = transform:Find("SvBag"):GetComponent(typeof(ScrollRect))
        self.Content = self.svBag.transform:Find("Viewport"):Find("Content")

        --3 事件监听
        self.btnClose.onClick:AddListener(function()
            self:HideMe()
        end)
        self.togEquip.onValueChanged:AddListener(function(value)
            --只有改变之后的值为True时才会执行逻辑
            if value == true then
                self:ChangeType(1)
            end
        end)
        self.togItem.onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(2)
            end
        end)
        self.togGem.onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(3)
            end
        end)
    end
end

--显示面板
function BagPanel:ShowMe()
    self:Init()
    self.panelObj:SetActive(true)
end

--隐藏面板
function BagPanel:HideMe()
    self.panelObj:SetActive(false)
end

--页签逻辑处理
--自定义规则 1 装备 2 道具 3宝石
function BagPanel:ChangeType(type)
    print("当前类型为" .. type)
end
```

---

#### ItemBag

**逻辑直接写在BagPanel中**

```lua
--用来记录当前页签的格子列表
BagPanel.items = {}

--记录当前的页签类型 避免重复刷新
BagPanel.nowItemType = -1

--显示面板
function BagPanel:ShowMe()
    self:Init()
    self.panelObj:SetActive(true)
    if self.nowItemType == -1 then
        self:ChangeType(1)
    end
    self:ChangeType(self.nowItemType)
end

--页签逻辑处理
--自定义规则 1 装备 2 道具 3宝石
function BagPanel:ChangeType(type)
    --防止重复删除生成对象 节约性能
    if self.nowItemType == type then
        return
    end
    
    --更新之前 先删除老格子
    for i = 1, #self.items do
        GameObject.Destroy(self.items[i].obj)
    end
    
    --清空格子列表
    self.items = {}
    
    --再根据当前选择的类型 创建新的格子
    --根据传入的type 决定当前创建哪个页签中的格子
    local nowItem = nil
    if type == 1 then
        nowItem = PlayerData.equips
    elseif type == 2 then
        nowItem = PlayerData.items
    else
        nowItem = PlayerData.gems
    end
    
    --创建格子
    for i = 1, #nowItem do
        --这张新表就相当于C#中格子对象的类 记录格子信息
        local grid = {}
        --实例化对象 和设置父对象
        ABResMgr:LoadGameObject("ui", "ItemGrid", function(obj)
            grid.obj = GameObject.Instantiate(obj, self.Content, false)
        end, true)
        local transform = grid.obj.transform
        
        --设置位置
        transform.localPosition = Vector3((i - 1) % 4 * 110, math.floor((i - 1) / 4) * 110, 0)
        --设置图标
        grid.itemIcon = transform:Find("ItemIcon"):GetComponent(typeof(Image))
        --根据ID拿到格子信息
        local data = ItemData[nowItem[i].id]
        --拆分图集名字和图片名字
        local strs = string.split(data.icon, "_")
        --加载图集对象
        ABResMgr:LoadSpriteAtlas("ui", strs[1], function(obj)
            local spriteAtlas = obj
            grid.itemIcon.sprite = spriteAtlas:GetSprite(strs[2])
        end, true)

        --设置下标数字
        grid.txtNum = transform:Find("TxtNum"):GetComponent(typeof(Text))
        grid.txtNum.text = nowItem[i].num
        --把格子对象加入到当前页签的格子列表中
        table.insert(self.items, grid)
    end
end
```

---

### 面向对象优化

---

#### 格子对象

```lua title:ItemGrid
--生成一个table 继承Object 主要目的是使用它里面的subClass 和new方法 来创建类和对象
Object:subClass("ItemGrid")

--成员变量 
ItemGrid.obj = nil
ItemGrid.itemIcon = nil
ItemGrid.txtNum = nil

--实例化格子对象
function ItemGrid:Init(father, poxX, posY)
    --实例化对象 和设置父对象
        ABResMgr:LoadGameObject("ui", "ItemGrid", function(obj)
            self.obj = GameObject.Instantiate(obj, father, false)
        end, true)
        local transform = self.obj.transform
        --设置位置
        transform.localPosition = Vector3(poxX, posY, 0)
        --关联控件
        self.itemIcon = transform:Find("ItemIcon"):GetComponent(typeof(Image))
        self.txtNum = transform:Find("TxtNum"):GetComponent(typeof(Text))
end

--初始化格子信息
function ItemGrid:InitData(data)
    --根据ID拿到格子信息
        local itemData = ItemData[data.id]
    --拆分图集名字和图片名字
    local strs = string.split(itemData.icon, "_")
    --加载图集对象
    ABResMgr:LoadSpriteAtlas("ui", strs[1], function(obj)
        self.itemIcon.sprite = obj:GetSprite(strs[2])
        end, true)
    self.txtNum.text = data.num
end

--自己的逻辑
--移除格子对象
function ItemGrid:Destroy()
    GameObject.Destroy(self.obj)
end

```

```lua title:BagPanel
--更新之前 先删除老格子
for i = 1, #self.items do
	self.items[i]:Destroy()
end

--创建格子
for i = 1, #nowItem do
	--创建一个格子对象
	local grid = ItemGrid:new()
	--实例化对象
	grid:Init(self.Content, (i - 1) % 4 * 110, math.floor((i - 1) / 4) * 110)
	--初始化对象信息
	grid:InitData(nowItem[i])
	--存入当前页签的格子列表中
	table.insert(self.items, grid)
end
```

---

#### 面板基类

```lua title:BasePanel
--利用面向对象
Object:subClass("BasePanel")

--成员变量
BasePanel.panelObj = nil
--控件就用一个表模拟字典存储
BasePanel.controls = {}

--是否已经监听事件的标识
BasePanel.isInitEvent = false

--面板名字 用于加载面板预制体
BasePanel.panelName = ""

--初始化的方法
function BasePanel:Init()
    if self.panelObj == nil then
        --1 实例化面板 并设置父对象
        ABResMgr:LoadGameObject("ui", self.panelName, function(obj)
            self.panelObj = GameObject.Instantiate(obj, Canvas)
        end, true)
        --2 找到所有UI控件并存起来
        --因为UIbehaviour是所有UI控件的父类 所以可以通过这个类型来获取所有UI控件
        local allControls = self.panelObj:GetComponentsInChildren(typeof(UIBehaviour))
        --为了避免各自无用的控件 定一个规则 拼面板时 控件按一定的规范命名
        --比如 Button btn+名字
        --遍历获得的所有控件
        for i = 0, allControls.Length - 1 do
            local controlName = allControls[i].name
            --只有找到了包含自定义关键字的控件才存储起来
            if string.find(controlName, "btn") ~= nil or
               string.find(controlName, "txt") ~= nil or
               string.find(controlName, "img") ~= nil or
               string.find(controlName, "sv") ~= nil or
               string.find(controlName, "tog") ~= nil then
                --为了在得到控件时 能指定得到的控件类型 需要存储控件类型
               local typeName = allControls[i]:GetType().Name
               --如果存储过这个控件 直接添加新键值对就行
               --最终存储形式
               --{ btnRole = { [Image] = 控件, [Button] = 控件 } }
                if self.controls[controlName] ~= nil then
                    --通过自定义索引的形式 添加一个新的“成员变量”
                    self.controls[controlName][typeName] = allControls[i]
                else --如果没有存储过这个控件 创建一个新表 添加键值对
                    self.controls[controlName] = {[typeName] = allControls[i]}
                end
            end
        end
    end
end

--得到控件的方法
function BasePanel:GetControl(name, type)
    if self.controls[name] ~= nil then
        local someNameControls = self.controls[name]
        if someNameControls[type] ~= nil then
            return someNameControls[type]
        end
    end
    return nil
end

--显示面板的方法
function BasePanel:ShowMe()
    self:Init()
    self.panelObj:SetActive(true)
end

--隐藏面板的方法
function BasePanel:HideMe()
    self.panelObj:SetActive(false) 
end
```

```lua title:MainPanel
--主面板逻辑
BasePanel:subClass("MainPanel")

--为面板名字段赋值
MainPanel.panelName = "MainPanel"

--初始化函数
--需要实例化对象 设置父对象 处理按钮事件监听
function MainPanel:Init()
    --1 初始化 实例化对象 并且设置父对象
    self.base.Init(self)
    --只有第一次打开面板才需要监听事件
    if self.isInitEvent == false then 
        --2 获取指定控件 并 处理按钮事件监听
        --如果直接.传入自己的函数 那么在函数内部 没有办法用self获取面板的信息
        --self.btnRole.onClick:AddListener(self.BtnRoleClick)
        self:GetControl("btnRole", "Button").onClick:AddListener(function()
            --用匿名函数封装事件
            self:BtnRoleClick()
        end)
        self.isInitEvent = true
    end
end

--按钮点击事件
function MainPanel:BtnRoleClick()
    BagPanel:ShowMe()
end
```

```lua title:BagPanel
--新建空表
BasePanel:subClass("BagPanel")
--面板信息 字段
BagPanel.panelName = "BagPanel"

BagPanel.Content = nil
--用来记录当前页签的格子列表
BagPanel.items = {}
--记录当前的页签类型
BagPanel.nowItemType = -1

--初始化
function BagPanel:Init()
    --1 实例化对象 设置父对象 得到所有控件
    self.base.Init(self)
    if self.isInitEvent == false then
        --2 获取指定控件 并进行 事件监听
        BagPanel.Content = self:GetControl("svBag", "ScrollRect").transform:Find("Viewport"):Find("Content")
        self:GetControl("btnClose", "Button").onClick:AddListener(function()
            self:HideMe()
        end)
        self:GetControl("togEquip", "Toggle").onValueChanged:AddListener(function(value)
            --只有改变之后的值为True时才会执行逻辑
            if value == true then
                self:ChangeType(1)
            end
        end)
        self:GetControl("togItem", "Toggle").onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(2)
            end
        end)
        self:GetControl("togGem", "Toggle").onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(3)
            end
        end)
        self.isInitEvent = true
    end
end

--显示面板
function BagPanel:ShowMe()
    self.base.ShowMe(self)
    if self.nowItemType == -1 then
        self:ChangeType(1)
    end
    self:ChangeType(self.nowItemType)
    
end

--页签逻辑处理
--自定义规则 1 装备 2 道具 3宝石
function BagPanel:ChangeType(type)
    --防止重复删除生成对象 节约性能
    if self.nowItemType == type then
        return
    end
    --更新之前 先删除老格子
    for i = 1, #self.items do
        self.items[i]:Destroy()
    end
    --清空格子列表
    self.items = {}

    --再根据当前选择的类型 创建新的格子
    --根据传入的type 决定当前创建哪个页签中的格子
    local nowItem = nil
    if type == 1 then
        nowItem = PlayerData.equips
    elseif type == 2 then
        nowItem = PlayerData.items
    else
        nowItem = PlayerData.gems
    end
    --创建格子
    for i = 1, #nowItem do
        --创建一个格子对象
        local grid = ItemGrid:new()
        --实例化对象
        grid:Init(self.Content, (i - 1) % 4 * 110, math.floor((i - 1) / 4) * 110)
        --初始化对象信息
        grid:InitData(nowItem[i])
        --存入当前页签的格子列表中
        table.insert(self.items, grid)
    end
end
```

---

### Lua迁移工具

**注意：**
- 打AB包时会和Xlua有一定冲突会报错
- 所以打包时先清xlua代码再打包
- 打包完毕过后再重新生成xlua代码

```csharp
public class LuaCopyEditor : Editor
{
    [MenuItem("XLua/自动生成带txt后缀的Lua文件")]
    public static void CopyLuaToTxt()
    {
        //找到所有Lua文件
        string path = Application.dataPath + "/Lua/";
        if (!Directory.Exists(path))
        {
            Debug.LogError("Lua文件夹不存在！");
            return;
        }
        string[] luaFilesName = Directory.GetFiles(path,"*.lua");//*代表匹配后缀 排除meta文件
        //把Lua文件拷贝到新的文件夹中
        //1 定义一个新路径
        string newLuaPath = Application.dataPath + "/LuaTxt/";
        if (!Directory.Exists(newLuaPath)) //判断是否有该文件夹 没有则创建
            Directory.CreateDirectory(newLuaPath);
        else //删除旧文件
        {
            string[] oldFiles = Directory.GetFiles(newLuaPath, "*.txt");
            for (int i = 0; i < oldFiles.Length; i++)
                File.Delete(oldFiles[i]);
        }
        List<string> newFileNames = new List<string>();//存储新的文件路径
        string fileName;
        for (int i = 0; i < luaFilesName.Length; i++)
        {
            //得到新的文件名 只需要 路径中最后一个/后面的部分 然后加上.txt后缀
            fileName = newLuaPath + luaFilesName[i].Substring(luaFilesName[i].LastIndexOf("/") + 1) + ".txt";
            newFileNames.Add(fileName);
            File.Copy(luaFilesName[i], fileName);
        }
        AssetDatabase.Refresh(); //刷新
        //2 修改包名
        for (int i = 0; i < newFileNames.Count; i++)
        {
            //Unity API
            //改API传入的路径必须是相对Assets文件夹的Assets/.../...
            AssetImporter importer = AssetImporter.GetAtPath(newFileNames[i].Substring(newFileNames[i].IndexOf("Assets")));
            if (importer != null)
                importer.assetBundleName = "lua";
        }
    }
}
```

---

## 关键代码片段

> 只记重要的、有代表性的代码，加注释说明为什么这样写

### 场景切换

```csharp
// 说明：为什么用这种方式切换场景

```

### 核心逻辑

```csharp
// 说明：

```

### 数据处理

```csharp
// 说明：

```

---

## 遇到的问题 & 解决方案

**1. ABResLoad 只提供了一个泛型方法，但是Lua不支持直接调用C#中的泛型方法**

```csharp title:ABResMgr
public void LoadResAsync<T>(string abName, string resName, UnityAction<T> callback, bool isSync = false) where T : Object
{
	#if UNITY_EDITOR
	if (isDebug) 
	{
		T res = EditorResMgr.Instance.LoadEditorRes<T>($"{abName}/{resName}");
		callback?.Invoke(res as T);
	}
	else 
	{
		ABMgr.Instance.LoadResAsync<T>(abName, resName, callback, isSync);
	}
	#else
		ABMgr.Instance.LoadResAsync<T>(abName, resName, callback, isSync);
	#endif
}
```

**解决方法一：** 添加一个Type重载

**解决方法二：** 重新封装一个针对需要加载的资源类型的方法
注意事项：加载字符串一定要用同步加载，不然执行打印字符串的时候加再并未完成，只会返回空字符串

```csharp
public void LoadTextAsset(string abName, string resName, UnityAction<TextAsset> callback, bool isSync = false)
{
	LoadResAsync(abName, resName, callback, isSync);
}

public void LoadGameObject(string abName, string resName, UnityAction<GameObject> callback, bool isSync = false)
{
	LoadResAsync(abName, resName, callback, isSync);
}

public void LoadSpriteAtlas(string abName, string resName, UnityAction<SpriteAtlas> callback, bool isSync = false)
{
	LoadResAsync(abName, resName, callback, isSync);
}
```

```lua
--加载Json配置表
local txt = ""
ABResMgr:LoadTextAsset("json","ItemData",function(obj)
    txt = obj:ToString()
end,true)
print(txt)
```

---

## Bug 记录

| 发现时间 | Bug 描述 | 状态 | 解决方法 |
|----------|----------|------|----------|
| | | 🔴 未修复 | |
| | | ✅ 已修复 | |

---

## 代码复用记录

> 哪些代码是从之前项目复用/改进来的，哪些是新写的

- 复用自：
- 改进了：
- 新增了：

---

## 完成后的感悟

> 做这个项目学到了什么新东西？有没有对某个知识点有了新的理解？

**新学到的东西**：

**对某个知识点的新理解**：

**下次可以改进的地方**：

---

## 扩展想法

> 如果要继续优化这个项目，可以做哪些功能？

- 
- 

---

**完成时间**：
**耗时**：
