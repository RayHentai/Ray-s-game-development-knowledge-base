# 09 多Lua脚本执行

**所属模块**：[[00 Lua 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心要点

**1. 全局变量和局部变量**
- 局部变量就是前面用 `local` 修饰 只能在这个脚本文件/语句块中使用

**2. 多脚本执行**
- require("脚本名")
- 脚本的最后可以 `return` 一个外部希望获取的内容，一般情况是一个局部变量

**3. 脚本卸载**
- `package.loaded["脚本名"]`返回值 boolture true为加载 nil就是没有加载过
- `package.loaded["脚本名"] = nil` 卸载脚本

**4. `_G`**
- 是一个总表(table) ，申明的所有全局的变量都存储在其中
- 加了local的变量不会存到大G表中
- 所有声明的全局变量都以键值对的形式存储在_G中
- 给大G添加的全局变量对可以直接使用


---

## 代码演示

```lua title:Test
print("Test")
local a = 1
return a
```

```lua
--多脚本执行
--全局变量和本地变量
--全局变量
a = 1
b = "123"

for i=1,2 do
	c = "循环语句块中声明的全局变量"
end

func = function()
	d = "函数语句块中声明的全局变量"
end
func()
print(c) --全局变量
print(d) --全局变量

--本地变量 关键字 local
--只会在这个脚本文件内起作用
for i=1,2 do
	local c1 = "本地变量"
end

func = function()
	local d1 = "本地变量"
end

print(c1) --nil
print(d1) --nil

--多脚本执行
--关键字 require("脚本名") 或者 require('脚本名')
--如果是require加载执行的脚本 加载一次后不会再执行
require("Test")
--脚本卸载
print(package.loaded["Test"]) --nil 该脚本是否被执行 返回值boolean
package.loaded["Test"] = nil --卸载已经执行过的脚本名
local a = require("Test") --require一个脚本时 可以在脚本最后返回一个外部希望获取的内容
print(a) --1

--大G表
-- _G 是一个总表table 将申明的所有变量都存储在其中
-- 本地变量不会存到大G表中
for k,v in pairs(_G) do
	print(k, v)
end
```


---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

---

## API速查


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
