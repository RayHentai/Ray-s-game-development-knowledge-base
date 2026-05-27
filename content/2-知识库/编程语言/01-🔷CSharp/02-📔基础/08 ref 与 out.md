# 🔗 08 ref 与 out

**所属模块**：[[00 CSharp 基础阶段总览]]
**关联**：[[06 值类型与引用类型]] | [[07 函数基础]]
**查阅次数**：0

---

## 核心理解

> 函数参数默认是值传递（拷贝一份），函数内改了不影响外面。
> `ref` 和 `out` 让函数内的修改能影响外部变量，相当于"传地址"。

- 在函数内部改变外部传入的内容，里面变了，外面也跟着变

---

## ref

```csharp
// 声明时在参数前加 ref
static void AddOne(ref int x)
{
    x += 1;
}

int num = 5;
AddOne(ref num);   // 调用时也要加 ref
Console.WriteLine(num);  // 6，外部变量被修改了
```

**使用规则**：
- 传入的变量**必须先初始化**（赋值）
- 函数内部可以修改也可以不修改

---

## out

```csharp
// 声明时在参数前加 out
static void GetInfo(out string name, out int age)
{
    name = "张三";  // 函数内部必须赋值
    age  = 18;
}

string n;
int a;
GetInfo(out n, out a);  // 调用时也要加 out
Console.WriteLine(n + " " + a);  // 张三 18
```

**使用规则**：
- 传入的变量**不需要先初始化**
- 函数内部**必须对 out 参数赋值**

---

## ref vs out 区别

|            | ref    | out           |
| ---------- | ------ | ------------- |
| 传入前是否需要初始化 | ✅ 必须   | ❌ 不需要         |
| 函数内是否必须赋值  | ❌ 不强制  | ✅ 必须          |
| 典型用途       | 修改已有的值 | 从函数中"输出"多个返回值 |

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 希望值类型和引用类型在函数内部改值或者重新申明时，能够影响外部传入的变量，让其也被修改的时候

---

## 练习

> 1. 说明 ref 和 out 的区别

- `ref`：传入时必须初始化，在函数内部可重新赋值也可不赋值
- `out`：传入时可以不初始化，但在函数内部必须赋值

> 2. 让用户输入用户名和密码，返回给用户一个bool类型的登陆结果，并且还要单独的返回给用户一个登陆信息。

```csharp
static bool Login(string name, string pwd, ref string info)
{
    if (name == "admin")
    {
        if (pwd != "8888") 
        { 
	        info = "密码错误";   
	        return false; 
        }
        else               
        { 
	        info = "登录成功";   
	        return true;  
        }
    }
    else
    {
        info = "用户名错误";
        return false;
    }
}

Console.WriteLine("请输入用户名"); string name = Console.ReadLine();
Console.WriteLine("请输入密码");   string pwd  = Console.ReadLine();
string info = "";
while (!Login(name, pwd, ref info))
{
    Console.WriteLine(info);
    Console.WriteLine("请输入用户名"); name = Console.ReadLine();
    Console.WriteLine("请输入密码");   pwd  = Console.ReadLine();
}
Console.WriteLine(info);
```

---

## 我的踩坑记录

- 调用时忘记写 `ref` / `out` 关键字，会报编译错误

---

*最后更新：*
