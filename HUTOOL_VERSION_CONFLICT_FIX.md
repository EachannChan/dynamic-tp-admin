# Hutool 版本冲突问题解决方案

## 问题描述

项目在登录时出现以下错误：

```
Caused by: java.lang.NoSuchMethodError: 'java.lang.Object cn.hutool.core.convert.NumberWithFormat.getNumber()'
```

## 问题原因

通过分析项目依赖树，发现存在 Hutool 版本冲突：

- 大部分 Hutool 组件版本：`5.8.38`
- `dynamic-tp-common` 依赖引入的版本：`5.8.25`

具体冲突的依赖：

```
org.dromara.dynamictp:dynamic-tp-common:jar:1.2.3:compile
    +- cn.hutool:hutool-http:jar:5.8.25:compile
    |  \- cn.hutool:hutool-core:jar:5.8.25:compile
```

这种版本不一致导致了 `NoSuchMethodError` 错误，因为编译时使用的是 `5.8.38` 版本的 API，但运行时加载的是 `5.8.25` 版本的类。

## 解决方案

### 1. 在根 pom.xml 中添加版本管理

在 `<properties>` 部分添加 Hutool 版本定义：

```xml
<hutool.version>5.8.38</hutool.version>
```

### 2. 在 dependencyManagement 中统一管理核心 Hutool 组件版本

```xml
<!-- Hutool 版本统一管理 -->
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-core</artifactId>
    <version>${hutool.version}</version>
</dependency>
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-http</artifactId>
    <version>${hutool.version}</version>
</dependency>
```

**说明**：只需要声明核心的 `hutool-core` 和冲突的 `hutool-http` 即可。其他 Hutool 组件会通过传递依赖自动使用统一版本。

### 3. 清理并重新编译项目

```bash
mvn clean compile
```

## 验证结果

修复后的依赖树显示所有 Hutool 组件都统一为 `5.8.38` 版本：

```
[INFO] |  +- cn.hutool:hutool-extra:jar:5.8.38:compile
[INFO] |  |  +- cn.hutool:hutool-core:jar:5.8.38:compile
[INFO] |  |  \- cn.hutool:hutool-setting:jar:5.8.38:compile
[INFO] |  |     \- cn.hutool:hutool-log:jar:5.8.38:compile
[INFO] |  +- cn.hutool:hutool-crypto:jar:5.8.38:compile
[INFO] |  +- cn.hutool:hutool-jwt:jar:5.8.38:compile
[INFO] |     \- cn.hutool:hutool-json:jar:5.8.38:compile
[INFO]    +- cn.hutool:hutool-http:jar:5.8.38:compile
[INFO]    |  \- cn.hutool:hutool-core:jar:5.8.38:compile
```

## 技术原理

### 1. Maven 依赖管理机制

- `dependencyManagement` 用于统一管理依赖版本
- 子模块继承父模块的版本管理
- 强制覆盖传递依赖的版本

### 2. 版本冲突的原因

- 传递依赖引入了不同版本的相同组件
- 编译时使用一个版本，运行时加载另一个版本
- 导致 `NoSuchMethodError` 或 `ClassNotFoundException`

### 3. 解决方案的优势

- **统一版本**：确保所有模块使用相同版本的 Hutool
- **避免冲突**：消除版本不一致导致的运行时错误
- **易于维护**：集中管理版本，便于升级和维护

## 预防措施

### 1. 定期检查依赖冲突

```bash
mvn dependency:tree | grep -i hutool
```

### 2. 使用 Maven 插件检测冲突

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-enforcer-plugin</artifactId>
    <version>3.4.1</version>
    <executions>
        <execution>
            <id>enforce-versions</id>
            <goals>
                <goal>enforce</goal>
            </goals>
            <configuration>
                <rules>
                    <requireUpperBoundDeps/>
                    <banDuplicatePomDependencyVersions/>
                </rules>
            </configuration>
        </execution>
    </executions>
</plugin>
```

### 3. 在 CI/CD 中添加依赖检查

在构建流程中添加依赖冲突检查，确保不会引入版本冲突。

## 总结

通过统一管理 Hutool 组件版本，成功解决了 `NoSuchMethodError` 错误。这种解决方案：

1. **彻底解决问题**：消除了版本冲突的根本原因
2. **保持兼容性**：不影响现有功能
3. **便于维护**：集中管理版本，便于后续升级
4. **预防未来问题**：建立了版本管理机制，避免类似问题再次发生

建议在项目中建立完善的依赖管理机制，定期检查和更新依赖版本，确保项目的稳定性和可维护性。
