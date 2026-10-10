# 档案 E · 精华索引 v1.2

> 版本:1.1 → 1.2 | 最后更新:_2026/10/10_ · UI管理模块复刻会话 本版变更:
> 
> - 追加:UI管理模块 §0速记 + §3精髓(从《UI管理模块复刻笔记》提炼)
> - 追加:编码原则12条(同一方法别承担两种语义★/bool与枚举按整个状态数★/成对调用只在状态真正变化时★/存最终状态/状态显式记录不靠推断/先校验再提交/找和决定分开/数据层不碰界面+由知道上下文的一方决定/管理器的只能经管理器关删/监听注册位置/static readonly 共用数据/卫语句)
> - 补:Fail Fast 补"switch 带 default 抛异常";最小暴露补"集合交只读视图"
> - 更新:跨模块复发薄弱点——11条补 UI 模块案例(模板vs实例、两类对象、static 记复发;审题/答题完整性补交付纪律);新增"条件方向写反""状态守卫/边界""规则会说、用时没迁移"
> - 追加:通用级新用法(类型模式switch、枚举本质是整数、IReadOnlyList、扩展方法、out/Try模式、nameof、lambda谓词+List.Find、UnityEvent.RemoveListener、MissingReferenceException、Unity重写\==、失活物体生命周期、Destroy vs DestroyImmediate、GetComponentsInChildren(true)、Transform.Find、Resources加载返回值、DontDestroyOnLoad、HashSet、IndexOf/Substring、const与插值、条件编译、struct比较、EventTrigger、官方ObjectPool\<T>、.editorconfig、IDE自动using陷阱);typeof vs GetType、TryGetValue 两条补 UI 案例

> **本档用途与铁律(Claude 每次用前先读这段)** 高复用、跨模块的精华索引,传进 Context 供 Claude 在新模块撞到旧知识点时**主动考用户**。 ★ **铁律**:关联到下面任一条时,默认动作是**"你先说,我再对"**——先问"这个你记过,还记得吗/说说看",用户答完才拿本条核对。**绝不先把内容甩出来让用户看**(被动再认无效)。 ★ 本档是**索引不是教材**:只存"该被反复触发的点",展开看对应模块 Obsidian 复刻笔记。 ★ 不进用户闭卷自测(自测用户主动做);本档只供 Claude 触发。

---

## ⭐ 编码原则/设计经验(跨模块可迁移 · 最该反复 Call)

> 归属:★=用户主导;其余=Claude 供、用户判"值得沉淀"或从复刻笔记提炼。

**通用设计判断**

