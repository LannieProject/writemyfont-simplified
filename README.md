# 简体字体生成器

一个可以直接在浏览器中手写并生成简体中文 OTF 字体的工具。

🔗 **在线使用：**  
https://lannieproject.github.io/writemyfont-simplified/

本项目基于 ButTaiwan 的开源项目 [writemyfont](https://github.com/ButTaiwan/writemyfont) 进行修改和扩展，主要增加了简体中文字符集、《通用规范汉字表》支持以及简体中文界面。

---

## 简体中文支持

目前字表支持《通用规范汉字表》全部 **8105 个汉字**：

| 字表 | 字数 | 累计覆盖 |
| --- | ---: | ---: |
| 测试字 | 50 | 用于功能测试 |
| 一级字 | 3500 | 3500 |
| 二级字 | 3000 | 6500 |
| 三级字 | 1605 | 8105 |

一级、二级、三级分别显示，避免一次面对过多书写页面。

字符按照 Unicode 与字体 glyph 对应，同一个字符只需要书写一次。

---

## 功能

- 浏览器中直接手写字体
- 支持 iPad 和 Apple Pencil
- 支持笔刷与橡皮擦
- 支持撤销
- 支持字形位置调整
- 支持多种书写辅助格线
- 支持笔压与触控笔倾斜角
- 使用 IndexedDB 在浏览器本地保存书写进度
- 支持导出和导入书写数据备份
- 支持生成 OTF 字体
- 支持《通用规范汉字表》8105 字
- 支持用户自定义字表

---

## 使用方法

1. 打开 [简体字体生成器](https://lannieproject.github.io/writemyfont-simplified/)
2. 设置字体的中文名称和英文名称
3. 选择需要书写的字表
4. 使用鼠标、触控屏或 Apple Pencil 逐字书写
5. 根据需要调整字形的位置和大小
6. 定期导出书写数据进行备份
7. 完成后导出 OTF 字体文件

书写数据默认保存在当前浏览器本地，不会上传到服务器。

如果准备长期书写，建议定期导出备份，避免浏览器缓存或网站数据被清除后丢失书写进度。

---

## 字表结构

### 测试字 · 50

包含 50 个简体中文字符，用于测试字体生成流程、Unicode 映射和设备兼容性。

### 一级字 · 3500

包含《通用规范汉字表》一级字 **3500 字**。

适合作为主要书写阶段。完成后已经能够覆盖大量日常中文使用场景。

### 二级字 · 3000

包含《通用规范汉字表》二级字 **3000 字**。

完成一级字和二级字后，累计覆盖 **6500 字**。

### 三级字 · 1605

包含《通用规范汉字表》三级字 **1605 字**。

一级、二级、三级全部完成后，累计覆盖《通用规范汉字表》全部 **8105 字**。

---

## 技术

项目主要使用：

- HTML5 Canvas
- JavaScript
- IndexedDB
- potrace.js
- opentype.js
- Ruby 字表生成脚本

简体中文字符通过 Unicode 与字体 glyph 进行对应。

---

## 当前状态

简体中文版本目前已经完成：

- [x] 50 字简体中文测试字表
- [x] 一级 3500 字字表
- [x] 二级 3000 字字表
- [x] 三级 1605 字字表
- [x] 《通用规范汉字表》8105 字 Unicode 映射
- [x] 简体中文界面
- [x] iPad + Apple Pencil 手写测试
- [x] 浏览器本地保存测试
- [x] OTF 字体导出测试
- [x] 简体中文字符输入与显示测试
- [ ] 3500 字完整规模测试
- [ ] 8105 字完整规模测试

目前完整 8105 字规模仍在持续测试中。

---

## 注意事项

本工具生成的 OTF 字体并非标准 CID CJK 字体，因此部分 Adobe 软件可能无法正确识别或显示生成的字体。

不同操作系统和软件存在不同的字体缓存机制。如果反复测试修改后的字体，可以使用工具中的「测试输出」功能，让字体名称自动附加流水号，减少旧字体缓存造成的影响。

所有笔迹数据默认保存在浏览器本地。请自行做好备份。

---

## 作者

简体中文适配与维护：**Lannie**

如果你对手写字体、个人项目以及我的其他内容感兴趣，可以在这里找到我：

- [小红书：小富Lannie](https://xhslink.cn/m/6SMDVjH41AV)
- [哔哩哔哩：小富Lannie](https://b23.tv/WfQ2pEt)
- [YouTube：@LannieWang](https://www.youtube.com/@LannieWang)
- [GitHub：@LannieProject](https://github.com/LannieProject)

---

## Credits

本项目基于 ButTaiwan 的开源项目：

[ButTaiwan/writemyfont](https://github.com/ButTaiwan/writemyfont)

感谢原项目作者及相关开源项目贡献者。

Simplified Chinese adaptation by **Lannie**.

---

## 开源许可

本项目基于 ButTaiwan 的开源项目 [writemyfont](https://github.com/ButTaiwan/writemyfont) 修改。

相关开源许可请参阅 [LICENSE](LICENSE)。
