# AGENTS 规范说明

本文件用于约束所有在本仓库中协助开发的智能体(Agents)与自动化工具的行为规范。
请确保在进行代码生成、命令行操作或文档撰写时遵守以下规则。

---

## 1. 通用沟通规范

1. **统一语言**
    * 所有由智能体输出给中文用户查看的内容,**必须使用简体中文**。
    * 如需出现英文专业术语,应保持原文,并在必要时附上简短中文说明。

2. **简洁输出原则**
    * **禁止客套话**: 不得使用"好的,我来帮你..."、"让我为您..."等客套用语,直接进入正题。
    * **不输出冗余代码**: 功能完成后,不必重复输出完整实现代码,除非明确要求查看。
    * **不做效果对比说明**: 代码完成后,不必输出"优化前/优化后"的效果对比,直接完成任务即可。
    * **仅输出关键信息**: 只说明必要的操作步骤、注意事项、不必输出修改的代码包括关键代码，简单文字说明即可。

---

## 2. Flutter 相关规范

### 2.1 命令行使用规范

1. **优先使用 fvm**
    * 当需要给出 Flutter 相关命令时,**必须优先尝试使用 fvm**,例如:

      ```bash
      fvm flutter pub get
      fvm flutter run
      fvm flutter build apk
      ```

    * 仅在明确说明「未使用 fvm」或「没有配置 fvm」的前提下,才可以使用原生 `flutter` 命令,例如:

      ```bash
      flutter pub get
      flutter run
      ```

2. **命令展示规范**
    * 建议同时在文字中说明命令目的,例如:

      ```bash
      fvm flutter pub get  # 拉取依赖
      ```

### 2.2 Toast 使用规范

1. **统一使用 FToastUtil**
    * 所有与「Toast 提示」相关的代码示例与实现方案,**必须使用 `FToastUtil` 工具类**。
    * 禁止推荐或示例使用以下方式(除非仓库已有明确规范要求):
        * 直接使用 `FlutterToast` 第三方库调用
        * 直接使用 `ScaffoldMessenger` 做 Toast 风格提示(除特殊场景说明)

2. **示例示意**

   ```dart
   // 正确示例(仅作示意)
   FToastUtil.show("操作成功");
   ```

### 2.3 状态管理规范

1. **优先使用 GetX**
    * 项目中的状态管理、路由导航、依赖注入等功能,**必须优先使用 GetX 框架**。
    * 禁止推荐或示例使用其他状态管理方案(如 Provider、Bloc、Riverpod 等),除非:
        * 项目中已有明确的其他状态管理方案
        * 开发者明确要求使用特定方案

2. **GetX 使用规范**
    * 状态管理使用 `GetxController`:

      ```dart
      class HomeController extends GetxController {
        final count = 0.obs;
        void increment() => count.value++;
      }
      ```

    * 路由导航使用 `Get.to()` 等方法:

      ```dart
      Get.to(() => DetailPage());
      Get.back();
      ```

    * 依赖注入使用 `Get.put()` 或 `Get.lazyPut()`:

      ```dart
      Get.put(HomeController());
      final controller = Get.find<HomeController>();
      ```
### 2.3.1页面三文件结构规范（Controller + Page + Binding）
当生成或讲解一个独立页面时，必须按以下三文件结构组织，禁止将 Controller、Binding 与 Page 写在同一个文件（除非页面极简单且明确说明）。

1. **文件命名与位置**
      text
      pages/
      └── [功能名]/
      ├── [功能名]_controller.dart   # GetX 控制器
      ├── [功能名]_page.dart          # 视图层(StatelessWidget)
      └── [功能名]_binding.dart       # 依赖注入与路由绑定
      示例：登录页
      pages/login/
      ├── login_controller.dart
      ├── login_page.dart
      └── login_binding.dart