- ★ **分支分析 = 逻辑覆盖 + 可达性**:取反只得"逻辑上覆盖哪些组合",其中有不可达死状态;别为不可达状态操心(对象池"栈不空+超上限"逻辑属else但总数锁死不可达)。缺可达性分析会凭空制造矛盾。
- ★ **约束加"入口"不加"出口"**:限制资源加创建入口,不加取用出口(对象池上限加Instantiate阈值/预热限数,不加Pop;Pop有闲置永远优先复用)。
- **过早优化是万恶之源**:无 Profiler 证明是瓶颈前不优化;识别"收益<成本"要**果断撤销**——撤销是判断力不是失败(prefabObj三连栽后撤回)。
- **优化要权衡代价(清晰 vs DRY)**:消除重复常伴新维护负担(公共Mono三套event换枚举字典→代码短但多了new字典/预填key/判断负担,日常首选简版)。不是越优化越好。
- **别过度设计**:不为不存在的场景加防护(对象池不加线程安全)、编程错误不该用性能补(不加防重复Push的O(n)查重)、善用平台自带FailFast(Instantiate(null)Unity自己报错)。
- **危险/易误用的 API,不如从设计上不提供**:需要大段说明才能安全用的东西,不如删掉、堵死误用路径(公共Mono删ClearAllEvent,逼团队走成对Add/Remove;事件中心删全局Clear()——过场景会误伤常驻对象的监听)。
- **能让编译器拦的错,别留到运行时**:enum代替string、泛型代替object,都是把错误从"静默/运行时"挪到编译期(事件名拼错:string静默、enum编译不过)。⚠ 讲这类设计的好处时要主动说出这一条。
- **事件用来"通知",不用来"询问"**:事件单向、拿不到返回值、执行顺序不保证、调用链隐式;需要答案/顺序/强关联的交互(背包↔品质)直接调用。
- **传数据,不传对象本身**:事件传专门的数据载体(小而不可变用struct,触发前现场组装),监听方只依赖稳定契约,不依赖发生方,也调不了发生方的方法。
- **订阅机制和业务状态分开管**:"这次注册只响应一次"是订阅层(AddOnce);"首杀只能达成一次"是业务层,要由业务方记住并存档。
- **判断"要不要处理"之前,先量上限**:会不会增长、有没有上限(事件中心删空后留key:enum key有上限且小,留着反而省掉反复new的GC)。
- ★ **同一个方法别同时承担两种语义**:一个方法/返回值同时回答两个问题,信息就丢了(UI:GetPanel 拿不到 throw、TryGetPanel 拿不到返回 false,分成两个方法;`IsPrefixOfType` 一个 bool 同时答"在不在白名单""类型对不对",分不清是哪个没过)。
- ★ **2 个选项用 bool,3 个以上用枚举;按整个状态一共有几种来算,不按单个字段**(UI:加载完成后的状态 Shown/Hidden/Destroyed 用枚举)。限定条件由 Claude 建议,用户定。
- ★ **成对的生命周期调用,只在状态真正变化时调**:OnShow/OnHide 成对;已开着再 Show 不调 OnShow、已失活再 Hide 不调 OnHide、失活后再销毁也不调(否则重复注册,或者永远注销不掉)。UI L4 用户自己提炼。
- **存最终状态,别存操作过程**:加载中来回 Show/Hide 只改 `targetState`,加载完成时只看结果(UI;用户自己的"往 completed 上追加"方案要存很多委托、取消难做)。
- **状态要显式记录,不靠别的字段推断**:一个 null 不能同时代表两种情况(UI:`panel == null` 既可能是"还没加载完",也可能是"被绕过 HidePanel 销毁",所以单独记 `isLoading`)。→ 凡是"从另一个字段推断状态",都问一句"还有别的情况也会让它成立吗"。
- **先校验再提交**:实例化、放进容器之前先检查,失败时场景里和容器里都不留半截状态(UI:预设体的三项校验挪到 Instantiate 之前;同步校验通过才进字典,异步为了去重必须先占位,失败处 Remove)。
- **找和决定分开**:循环里只负责找,"都没有"要等循环走完才能判断(UI 扩展方法:"没找到就新建"写在循环的 else 里 → 每遇到一条类型不同的就新建一次,列表为空时一次都不执行)。
- **数据层只改数据、发通知,不调用界面;"该不该做某件事"由知道上下文的一方决定**(背包:PlayerData 不弹提示框;弹不弹"获得道具"由知道道具来源的调用方决定)。⑧第18题用户主动要求沉淀。
- **交给管理器管的东西,只能通过管理器关/删**(UI:提示框自己 `Destroy(gameObject)`,字典里留下死记录,再开时静默打不开)。
- **监听注册位置看"挂在谁身上、谁活得更久"**:挂在自己身上的(子物体 EventTrigger、按钮 onClick)→ Awake 注册一次,同生共死;挂在比自己活得更久的东西上的(全局 EventCenter)→ OnShow/OnHide 成对。

**错误处理**

