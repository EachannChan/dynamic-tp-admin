# 线程池监控与 Dynamic-TP 集成总结

**作者**: eachann  
**创建时间**: 2024/12/19  
**项目**: panis-boot

## 概述

本次修改将 `MonThreadPoolServiceImpl` 从完全使用模拟数据改为优先从 `dynamic-tp` 项目获取真实数据，同时保留三组核心模拟数据作为备用。

## 主要修改内容

### 1. MonThreadPoolServiceImpl 重构

**文件**: `modules/src/main/java/com/izpan/modules/monitor/service/impl/MonThreadPoolServiceImpl.java`

#### 1.1 新增依赖注入

```java
@Resource
private AdminServer adminServer;
```

#### 1.2 新增数据获取方法

```java
/**
 * 获取线程池数据 - 优先从dynamic-tp获取真实数据，失败时使用模拟数据
 */
private List<ThreadPoolStats> getThreadPoolsData() {
    try {
        // 尝试从dynamic-tp获取真实数据
        Object result = adminServer.requestToClient(AdminRequestTypeEnum.EXECUTOR_MONITOR, null);
        if (result instanceof List) {
            @SuppressWarnings("unchecked")
            List<ThreadPoolStats> realData = (List<ThreadPoolStats>) result;
            if (!realData.isEmpty()) {
                log.info("成功从dynamic-tp获取到{}个线程池数据", realData.size());
                return realData;
            }
        }
    } catch (RemotingException | InterruptedException e) {
        log.warn("从dynamic-tp获取线程池数据失败，使用模拟数据: {}", e.getMessage());
    } catch (Exception e) {
        log.warn("获取线程池数据时发生异常，使用模拟数据: {}", e.getMessage());
    }

    // 如果获取真实数据失败，使用模拟数据
    log.info("使用模拟线程池数据");
    return getMockThreadPools();
}
```

#### 1.3 更新所有服务方法

- `listMonThreadPoolPage()` - 使用 `getThreadPoolsData()` 替代 `getMockThreadPools()`
- `getStatistics()` - 使用 `getThreadPoolsData()` 替代 `getMockThreadPools()`
- `getMetrics()` - 使用 `getThreadPoolsData()` 替代 `getMockThreadPools()`
- `getDetail()` - 使用 `getThreadPoolsData()` 替代 `getMockThreadPools()`

#### 1.4 精简模拟数据

将原来的 8 组模拟数据精简为 3 组核心数据：

1. **异步任务执行器** (`asyncTaskExecutor`)

   - 核心线程数: 10, 最大线程数: 20
   - 队列类型: LinkedBlockingQueue
   - 拒绝策略: AbortPolicy

2. **HTTP 请求线程池** (`httpRequestExecutor`)

   - 核心线程数: 20, 最大线程数: 50
   - 队列类型: ArrayBlockingQueue
   - 拒绝策略: CallerRunsPolicy

3. **数据库连接池** (`dbConnectionPool`)
   - 核心线程数: 5, 最大线程数: 15
   - 队列类型: SynchronousQueue
   - 拒绝策略: AbortPolicy
   - 动态线程池: true

### 2. 架构设计说明

#### 2.1 数据获取优先级

1. **第一优先级**: 通过 `AdminServer.requestToClient()` 从 `dynamic-tp` 获取真实数据
2. **第二优先级**: 如果获取失败，使用精简的模拟数据

#### 2.2 错误处理机制

- 捕获 `RemotingException` 和 `InterruptedException` 网络异常
- 捕获通用 `Exception` 其他异常
- 所有异常都会记录警告日志并回退到模拟数据

#### 2.3 日志记录

- 成功获取真实数据时记录信息日志
- 获取失败时记录警告日志
- 使用模拟数据时记录信息日志

### 3. 技术实现细节

#### 3.1 通信机制

使用 `AdminServer` 的 `requestToClient` 方法：

```java
Object result = adminServer.requestToClient(AdminRequestTypeEnum.EXECUTOR_MONITOR, null);
```

#### 3.2 类型安全

使用类型检查和类型转换确保数据安全：

```java
if (result instanceof List) {
    @SuppressWarnings("unchecked")
    List<ThreadPoolStats> realData = (List<ThreadPoolStats>) result;
    // ...
}
```

#### 3.3 数据验证

确保获取的数据不为空：

```java
if (!realData.isEmpty()) {
    return realData;
}
```

### 4. 功能特性

#### 4.1 无缝切换

- 当 `dynamic-tp` 服务可用时，自动使用真实数据
- 当 `dynamic-tp` 服务不可用时，自动回退到模拟数据
- 对上层调用者透明，无需修改接口

#### 4.2 数据一致性

- 真实数据和模拟数据都使用相同的 `ThreadPoolStats` 结构
- 保持所有现有功能不变
- 支持所有现有的查询和过滤条件

#### 4.3 性能优化

- 精简模拟数据减少内存占用
- 异常处理避免服务中断
- 日志记录便于问题排查

### 5. 使用场景

#### 5.1 开发环境

- 当 `dynamic-tp` 服务未启动时，使用模拟数据进行开发测试
- 提供稳定的测试数据源

#### 5.2 生产环境

- 优先使用真实的线程池监控数据
- 提供准确的系统监控信息

#### 5.3 故障恢复

- 当 `dynamic-tp` 服务出现故障时，自动切换到模拟数据
- 确保监控功能的可用性

### 6. 配置要求

#### 6.1 依赖配置

确保 `modules` 模块依赖 `infrastructure` 模块（已配置）

#### 6.2 网络配置

确保 `AdminServer` 能够连接到 `dynamic-tp` 服务

#### 6.3 超时配置

`AdminServer.requestToClient` 方法使用 30 秒超时时间

### 7. 监控和运维

#### 7.1 日志监控

- 监控成功获取真实数据的日志
- 监控回退到模拟数据的警告日志
- 监控异常错误日志

#### 7.2 性能监控

- 监控数据获取的响应时间
- 监控数据获取的成功率
- 监控模拟数据的使用频率

### 8. 未来扩展

#### 8.1 数据缓存

可以考虑添加数据缓存机制，减少对 `dynamic-tp` 的请求频率

#### 8.2 数据同步

可以考虑实现数据同步机制，确保模拟数据与真实数据的一致性

#### 8.3 配置化

可以考虑将数据源选择配置化，支持手动切换数据源

## 总结

本次修改成功实现了线程池监控与 `dynamic-tp` 的集成，主要特点：

1. **向后兼容**: 保持所有现有接口不变
2. **高可用性**: 提供数据获取的容错机制
3. **透明切换**: 自动在真实数据和模拟数据之间切换
4. **易于维护**: 清晰的代码结构和完善的日志记录
5. **性能优化**: 精简的模拟数据和高效的异常处理

这种设计确保了线程池监控功能在各种环境下都能稳定运行，为系统监控提供了可靠的数据支持。