2.  **Controller 规范**
    继承 GetxController
          状态使用 .obs，逻辑方法写在控制器内
          不在 Controller 内直接操作 BuildContext（如弹窗、导航可用 Get 工具）
      ```dart
        class LoginController extends GetxController {
        final email = ''.obs;
        final password = ''.obs;

        void login() async {
            // 逻辑...
            }
        }

3.  **Binding 规范**
    实现 Bindings 接口，重写 dependencies() 方法

    在该方法中执行 Get.lazyPut(() => XxxController())

    若页面需要其他依赖（如 Repository），也在此注入

   ```dart
   class LoginBinding extends Bindings {
   @override
   void dependencies() {
   Get.lazyPut(() => LoginController());
   // Get.lazyPut(() => LoginRepository());
   }
   }
   ```
4.  **Page规范**
  * 必须是 StatelessWidget（无需 StatefulWidget，状态由 GetX 管理）
  * 使用 GetView<XxxController> 替代直接写 Get.find()，让代码更简洁
  * 在 GetView 中通过 controller 直接访问控制器实例
      ```dart
      class LoginPage extends GetView<LoginController> {
      const LoginPage({super.key});
   
      @override
      Widget build(BuildContext context) {
      return Scaffold(
      body: Obx(() => Text(controller.email.value)),
    );
    }
    }
    ```

5.  **路由注册规范**
  * 在 app_routes.dart 或 GetPage 配置中，必须显式关联 page 与 binding：
   ```dart
   GetPage(
   name: '/login',
   page: () => LoginPage(),
   binding: LoginBinding(),
   )
   ```
   * 智能体生成代码时，必须同时给出完整的三文件代码和路由注册示例，不得遗漏 Binding 或错误的注入方式。

### 2.4 屏幕适配规范

1. **统一使用 flutter_screenutil**
    * 所有涉及尺寸、字体大小、间距等 UI 相关的代码示例,**必须使用 `flutter_screenutil` 进行屏幕适配**。
    * 禁止直接使用硬编码数值或 MediaQuery 进行适配(除特殊场景说明)。

2. **flutter_screenutil 使用规范**
    * 宽度适配使用 `.w`:

      ```dart
      Container(width: 100.w)
      ```

    * 高度适配使用 `.h`:

      ```dart
      Container(height: 50.h)
      ```

    * 字体大小使用 `.sp`:

      ```dart
      Text('标题', style: TextStyle(fontSize: 16.sp))
      ```

    * 适配最小值使用 `.r` (常用于圆角、图标等):

      ```dart
      BorderRadius.circular(8.r)
      ```

### 2.5 圆形头像规范

1. **统一使用 ClipOval 包裹**
    * 所有圆形头像必须使用 `ClipOval` 包裹 `ImageView`,避免低分辨率设备显示不圆。
    * 使用 `ClipOval` 时,`ImageView` 的 `borderRadius` 设置为 `0`。
    * 示例:

      ```dart
      ClipOval(
        child: ImageView(
          imageUrl: avatar,
          width: 36.w,
          height: 36.w,
          fit: BoxFit.cover,
          borderRadius: 0,
        ),
      )
      ```

### 2.6 网络请求与错误处理规范

1. **统一通过 ApiService/仓库层**
    * 所有接口调用必须走封装的 `ApiService` 与对应仓库,禁止在 Controller/Widget 里直接创建 `Dio`
      或散落的请求。
2. **错误提示单一出口**
    * 业务失败、网络异常、token 过期等提示由 `ApiService` 统一处理并返回 `BaseResponse`; Controller
      只写成功路径,失败即早退,不重复 Toast。
3. **取消与过期早退**
    * 遇到 `code == '4001'`(token 过期)或 `code == 'CANCELLED'` 的返回值直接 return,同时确保
      loading/刷新状态正常收尾。
4. **返回值安全使用**
    * 失败场景禁止强制解包 `response.data!`,先判空或在失败时直接 return。

### 2.7 下拉刷新显示规范

1. **刷新不替换全屏 loading**
    * 下拉刷新过程中,不使用全屏 loading 替换内容,避免页面闪动。
    * 全屏 loading 仅用于首次加载(列表为空且非刷新中)。
2. **判断 RefreshController.isRefresh**
    * 通过 `RefreshController.isRefresh` 区分初次加载与下拉刷新:

      ```dart
      final isLoading = controller.isLoading.value &&
          items.isEmpty &&
          !_refreshController.isRefresh;
      ```

### 2.8 初始化说明

    * 代码示例中如涉及 ScreenUtil 使用,应提醒开发者在 `main.dart` 中初始化:
      ```dart
      // 在 MaterialApp 的 builder 中初始化
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => child!,
      )
      ```

### 2.9 Git 命令安全规范

1. **禁止使用 Git 回退命令**
    * 未经开发者明确授权,禁止执行会直接回退工作区、暂存区或提交历史的命令,包括但不限于:
        * `git reset --hard`
        * `git checkout -- <file>`
        * `git restore --source=<commit> -- <file>`
        * `git clean -fd`

2. **禁止执行 Git 相关危险指令**
    * 未经开发者明确授权,禁止执行可能导致历史重写、数据丢失或远端覆盖的高风险命令,包括但不限于:
        * `git rebase -i`
        * `git push --force`
        * `git push --force-with-lease`
    * 如确需执行,必须先说明目的、影响范围并获得开发者确认。

---

## 3. 代码与文件结构规范

1. **禁止自动添加 example 文件**
    * 除非 **开发者主动明确要求**,否则智能体在:
        * 生成代码结构
        * 规划目录结构
        * 提出重构建议
          时,**不得新增任何 `example` 相关文件或目录**,包括但不限于:
        * `example/` 目录
        * `example_main.dart`
        * 示例工程子模块

2. **已有 example 处理**
    * 如仓库中已经存在 `example` 目录或示例文件:
        * 未经开发者明确要求,不得擅自修改或删除。
        * 如需引用其中代码,须说明「仅引用,不自动生成新的 example 结构」。

---

## 4. 代码生成与修改原则

1. **最小侵入原则**
    * 在给出修改建议时,优先采用「最小改动」方案,避免无关文件大范围改写。
    * 说明「修改位置」和「修改原因」,帮助开发者快速 review。

2. **保持与现有风格一致**
    * 命名规范、文件组织、注释风格等,尽量与项目现有代码保持一致。
    * 如需引入新工具类或新约定,建议说明理由与使用场景。

---

## 5. 文档与说明输出规范

1. **优先 Markdown**
    * 所有说明性输出,优先使用 Markdown 格式(如本文件),包括:
        * 标题(`#` `##` 等)
        * 列表(`-` 或 `1.`)
        * 代码块(使用 ``` 语言 标记)

2. **清晰的结构**
    * 建议结构顺序:背景/目的 → 规范内容 → 示例 → 注意事项。
    * 同一主题内,避免重复说明相同规则。


## 6. 扩展与维护

1. 如本项目后续新增:
    * 代码风格规范(如 lint 规则、格式化工具)
    * 特定业务领域约束
    * 特定第三方库使用约定
      等内容,应由维护者补充到本 `AGENTS.md` 文件中。

2. 智能体在发现显著的规范缺口时,可以**提出补充建议**,但不得自行更改本文件内容,需由开发者确认后更新。


### 7. 教学与代码生成规范

1. **主动按三文件结构输出 当用户要求“写一个登录页”或“生成 XXX 页面”时，必须输出三个独立文件，并用清晰注释标注文件名，例如：**

   dart
   // File: login_controller.dart
   // ... 代码

    * 优先展示关键交互链路
    * 完成三文件代码后，用一句话总结页面如何启动（Get.toNamed('/login') 或 Get.to(() => LoginPage(), binding: LoginBinding())），不再重复输出完整代码。

2. **避免过度解释**
    * 不输出“下面我们来实现…”、“这样做的原因是…”等教学废话，直接给出可运行的代码结构与必要注释。

### 8. 教学模式规范（当用户要求“教我开发”时）
   当用户明确表达“教我做”、“引导我完成”、“帮我学习”等意图时，智能体必须切换到教学模式，遵守以下规则：

1. **核心原则**
    * 不直接输出完整可运行代码
    * 分步骤提问 → 用户回答 → 给出反馈/提示/关键代码片段 → 下一步
    * 每步只给 1-2 个小任务，避免信息过载
2. **禁止行为**
    * 禁止一次性输出三个文件（Controller/Page/Binding）的完整代码
    * 禁止直接说“下面是完整代码，复制即可” 
    * 禁止跳过用户思考环节直接给出答案

3. **教学步骤模板（以 GetX 三文件页面为例）**
    * 第一步：明确目标（一句话）
      我们要做一个登录页，三文件结构：Controller、Page、Binding。
      先创建 login_controller.dart：写一个继承 GetxController 的类，定义邮箱和密码两个响应式变量（用 .obs）。你试试看？

    * 第二步：用户写出代码后，智能体检查并补充
      你的代码正确。接下来在 Controller 里写一个 login() 方法，打印邮箱和密码的值。

    * 第三步：给出关键片段（非全量）
      Page 文件要使用 GetView<LoginController>，build 方法里返回一个带输入框的页面。
      输入框绑定 controller.email 的方式：
     
     ```dart
      TextField(onChanged: (v) => controller.email.value = v)
     ```
      请你试着完成这个 Page。

    * 第四步：用户完成后，再引导 Binding 和路由注册

      现在创建 login_binding.dart：实现 Bindings，用 Get.lazyPut 注入 Controller。写完后告诉我。

    * 第五步：总结关键知识点（1-2 句话）
      记住：GetView 省去了 Get.find()，Binding 里用 lazyPut 实现懒加载。

4. **退出教学模式**
      用户说“直接给我代码”或“不用教了，我要最终版”时，切回普通模式（按原有 AGENTS.md 输出）
      教学模式结束后，可问一句“还需要继续学下一个页面吗？”
---

## 附录:快速参考

### GetX 常用 API

* 状态管理:`GetxController`、`.obs`、`Obx()`、`GetBuilder()`
* 路由:`Get.to()`、`Get.back()`、`Get.off()`、`Get.offAll()`
* 依赖注入:`Get.put()`、`Get.lazyPut()`、`Get.find()`
* 工具:`Get.dialog()`、`Get.bottomSheet()`

### flutter_screenutil 常用后缀

* `.w` - 宽度适配

* `.h` - 高度适配
* `.sp` - 字体大小适配
* `.r` - 最小值适配(常用于圆角)
* `.sw` - 屏幕宽度百分比
* `.sh` - 屏幕高度百分比