- **Fail Fast > 静默兜底**:配置/编程错误当场报错或 throw,别给错误默认值悄悄跑(带病继续跑,错误推迟到很远才暴露)。区分"编程错误"(FailFast)vs"运行时正常意外"(优雅容错)。⚠ **FailFast 要"当场 + 说清楚"**:裸NRE也算当场炸,但使用者只能猜;报错带上"哪个事件、声称的类型、实际的类型",先定句子模板再往槽里填(事件中心类型不匹配throw)。⚠ switch 处理枚举/类型时 default 抛异常:新增成员忘了写分支,当场暴露(UI GetLayer、FindChildControls)。
- **空 catch 是大忌,至少要 log**(`catch(Exception e){ Debug.LogError(e); }`,别空catch{}吞异常)。
- ★ **写"存在性"逻辑,正常路径之外必过一遍异常路径**:凡"实例/资源/引用/缓存对象/委托 存不存在",别只想"正常有",主动过"没有/为null/越界"(挂载式getter=>instance漏了"没人挂→null→空引用")。写任何"取出来用"的逻辑都问一句"取到的会不会是空,空了会怎样"。
- **通用方法判断不了调用上下文时,加参数让调用方告知**,别自己猜(ClearPool加destroyObj区分"切场景vs手动清")。

**数据结构/容器**

