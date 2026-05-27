# 06 C# 5

**所属模块**：[[00 CSharp 知识补充总览]]
**关联**：[[18 多线程]] | [[07 协同程序]]
**查阅次数**：0

---
## 新功能和语法

1. 调用方信息特性
2. 异步方法async和await

**在学习异步方法async和await之前**
我们必须补充一些知识点
1. 线程和线程池
2. Task类

---

### 线程和线程池

**线程**

```csharp
Thread t;
//1.Unity支持多线程
//2.Unity中开启的多线程不能使用主线程中的对象
//3.Unity中开启多线程后一定记住关闭
t = new Thread(()=> {
    while (true)
    {
        print("123");
        Thread.Sleep(1000);
    }
});
t.Start();
print("主线程执行");
private void OnDestroy()
{
    t.Abort();
    print("线程关闭");
}
```

**线程池**

在多线程的应用程序开发中，频繁的创建删除线程会带来性能消耗，产生内存垃圾
为了避免这种开销C#推出了 线程池ThreadPool类

ThreadPool中有若干数量的线程，如果有任务需要处理时，会从线程池中获取一个空闲的线程来执行任务
任务执行完毕后线程不会销毁，而是被线程池回收以供后续任务使用
当线程池中所有的线程都在忙碌时，又有新任务要处理时，线程池才会新建一个线程来处理该任务，
如果线程数量达到设置的最大值，任务会排队，等待其他任务释放线程后再执行
线程池能减少线程的创建，节省开销，可以减少GC垃圾回收的触发

线程池相当于就是一个**专门装线程的缓存池**
**优点：** 节省开销，减少线程的创建，进而有效减少GC触发
**缺点：** 不能控制线程池中线程的执行顺序，也不能获取线程池内线程取消/异常/完成的通知

```csharp
//命名空间：System.Threading
//类名：ThreadPool（线程池）

//ThreadPool是一个静态类
//里面提供了很多静态成员
//其中相对重要的方法有

//1.获取可用的工作线程数和I/O线程数
int num1;
int num2;
ThreadPool.GetAvailableThreads(out num1, out num2);
print(num1);
print(num2);

//3.设置线程池中可以同时处于活动状态的 工作线程的最大数目和I/O线程的最大数目
//  大于次数的请求将保持排队状态，知直到线程池线程变为可用
//  更改成功返回true，失败返回false
if(ThreadPool.SetMaxThreads(20, 20))
{
    print("更改成功");
}

//2.获取线程池中工作线程的最大数目和I/O线程的最大数目
ThreadPool.GetMaxThreads(out num1, out num2);
print(num1);
print(num2);

//5.设置 工作线程的最小数目和I/O线程的最小数目
if(ThreadPool.SetMinThreads(5, 5))
{
    print("设置成功");
}
//4.获取线程池中工作线程的最小数目和I/O线程的最小数目
ThreadPool.GetMinThreads(out num1, out num2);
print(num1);
print(num2);

//6.将方法排入队列以便执行，当线程池中线程变得可用时执行

ThreadPool.QueueUserWorkItem((obj) =>
{
    print(obj);
    print("开启了一个线程");
}, "123452435345");//obj等于传的第二个参数


//缺点：不能控制线程池中线程的执行顺序，也不能获取线程池内线程取消/异常/完成的通知
for (int i = 0; i < 10; i++)
{
    ThreadPool.QueueUserWorkItem((obj) =>
    {
        print("第" + obj + "个任务");
    }, i);//不是按照1234...的顺序执行
}

print("主线程执行");
```

---

### Task 类

Task顾名思义就是**任务**的意思
Task是在线程池基础上进行的改进，它拥有线程池的优点，同时解决了使用线程池不易控制的弊端
它是基于线程池的优点对线程的封装，可以让我们更方便高效的进行多线程开发

**简单理解：**
- Task的本质是对线程Thread的封装，它的创建遵循线程池的优点，并且可以更方便的让我们控制线程
- 一个Task对象就是一个线程

**命名空间：System.Threading.Tasks**
**类名：Task**

**总结：**
1. Task类是基于Thread的封装
2. Task类可以有返回值，Thread没有返回值
3. Task类可以执行后续操作，Thread没有这个功能
4. Task可以更加方便的取消任务，Thread相对更加单一
5. Task具备ThreadPool线程池的优点，更节约性能

---

#### 创建无返回值Task

