## 现象
工作流编辑页修改后点保存，修改内容未保存。

## 排查
初判 suspect: warm-flow saveBatch 的 <choose> 在 dataSourceType 非 oracle 时走 mysql_insert_batch(多行 VALUES), 达梦可能不支持。
验证达梦批量插入语法:
  - MySQL 多行 VALUES: INSERT INTO BATCH_PROBE VALUES (1,'a'),(2,'b') => 达梦 OK
  - Oracle UNION ALL: INSERT INTO BATCH_PROBE SELECT 1,'a' UNION ALL SELECT 2,'b' => 达梦 OK, rows=3
结论: 达梦两种批量插入语法都支持, saveBatch 数据库侧无障碍。

## 实测复现与验证 (flow 服务 9204)
1. 取已有流程 xml (warm-flow/xml-string/{id}) 成功
2. 改节点名(中间节点-或签2 -> 中间节点-已修改V2), POST warm-flow/save-xml => 200 操作成功
3. 立即重新取 xml => 内容包含 "已修改V2" => 保存成功
4. 直查达梦 FLOW_NODE 表 => approval 节点 name 已为修改后的值; 4 节点 3 跳转齐全 => saveBatch 正常落库

## 真实根因
之前"修改未保存"是上一阶段的 save-xml 报 "前言中不允许有内容"(XML prolog BOM/前导内容)导致解析失败、根本没走到 saveNodeAndSkip 保存逻辑。
本会话上一轮已新增 WarmFlowXmlRequestBodyAdvice(integrity-flow) 对 DefDto.xmlString 清洗 BOM/前导内容, save-xml 解析通过后, 修改随之正常落库。
即: 这个 task 的现象其实已被前一个 task (fix-warmflow-save-xml-prolog, commit a39c7d0) 解决, 本 task 仅做实测确认。

## 结论
无需新增变更。warm-flow 在达梦下 saveBatch/remove/save 均正常工作。
建议: warm-flow.data_source_type 保持默认(null 走 mysql 语法), 因达梦支持多行 VALUES, 无需改 oracle。如未来某场景 Oracle 语法更稳, 可配 warm-flow.data_source_type=oracle 兜底(已验证达梦兼容 Oracle UNION ALL 语法)。
