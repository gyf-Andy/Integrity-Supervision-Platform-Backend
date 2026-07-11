## 现象
工作流编辑页修改后点保存，后端 save-xml 返回 200 但内容未落库。
日志: warm-flow 入参剥离 45 个字符后剩 0，cleanedXml 为空。
被剥离内容: submit/approval/end 等节点名文本。

## 真正根因（达梦无关）
请求经 gateway (localhost:81 -> gateway)。XssFilter 对 JSON 请求体调 EscapeUtil.clean(bodyStr)，
EscapeUtil.clean = new HTMLFilter().filter() => "清除所有HTML标签但不删标签内内容"。
前端传的 xmlString 是完整合法 XML(<?xml><definition>...<skip>submit</skip>...)，
经 XssFilter 后所有 <...> 被当 HTML 标签剥掉，只剩标签内文本(submit/approval/end)。
flow 收到的 xmlString 仅 45 字符纯文本，非 XML：
  - 之前 advice(清空版) 把它清空 -> saveXml 检测空串直接 return -> 假成功无操作
  - 改 advice(保留版) 后会让 warm-flow 报 XML 解析异常，但问题仍在入参残缺

## 证据
- XssFilter.requestDecorator.body: bodyStr = EscapeUtil.clean(bodyStr) (XssFilter.java)
- EscapeUtil.clean: return new HTMLFilter().filter(content) (EscapeUtil.java)
- 日志被剥离内容正好是 XML 中 <skip>submit</skip>/<skip>approval</skip> 标签内文本
- 前端实际入参是一段完整 <?xml ...><definition>...</definition> (用户提供)

## 变更
Nacos 中 integrity-gateway-dev.yml 的 security.xss.excludeUrls 新增:
  - /flow/warm-flow/**
覆盖 save-xml/save-json/xml-string/json-string 等所有 warm-flow 接口，跳过 XSS 过滤。
工作流 XML/JSON 内容天然带 <> 标签，不应被当 HTML 过滤。
XssProperties 有 @RefreshScope，Nacos 配置变更 gateway 自动刷新。
推送验证: POST /nacos/v2/cs/config => code=0 success，拉回确认 excludeUrls 含 /flow/warm-flow/**

## WarmFlowXmlRequestBodyAdvice 处置
保留(位于 integrity-flow)，作为兜底：
- 完整 XML 以 < 开头时不剥离任何字符(遇首个 < 立即停止)
- 仅对真正的 BOM/前导空白剥离
- 不再静默清空非 XML 内容(无 < 时保留原值让 warm-flow 自己报错)
- 含诊断 warn 日志便于后续确认

## 验证状态
配置已推到 Nacos。需用户重启/刷新 gateway 后在前端再次保存确认。
预期: 前端完整 XML 原样到达 flow，saveXml 正常解析，修改落库。

## 风险
- 放行 /flow/warm-flow/** 不过 XSS：工作流 xml 内容由业务用户录入，非公开输入，XSS 风险低；
  warm-flow 内部 dom4j 解析 XML 不会执行其中脚本；可接受。
- 若后续有其它带 XML/HTML 内容的接口被 XSS 误伤，按同模式加 excludeUrls。