```csharp
private bool isRuning = true;
private void OnDestroy()
{
    isRuning = false;
}

//创建无返回值Task的三种方式
//1.通过new一个Task对象传入委托函数并启动
Task t1 = new Task(() =>
{
    int i = 0;
    while (isRuning)
    {
        print("方式一:" + i);
        ++i;
        Thread.Sleep(1000);
    }
});
t1.Start();

//2.通过Task中的Run静态方法传入委托函数
Task t2 = Task.Run(() =>
{
    int i = 0;
    while (isRuning)
    {
        print("方式二:" + i);
        ++i;
        Thread.Sleep(1000);
    }
});

//3.通过Task.Factory中的StartNew静态方法传入委托函数
Task t3 = Task.Factory.StartNew(() =>
{
    int i = 0;
    while (isRuning)
    {
        print("方式三:" + i);
        ++i;
        Thread.Sleep(1000);
    }
});
```

---

#### 创建有返回值Task

```csharp
private bool isRuning = true;
Task<int> t1;
Task<string> t2;
Task<float> t3;

//创建有返回值的Task
//1.通过new一个Task对象闯入委托函数并启动
t1 = new Task<int>(() =>
{
    int i = 0;
    while (isRuning)
    {
        print("方式一:" + i);
        ++i;
        Thread.Sleep(1000);
    }
    return 1;
});
t1.Start();

//2.通过Task中的Run静态方法传入委托函数
t2 = Task.Run<string>(() =>
{
    int i = 0;
    while (isRuning)
    {
        print("方式二:" + i);
        ++i;
        Thread.Sleep(1000);
    }
    return "1231";
});

//3.通过Task.Factory中的StartNew静态方法传入委托函数
t3 = Task.Factory.StartNew<float>(() =>
{
    int i = 0;
    while (isRuning)
    {
        print("方式三:" + i);
        ++i;
        Thread.Sleep(1000);
    }
    return 4.5f;
});

//获取返回值
void Update()
{
    if(Input.GetKeyDown(KeyCode.Space))
    {
        isRuning = false;
        print(t1.Result); //1
        print(t2.Result); //1231
        print(t3.Result); //4.5
    }
}

//注意：
//Resut获取结果时会阻塞线程
//即如果task没有执行完成
//会等待task执行完成获取到Result
//然后再执行后边的代码,也就是说 执行到这句代码时 由于我们的Task中是死循环 
//所以主线程就会被卡死
print(t1.Result);//卡死线程 因为线程是死循环 会卡死主线程
print(t2.Result);
print(t3.Result);

print("主线程执行");
```

---

#### 同步执行Task

```csharp
//刚才举的例子都是通过多线程异步执行的
//如果希望Task能够同步执行
//只需要调用Task对象中的RunSynchronously方法

//注意：需要使用 new Task对象的方式，因为Run和StartNew在创建时就会启动

Task t = new Task(()=> {
    Thread.Sleep(1000);
    print("哈哈哈");
});

//t.Start();//异步执行
t.RunSynchronously();//同步执行
print("主线程执行");

//不Start 而是 RunSynchronously
```

---

#### Task中线程阻塞的方式（任务阻塞）

```csharp
//1.Wait方法：等待任务执行完毕，再执行后面的内容
Task t1 = Task.Run(() =>
{
    for (int i = 0; i < 5; i++)
    {
        print("t1:" + i);
    }
});

Task t2 = Task.Run(() =>
{
    for (int i = 0; i < 20; i++)
    {
        print("t2:" + i);
    }
});
t2.Wait();//等待t2里面的逻辑执行结束，才会继续执行下面的逻辑

//2.WaitAny静态方法：传入任务中任意一个任务结束就继续执行
Task.WaitAny(t1, t2);

//3.WaitAll静态方法：任务列表中所有任务执行结束就继续执行
Task.WaitAll(t1, t2);

print("主线程执行");
```

---

#### Task完成后继续其它Task（任务延续）

```csharp
//1.WhenAll静态方法 + ContinueWith方法：传入任务完毕后再执行某任务
Task.WhenAll(t1, t2).ContinueWith((t) =>
{
    print("一个新的任务开始了");
    int i = 0;
    while (isRuning)
    {
        print(i);
        ++i;
        Thread.Sleep(1000);
    }
});

Task.Factory.ContinueWhenAll(new Task[] { t1, t2 }, (t) =>
{
    print("一个新的任务开始了");
    int i = 0;
    while (isRuning)
    {
        print(i);
        ++i;
        Thread.Sleep(1000);
    }
});

//2.WhenAny静态方法 + ContinueWith方法：传入任务只要有一个执行完毕后再执行某任务
Task.WhenAny(t1, t2).ContinueWith((t) =>
{
    print("一个新的任务开始了");
    int i = 0;
    while (isRuning)
    {
        print(i);
        ++i;
        Thread.Sleep(1000);
    }
});

Task.Factory.ContinueWhenAny(new Task[] { t1, t2 }, (t) =>
{
    print("一个新的任务开始了");
    int i = 0;
    while (isRuning)
    {
        print(i);
        ++i;
        Thread.Sleep(1000);
    }
});
```

---

#### 取消Tesk执行

