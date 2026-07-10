## 问题
warm-flow save-xml 接口(/flow/warm-flow/save-xml)报: Error on line 4 of document : 前言中不允许有内容

## 根因
warm-flow 的 DefService.saveXml(Long, String) 把入参 xmlString 用 getBytes(UTF_8) 转 byte[] 后, 交给 FlowConfigUtil.readDocument -> new SAXReader().read(InputStream) 解析。dom4j SAXReader 不处理 UTF-8 BOM(EF BB BF / U+FEFF) 与 prolog 之前的任何内容(空白/换行/注释/垃圾文本), 一旦前端传来的 xml 开头有这些内容就报 "前言中不允许有内容"(Content is not allowed in prolog)。"line 4" 说明前 3 行有内容, 第 4 行才到 <?xml。
- warm-flow 内部 saveXml 已用 StandardCharsets.UTF_8, 编码本身没问题, 缺的是 BOM/前导内容剥离。
- 此为 warm-flow jar 内实现, 无法直接改源码。

## 变更
新增 integrity-modules/integrity-flow/src/main/java/com/integrity/flow/config/WarmFlowXmlRequestBodyAdvice.java:
- @RestControllerAdvice + RequestBodyAdvice, supports 匹配 org.dromara.warm.flow.ui.dto.DefDto
- afterBodyRead 阶段对 DefDto.xmlString / jsonString 调 clean()
- clean(): 从开头跳过所有非合法起始字符(BOM、空白、垃圾文本), 直到遇到 '<' / '{' / '[', stripTrailing 收尾, 并 warn 日志记录剥离字符数

## 验证
启动 integrity-flow(9204), 直连 /warm-flow/save-xml:
1. 带 BOM(U+FEFF) + 3 行空白 + xml 的入参 -> {"code":200,"msg":"操作成功","data":null} (清洗生效)
2. 纯净 xml(无 BOM) -> {"code":200,"msg":"操作成功","data":null} (不误伤)
启动日志确认: ControllerAdvice beans: 2 RequestBodyAdvice (内置1 + 本advice1)
Nacos 配置正常加载达梦数据源, HikariPool 连接达梦成功。

## 风险
- advice 只对 DefDto 生效(supports 限定), 不影响其它请求体。
- clean 剥离 prolog 前内容是 XML 规范允许的兜底(合法 XML 本就不该有 prolog 前内容), 不会破坏合法 xml。
- 若前端传的根本不是 xml(而是错误内容), clean 会在找不到 < 时返回原值, warm-flow 仍会报错, 但错误信息会更准确。
- 残留: 实际前端为何传入带 BOM/前导内容的 xml 未从后端侧定位(可能前端编辑器/导出文件带 BOM), 但后端兜底已覆盖。