- **选容器先看语义贴合,再看性能**:性能相近时,接口能否直接表达意图是首要依据(Stack Push/Pop一眼是"后进先出桶")。代码写给人读。
- **选容器/设计基于当前场景真实需求,警惕从相似场景惯性套用**(GameObject池要删中间用List、纯C#池只两端进出用Queue;别把A的需求搬给B)。
- ★ **数据的存储顺序要服务于将来在它上面跑的算法**(网格:按圈存索引规律整齐triangles好写,按纵线存要跳着算;两种都能存,按圈更省事)。
- **数据结构合法性谁负责要统一——处处防 or 一次备齐,别混用**:混用必留缝(公共Mono字典版Add用ContainsKey防、Update直接取key→没订阅时崩;改Awake一次预填全部key)。
- **所有实例共用、不该被换掉的数据用 `static readonly`**(UI:前缀白名单所有面板共用一份);⚠ readonly 只锁指向,不锁字典内容。

**封装/可读性**

- **封装/最小暴露**:私有字段+只读属性,暴露**结论**(NeedCreate/Count)不暴露**原料**(maxNum/内部容器)。⚠ 集合要交只读视图(`IReadOnlyList`):只读属性只锁字段,List 的 Add/Remove 照样能调(背包 ItemDatas,用户自己看出问题,Claude 补做法)。
- **幂等操作可无条件执行,非幂等必判断**(SetActive对已激活对象无副作用→省if;有副作用的操作必判)。
- **单一数据源(SSoT)**:配置集中一处(v2上限挂Prefab脚本),别散在各调用点(v1每处传参易不一致)。
- **混用 &&/|| 加括号明确分组**(即使优先级冗余;`A||(B&&C)`一眼看清、防看错)。
- **传参别在可能为null的对象上提前取成员**(`.transform`):传整个对象,让接收方在保护逻辑里取。
- **把魔法数/偏移提成有名字的变量**(网格`countX+1`→`vertsPerRing`),提可读性+降"安错方位"出错率。
- **借用父类同名方法就改名,故意覆盖才加 new**:撞名不处理=StackOverflow或CS0108(公共Mono借StartCoroutine→改名StartCor)。
- **"能做但选更省事的"本身就是工程判断**(对角线选哪条、按圈存)。
- **修一个模式性的问题,要搜全所有同构的地方**:修一处、其余同构处原样复现最常见(事件中心TryGetValue只修了Trigger,Add/Remove三处又出现)。
- **卫语句(提前退出)**:嵌套超过两三层、else 里只是很短的退出(throw/continue/return)时,把条件反过来提前退出,正常流程留在最外层(UI FindChildControls 五层 if 拉平成一层)。判断有几个由设计决定,嵌套有几层由写法决定。Claude 引入,用户定进编码原则。

---

## 🔁 跨模块复发薄弱点(Claude 预判性敲打 · 写这类逻辑时提前问一句)

> 用户在多个模块反复犯的稳定短板。见用户要写相关逻辑时**提前问一句**,把纠错前移。

- **收尾/簿记动作易漏(最高频)**:写完一个分支,附属状态动作(激活/改名/失活/登记/移除/销毁/字典初始化/清字典)易漏。UI:OnShow/OnHide 的调用多次漏、攒下的回调执行后没清空(L4、⑨各一次)。→ 提前问"这条分支出去前收尾动作带齐没"。
- **存在性判断精度**:`ContainsKey` vs `Count>0`、访问字典/集合前先判存在、`&&/||`短路顺序与括号。→ 提前问"没键/空了时这行会不会崩"。⚠ 别把"缺键必抛"过度泛化:读抛、写新增、`+=`抛(先读后写)、Remove/TryGetValue返回false(事件中心"Remove缺键会抛"答错)。UI:加载中 GetPanel 访问还是 null 的 panel、`prefab == null` 分支里又取 `prefab.name`、`IndexOf` 返回 -1 直接传给 `Substring`。
- **时序/依赖**:一个变量被用时,它依赖的东西创建/赋值了没(柜子根先用后建、打印先于改值)。UI:OnShow 写在 `SetActive(true)` 之前(L4、⑨两次);"是否失活"的判断写在 `SetActive(true)` 之后。
- **模板 vs 实例**:`Resources.Load`返回共享模板(不可改)、`Instantiate`返回独立实例。UI L2 在预设体上 GetComponent 存进字典(报 Destroying assets)——**复发**。
- **两类对象惯性混淆**:GameObject(会被Unity销毁会悬空、有SetActive遥控)vs 纯C#对象(靠引用存活永不悬空、交出即失控)——别把A的特性套B。⚠ **底层原因(事件中心补)**:Unity对象分引擎层(C++)和C#壳两半,Destroy只毁引擎层;C#壳只要被引用(如被委托抓着Target)就一直活着→方法照样能调、泄漏、访问transform等引擎成员抛MissingReferenceException。事件中心⑧闭卷没调出——**复发**。UI ⑧ 两题把"Destroy 后留在字典里"判成会报错——"Unity 重写 `==`"没连上(实际 `== null` 为 true,被当成加载中,静默打不开)。→ 提前问"销毁的是哪一半,谁还抓着它"。
- **弧度未成直觉(待专项重建,非查一下就好)**:`Mathf.Sin/Cos`吃弧度;更根本是"用弧度想圆"(2π整圈/π半圈/π/2直角/2π/n均分),戒360。
- **fencepost(桩vs段,两条各在不同处别混)**:①网格"格子数=countX×countZ"(顶点vs格子);②拼接"圈数=countZ+1"(间隔vs圈,定末圈z)。顶点/圈方向+1、格子/间隔方向不+1;循环`<count`。③ 截取:`Substring(0, 下标)` 不含分隔符(UI 以为截出来是 `Btn_`);④ 循环结束时 i = 长度(UI 闭包题答成 2)。
- **归因偏(机制方向对、具体因果链栽)**:如"GC由Destroy触发"(错,由堆增长触发)、"class约束因as需要"(错,as转的是PoolObject\<T>本就引用类型)、"Lazy\<T>要求公共构造"(错,是基类工厂里new T()带来的new()约束)。
- **具体错点(词没扎进去)**:static本质=属于类全局一份(易滑成"唯一性"结果)、无限递归=栈溢出StackOverflow(易滑成内存泄漏)、内存泄漏≠崩溃(泄漏是状态,崩溃只是可能后果)、LogError不中断(只写日志,throw才中断)。UI L1 static 又滑成"唯一性"——**复发**。
- **手上精度**:复制粘贴改漏(公共Mono两次把Late/Fixed的+=写到_updateEvent;事件中心OnDestroy、OnDisable写成Add,第3、4次;⑥新写成对代码首次通过)、set里value/字段混用(属性钳制)、for三段用不同变量、countX/countZ写混。UI:PointerUp 的打印没改、报错信息里该写 `{prefabName}` 的位置写成了 `{UIPath}`、参数名 `btnName` 复发、复制过来的变量没换(completed 里用了外层此时为 null 的 `panelInfoBase`)。→ 提前问"成对代码逐行只看动词了吗"。
- **对称遗漏(事件中心新)**:修一处、其余同构处原样复现;保护只加一半(类型检查只加有参版)。UI:is 转换失败的处理漏了第4、5处,`Ipt`/`Drp` 分支漏写,拖拽移入/移出只改了一半。→ 提前问"同样的写法还有哪几处"。
- **方向/角色表述精度(事件中心新,4信号)**:发生方/响应方、key/value说反,报错信息方向写反,Trigger里写"传入方法"。UI:Awake/OnShow 的注册映射说反、Fail Fast 原则一度说反、"全失活的代价"答成"全销毁的代价"、"执行"说成"记录"(3次)、"同一物体上的组件"说成子物体(3次)。→ 写提示/答题前先定句子模板再填槽。
- **审题/答题完整性(事件中心新·双因)**:多问只答一半、测试要求没做全、自查清单未交。⚠ 一部分是Claude一次问太多/措辞歧义→Claude一条只问一件事;用户侧→答题前先数清几问。UI 补**交付纪律**:测试报告只写"全部通过"且多次缺项;PanelBase 前几版没编译、没跑测试就交。→ 交代码前先编译、跑一遍测试。
- **术语/错别字(笔试白板扣分)**:场→厂/Data→Date/冗余→荣誉/出现→出钱等,写完扫一遍高频术语。
- **条件方向写反(UI新,3次)**:L1 TryGetValue 的条件写反、⑦ `i < 0`、⑨ `ContainsKey` 漏了 `!`(一个控件都存不进去)。→ 提前问"这个条件成立时走进去的,是你想要的那种情况吗",代一个具体值过一遍。
- **状态守卫/边界(UI新,⑨三部分都出现)**:操作前不看当前状态(已失活还调 OnHide、加载中调 Get);"都没有"写在循环里;空列表、找不到(-1)没考虑。→ 提前问"如果它已经是这个状态了 / 列表是空的 / 一个都没找到,这段会怎样"。
- **规则会说,用的时候没迁移(UI新,2信号)**:L4 自己提炼的"OnShow/OnHide 成对",L5 写测试面板时没用上;⑦"数据放数据类、界面只读"金币做对了、道具没套上。→ 写相关代码前提前问"这里适用你自己定的哪条规则"。

---

## 🔑 新用法/关键字(通用级 · 会用即可,提醒有这个工具)

> 跨模块会再撞的语言/通用工具。见用户用到相邻场景时可提一句"这里可以用X"。

**泛型/类型**

- **`where T : class, new()`**:`new()`=T须有公共无参构造(有`new T()`时必加);`class`=限引用类型、挡struct误用。
- **`as` 向下转型**:父转子,失败返null(硬转`(T)`失败抛异常);⚠"安全"可能是假象(下一行取成员仍空引用)。⚠ 只能用于引用类型/可空类型(int装不下null→`as int`编译不过,`as int?`可以)。
- **`is` 类型模式**:`if (obj is EventInfo<T> info)` 一步完成判断+转换+赋值,失败返回false不抛;变量只在if成立分支可用(事件中心全面替代as)。
- **`typeof(T).Name` / `.ToString()`**:短名/全名(带命名空间不易撞名),当泛型容器的键。
- **`typeof(T)` vs `obj.GetType()`**:编译期"声称的"类型 vs 运行时"实际的"类型,报错时两个一起打;⚠ 打的是CLR名(float→Single、int→Int32)。⚠ 基类方法里 `GetType()` 拿到的是子类类型;撞名时用 `FullName`(UI)。
- **struct 的 `new` 不在堆上**:值类型的new只是初始化;配合泛型传递不装箱→数据载体零GC。
- **类型模式 switch**:`switch (control) { case Button btn: ...; case InputField: break; default: throw ...; }` 按类型分支并顺便转换;⚠ 不带变量的 `case InputField:` 是 C# 9 写法。
- **枚举本质是整数**:`(E_UILayer)10` 能强转出没有名字的值,所以 switch 要 default;⚠ 默认值 = 第一个成员(UI `E_PanelTargetState` 第一个写 Shown)。
- **struct 比较**:默认不能 `==`;`Equals`/`Contains` 逐字段比较。

**字段/属性/修饰**

- **`readonly`**:字段只能声明时/构造函数赋值,锁死"指向不许换"(单例lockObj/Lazy字段);⚠锁指向不锁对象内部状态。
- **表达式体属性** `=> _stack.Count`:只读属性简写,配"最小暴露"。
- **`readonly struct` + 只读自动属性 `{ get; }`**:编译器保证创建后不可变,自动属性省掉手写私有字段;⚠只能在构造函数里赋值。
- **弃元参数名 `_`**:`void OnShowInfo(MonsterDeadInfo _)` 表明"故意不用"。
- **`[RequireComponent(typeof(T))]`**:挂脚本时自动挂依赖组件且不许删;⚠只保证挂一个(BGM+音效两个AudioSource不适用)。`[SerializeField] private`让private也能Inspector显示(优于public)。
- **`IReadOnlyList<T>`**:把内部 List 交出去时只给只读视图(配"最小暴露")。
- **扩展方法**:静态类里 `public static void Foo(this UIBehaviour control)`,调用写成 `control.Foo()`;⚠ 本质是写在别的类里的外部方法,访问不到 private;子类都能调(里氏替换)。
- **`out` 参数 / Try 模式**:`bool TryGetPanel<T>(out T panel)`,成功返回 true;⚠ 每条返回路径前都要给 out 赋值。
- **`nameof(X)`**:编译期取名字,重命名时跟着变;⚠ 只是字符串。

**异常/委托/协程**

- **`throw new System.Exception(...)`**:主动抛异常当场中断;⚠配置错误(忘挂脚本)该throw(FailFast),运行时正常意外别throw。⚠ `Debug.LogError`只写日志、后面照常执行,不等于中断;Unity顶层接住未捕获异常,只停本帧这条调用链。
- **lambda 注销**:注册、注销各写一段一样的lambda是两个不同方法,`-=`静默失败;要注销就把lambda存进字段用同一引用。("委托相等比目标+方法")
- **`Lazy<T>`**:`new Lazy<T>(()=>new T())`,访问`.Value`才创建,包掉双检锁;⚠靠new T()只能用于不继承Mono的单例。
- **`GetInvocationList()`**:返回委托里所有订阅方法(Delegate\[]),逐个单独调(异常隔离:一个抛不影响后面);⚠每帧调有生成数组开销。
- **`Coroutine`句柄**:`Coroutine cor = StartCoroutine(...)`,存住才能精确`StopCoroutine(cor)`;⚠停完置null。`StopCoroutine`能收IEnumerator或句柄,用句柄最稳。
- **`base.`**:`base.Awake()`/`base.StartCoroutine()` 调被自己同名方法遮住的父类方法。
- **lambda 谓词 + `List.Find`**:`list.Find(e => e.eventID == type)` 返回第一个满足条件的,没有就返回 default(引用类型为 null);⚠ Find 自己会遍历,外面别再套一层循环。
- **`UnityEvent.RemoveListener`**:回调不存在时什么都不做;UnityEvent 没法查运行时加的回调(`GetPersistentEventCount` 只统计 Inspector 里配的)。
- **`MissingReferenceException`**:访问已 Destroy 对象的引擎成员时抛;和 NRE 不同——C# 引用还在,引擎那一半没了。

**其他**

- **`GetInstanceID()`**:对象唯一ID,验证"两个变量指不指向同一对象";⚠调试用,不写进正式逻辑。
- **`mesh` vs `sharedMesh`**:mesh=专属拷贝(改单个)、sharedMesh=共享原件(改动连累所有共用者+磁盘Prefab);循环反复读`.mesh`会堆拷贝泄漏。("拷贝vs原件"思维,同DontDestroyOnLoad状态残留)
- **`++i` vs `i++`**:嵌表达式里(`arr[i++]`当下标)有区别、单独成句无区别;"++i更快"对C# int不成立,按语义选(嵌下标必`i++`)。
- **enum + Dictionary 合并同类项**:`Dictionary<E_Type, Action>`把多套event合一套;⚠代价:字典要new、key要预填、维护负担↑。
- **`TryGetValue` + `out var`**:`if (dic.TryGetValue(key, out var v))` 一次查字典完成判存在+取值;⚠取出来的v要用上,别下一行又用索引器再查。UI ⑨ 又出现 3 处二次查表(IsPrefixOfType、GetControl 报错信息、completed 里 `_panelDic[name]`)。
- **`Dictionary.Remove` / `List.Remove`**:自己会找,找不到返回false不抛,不用先循环判断。
- **Unity 重写 `==`**:Destroy 后 `obj == null` 为 true(C# 引用其实还在);所以"是否为 null"不能拿来同时表示别的状态。
- **失活物体的生命周期**:Awake/Start 不执行,第一次激活时才执行;失活物体上 `StartCoroutine` 报错、协程不启动;普通方法照常可调。
- **`Destroy` vs `DestroyImmediate`**:延迟到帧末 vs 立即;⚠ 只有边遍历边**立即**删除时才必须倒着遍历。
- **`GetComponentsInChildren<T>(true)`**:包括自己和所有子孙,`true` 连失活的也找。
- **`Transform.Find("A/B")`**:只找直接子物体(可传路径),能找到失活的,找不到返回 null;`GameObject.Find` 只找激活的。
- **`Resources.Load` / `LoadAsync` + `request.completed`**:找不到时分别返回 null / `asset` 为 null;`Instantiate(null)` 抛 ArgumentException。
- **`DontDestroyOnLoad`**:切场景不销毁;⚠ 只对根物体有效。
- **`HashSet<T>`**:只关心"在不在"的集合;⚠ 小集合和 List 性能差不多,按语义选。
- **`IndexOf` / `Substring(起点, 长度)`**:找不到返回 -1;⚠ 第二个参数是长度,不是终点。
- **const 与插值字符串**:带变量的 `$"..."` 不能是 const,用 `"...{0}..."` + `string.Format`。
- **条件编译 `#if UNITY_EDITOR || DEVELOPMENT_BUILD`**:开发版和发布版走不同处理(如开发版 throw、发布版 LogError 后兜底)。
- **EventTrigger**:组件里的 `triggers` 列表,每条 `Entry` 有 `eventID` 和 `callback`(`UnityEvent<BaseEventData>`);⚠ 它实现了所有指针接口,会截住父物体(ScrollRect)的拖拽;一个物体只挂一个,先 GetComponent 再 AddComponent。
- **Unity 官方 `ObjectPool<T>`**:`Get`/`Release`,面试加分点。
- **`.editorconfig`**:`root = true` + `[*.cs] charset = utf-8-bom`,放在所有工程的上一层文件夹共用;改完要重启 VS。
- ⚠ **IDE 自动 using 陷阱**:自动补全会悄悄加 `using Unity.VisualScripting;`,让 `component.AddComponent<T>()` 这种本不存在的写法也能编译通过(UI 扩展方法、⑦ TipPanel 各一次)。正确写法是 `gameObject.AddComponent<T>()`。

---

## 📍 各模块 §0 一句话速记(选型/核心判据)

- **程序化网格生成**:往Mesh填三组数据——vertices(本地坐标)/triangles(存顶点索引,每3个=1面)/uv;圆柱=一圈圈顶点沿z排开(sin/cos摆圆+z递增)+相邻两圈索引连三角形。
- **无限地图拼接**:两块地形循环复用伪造无限;地动车不动;车到后块偏前→移除旧块+最前端接新块;新块起点xy取旧末圈(接缝对齐防断层)、z=旧末圈z+一个间隔(防重叠续延伸),接缝后几圈Lerp平滑。
- **单例基类**:保证一个类全局唯一实例(static=属于类、全局一份);四形态选型两条轴——要不要进场景用生命周期(不继承Mono双检锁/Lazy vs 继承Mono)、要不要Inspector配(自动挂载式 vs 挂载式);判据内核"能编辑器配的别代码写死"。
- **公共Mono模块**:让不继承Mono的纯逻辑管理器"白嫖"帧更新和协程;MonoMgr继承自动挂载式,存假Update事件、真Update里`?.Invoke`转发,订阅方法包成Add/Remove(event私有)。
- **对象池**:柜子(Dictionary按名分类)+抽屉(闲置容器)+取/放/清;两套并行——GameObject池(会悬空、靠SetActive/父子管理)和纯C#池(靠引用存活永不悬空、只排队进出);上限加入口不加出口。
- **事件中心**:发生方只喊"发生了什么"、响应方自己来听——注册只是"存",发生方显式Trigger(key)才是"调";容器`Dictionary<事件名, 装着委托的盒子>`,一个事件一种签名;用来通知,不用来询问。
- **UI管理模块**:PanelBase 自动收控件(前缀白名单决定收哪种组件)+ 统一响应入口;UIManager 按类名一个面板一份,管加载/显示/隐藏/销毁/分层;扩展方法给任意控件加 EventTrigger 事件。核心:记最终状态、加载中只改状态;OnShow/OnHide 成对、只在状态真正变化时调用;"正在加载"显式记录,不靠 `panel == null` 推断。

---

## 💎 各模块 §3 精髓(最易滑的那层洞察)

- **网格生成**:数据存储顺序服务于将来在它上面跑的算法(按圈存vs按纵线存)。四角偏移错在"哪一圈(上/下)"不在"左右",与顺逆时针无关,z坐标是铁证。
- **无限拼接**:三方向各司其职——z管接着往前不重叠、xy管接缝对齐不断层、Lerp管平滑,所以是混合取法(不是三个都取同一点)。"**接续≠相等,差一个步长**"(z=末圈+间隔,相等则重叠);别把"每圈各自的z"和"整块位置"两概念串了(本项目z是每顶点各自坐标,无"整块中心")。
- **单例**:static保证的是"归属+份数"(属于类、全局一份),**不是"唯一性结果"**(别答"哪都能调"=public、别跳到"唯一性");getter创不创建=三变种分水岭;abstract两版必要性不同(不继承版基类能new必需、自动挂载版两入口天生封死可选)。
- **公共Mono**:"存"和"调"是两件事(订阅方法只把方法存进event,真生命周期函数才每帧调,少后者方法是死的);event必须private(已提供Add/Remove唯一入口,event该藏死,public=自相矛盾)。
- **对象池**:name一名多用(字典键+Resources路径+obj.name校准);上限约束加入口不加出口(有闲置永远优先复用);两类对象生命周期机制根本不同(决定能否抢占/是否清)。
- **事件中心**:转换没有消失,是从数据层(object→int,装箱)挪到了容器层(IEventInfo→EventInfo\<T>,引用转引用)——所以不再装箱,失败点也挪进事件中心;一个事件一种签名是约束不是缺陷(零参数也是一种签名→非泛型重载的意义);订阅的"一次"≠业务的"一次";"存和调是两件事"与公共Mono同一条。
- **UI管理模块**:存最终状态,别存操作过程(targetState);一个 null 不能同时代表两种情况("还没加载完" vs "被外部销毁",根源是 Unity 重写 `==`,所以要 isLoading);**回调 ≠ OnShow**——回调是调用方"这一次"打开要做的事,OnShow 是面板自己"每次真正打开"要做的事,已开着再 Show 只执行回调;前缀决定类型 → 查找顺序无关(从设计上消除撞 key);先校验再提交(同步校验后才进字典,异步先占位、失败处 Remove)。

---

> **维护(与复刻笔记的关系,不可跳)**:档案E 是**每轮 Obsidian 复刻笔记的二次提炼**,不是凭空写。每复刻完一个模块、出完该模块的复刻笔记后,从笔记里提取——§0速记←笔记§0;§3精髓←笔记§3;编码原则←笔记⭐区块;跨模块薄弱点←笔记§7+复刻实录(挑跨模块复发的);通用级新用法←笔记§8(挑非模块专属的)——追加进本档。**顺序死的:先复刻笔记,再提炼档案E。** 只追加不重复;保持精炼不膨胀。