```csharp
//方法一：通过加入bool标识 控制线程内死循环的结束

//方法二：通过CancellationTokenSource取消标识源类 来控制
//CancellationTokenSource对象可以达到延迟取消、取消回调等功能
CancellationTokenSource c;
c = new CancellationTokenSource();
//延迟取消
Task.Run(() =>
{
    int i = 0;
    while (!c.IsCancellationRequested)
    {
        print("计时：" + i);
        ++i;
        Thread.Sleep(1000);
    }
});

void Update()
{
    if(Input.GetKeyDown(KeyCode.Space))
    {
        c.Cancel();//取消
    }
}
//延迟取消
c.CancelAfter(5000);//延迟5秒取消

//取消回调
c.Token.Register(() =>
{
    print("任务取消了");
});
```

---

### 异步方法async和await

同步和异步主要用于修饰方法
**同步方法：**
当一个方法被调用时，调用者需要等待该方法执行完毕后返回才能继续执行
**异步方法：**
当一个方法被调用时立即返回，并获取一个线程执行该方法内部的逻辑，调用者不用等待该方法执行完毕

**简单理解**
把一些不需要立即得到结果且耗时的逻辑设置为异步执行，这样可以提高程序的运行效率
避免由于复杂逻辑带来的的线程阻塞

**需要处理的逻辑会严重影响主线程执行的流畅性时，需要使用异步编程**
比如：
1. 复杂逻辑计算时
2. 网络下载、网络通讯
3. 资源加载时
4. 等等

**注意：**
Unity中大部分异步方法是不支持异步关键字async和await的，我们只有使用协同程序进行使用
虽然官方 不支持 但是 存在第三方的工具（插件）可以让Unity内部的一些异步加载的方法 支持 异步关键字 https://github.com/svermeulen/Unity3dAsyncAwaitUtil

虽然Unity中的各种异步加载对异步方法支持不太好
但是当用到.Net 库中提供的一些API时，可以考虑使用异步方法
1. Web访问：HttpClient
2. 文件使用：StreamReader、StreamWriter、JsonSerializer、XmlReader、XmlWriter等等
3. 图像处理：BitmapEncoder、BitmapDecoder
**一般.Net 提供的API中 方法名后面带有 Async的方法 都支持异步方法**

```csharp
//async和await一般需要配合Task进行使用
//async用于修饰函数、lambda表达式、匿名函数
//await用于在函数中和async配对使用,主要作用是等待某个逻辑结束
//此时逻辑会返回函数外部继续执行，直到等待的内容执行结束后，再继续执行异步函数内部逻辑
//在一个async异步函数中可以有多个await等待关键字

//使用async修饰异步方法
//1.在异步方法中使用await关键字（不使用编译器会给出警告但不报错），否则异步方法会以同步方式执行
//2.异步方法名称建议以Async结尾
//3.异步方法的返回值只能是void、Task、Task<>
//4.异步方法中不能声明使用ref或out关键字修饰的变量

//使用await等待异步内容执行完毕（一般和Task配合使用）
//遇到await关键字时
//1.异步方法将被挂起
//2.将控制权返回给调用者(主线程)
//3.当await修饰内容异步执行结束后，继续通过调用者线程执行后面内容

TestAsync();
print("主线程逻辑执行");//第二个打印

public async void TestAsync()
{
    //1
    print("进入异步方法");//第一个打印
    //2
    await Task.Run(() => //挂起
    {
        Thread.Sleep(5000);
    });
    //3
    print("异步方法后面的逻辑");//最后打印
}

//举例说明
//1.复杂逻辑计算（利用Task新开线程进行计算 计算完毕后再使用 比如复杂的寻路算法）
CalcPathAsync(this.gameObject, Vector3.zero);

public async void CalcPathAsync(GameObject obj, Vector3 endPos)
{
    print("开始处理寻路逻辑");
    int value = 10;
    await Task.Run(() =>
    {
        //处理复杂逻辑计算 通过 休眠来模拟 计算的复杂性
        Thread.Sleep(1000);
        value = 50;
        //是多线程 意味着不能在 多线程里 去访问 Unity主线程场景中的对象
        //这样写会报错
        //print(obj.transform.position);
    });

    print("寻路计算完毕 处理逻辑" + value);
    obj.transform.position = Vector3.zero;
}

//2.计时器
CancellationTokenSource source;
Timer();
print("主线程逻辑执行");

public async void Timer()
{
    UnityWebRequest q = UnityWebRequest.Get("");
    source = new CancellationTokenSource();
    int i = 0;
    while (!source.IsCancellationRequested)
    {
        print(i);
        await Task.Delay(1000);//这个是计时器专用的方法
        ++i;
    }
}

void Update()
{
    if (Input.GetKeyDown(KeyCode.Space))//空格结束计数
        source.Cancel();
}

//3.资源加载(Addressables的资源异步加载是可以使用async和await的)

```

---

# API速查



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
