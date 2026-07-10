## 问题
mybatis-plus 3.5.17 的 MybatisMapperAnnotationBuilder 调用 org.apache.ibatis.session.Configuration.parsePendingMethods(boolean), 但运行时加载的是旧版 mybatis(3.5.15), 该方法不存在, 抛 NoSuchMethodError 启动失败。

## 根因
- mybatis-plus 3.5.17 期望 mybatis 3.5.19, 但传递依赖拉入旧版 mybatis:
  - dynamic-datasource-spring-boot3-starter(integrity-common-datasource) 传 mybatis-spring-boot-starter:2.3.2 -> mybatis:3.5.14
  - pagehelper:6.1.0(integrity-common-core) 传 pagehelper-spring-boot-starter:2.1.0 -> mybatis-spring-boot-starter:2.3.2 -> mybatis:3.5.14/3.5.15
  - warm-flow-mybatis-sb-starter(integrity-flow) 传 mybatis:3.5.15
- 实测确认: parsePendingMethods(boolean) 仅存在于 mybatis 3.5.19; 3.5.15 无此方法

## 变更
1. integrity-common-datasource/pom.xml: dynamic-datasource 依赖排除 mybatis-spring-boot-starter 与 mybatis
2. integrity-common-core/pom.xml: pagehelper 依赖排除 pagehelper-spring-boot-starter 与 mybatis-spring-boot-starter
3. pom.xml(根): dependencyManagement 新增 org.mybatis:mybatis:3.5.19 锁定版本兜底

## 验证
- mvn dependency:tree (system/flow/job/gen) 均显示 mybatis:3.5.19, mybatis-spring-boot-starter 消失
  - flow: warm-flow 传的 3.5.15 被 managed 升到 3.5.19 (version managed from 3.5.15)
- mvn compile integrity-system: BUILD SUCCESS
- pagehelper 6.1.0 保留(仅排除其传递的 starter), PageInterceptor 自动装配在 MybatisPlusConfig 已有 @Bean

## 风险
- pagehelper-spring-boot-starter 被排除后, PageHelper 的 SpringBoot 自动配置(PageHelperAutoConfiguration)不再生效。但项目已在 MybatisPlusConfig 手动声明 PageInterceptor @Bean, PageHelper 拦截器仍会被注入, 不依赖 starter 自动装配。需启动后实测分页接口确认。
- warm-flow 在 flow 模块仍用其自己的 mybatis 集成, mybatis 版本被统一到 3.5.19, 与 mybatis-plus 共存。需启动 flow 模块确认无重复 SqlSessionFactory 装配冲突(若有需进一步排除 warm-flow 的 mybatis 集成或显式声明 @Primary)。

## 双模型外部审查
本环境 antigravity(agy not found) 与 claude(wrapper 挂死) 均不可用, 已记录, 以依赖树实测 + 编译验证替代。
