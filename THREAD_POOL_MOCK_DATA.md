# 线程池监控模拟数据重构说明

**作者**: eachann  
**创建时间**: 2024/12/19  
**项目**: panis-boot

## 概述

本次重构将线程池监控的模拟数据完全基于 `ThreadPoolStats` 数据结构进行重新设计，创建了 8 个不同类型的线程池实例，每个实例都包含完整的 `ThreadPoolStats` 字段数据。

## 模拟数据详情

### 1. 异步任务执行器 (asyncTaskExecutor)

```java
{
  "poolName": "asyncTaskExecutor",
  "poolAliasName": "异步任务执行器",
  "corePoolSize": 10,
  "maximumPoolSize": 20,
  "keepAliveTime": 60000,
  "queueType": "LinkedBlockingQueue",
  "queueCapacity": 100,
  "queueSize": 15,
  "fair": false,
  "queueRemainingCapacity": 85,
  "activeCount": 8,
  "taskCount": 1600,
  "completedTaskCount": 1500,
  "largestPoolSize": 20,
  "poolSize": 12,
  "waitTaskCount": 15,
  "rejectCount": 5,
  "rejectHandlerName": "AbortPolicy",
  "dynamic": false,
  "runTimeoutCount": 2,
  "queueTimeoutCount": 1,
  "tps": 150.5,
  "maxRt": 5000,
  "minRt": 50,
  "avg": 250.0,
  "tp50": 200.0,
  "tp75": 300.0,
  "tp90": 400.0,
  "tp95": 450.0,
  "tp99": 480.0,
  "tp999": 495.0
}
```

**特点**: 用于处理异步任务，队列容量较大，任务处理相对稳定。

### 2. HTTP 请求线程池 (httpRequestExecutor)

```java
{
  "poolName": "httpRequestExecutor",
  "poolAliasName": "HTTP请求线程池",
  "corePoolSize": 20,
  "maximumPoolSize": 50,
  "keepAliveTime": 30000,
  "queueType": "ArrayBlockingQueue",
  "queueCapacity": 200,
  "queueSize": 45,
  "fair": false,
  "queueRemainingCapacity": 155,
  "activeCount": 28,
  "taskCount": 3200,
  "completedTaskCount": 3100,
  "largestPoolSize": 50,
  "poolSize": 35,
  "waitTaskCount": 25,
  "rejectCount": 8,
  "rejectHandlerName": "CallerRunsPolicy",
  "dynamic": false,
  "runTimeoutCount": 5,
  "queueTimeoutCount": 3,
  "tps": 320.8,
  "maxRt": 8000,
  "minRt": 80,
  "avg": 180.0,
  "tp50": 150.0,
  "tp75": 200.0,
  "tp90": 250.0,
  "tp95": 280.0,
  "tp99": 320.0,
  "tp999": 350.0
}
```

**特点**: 处理 HTTP 请求，线程数较多，使用 CallerRunsPolicy 避免任务丢失。

### 3. 数据库连接池 (dbConnectionPool)

```java
{
  "poolName": "dbConnectionPool",
  "poolAliasName": "数据库连接池",
  "corePoolSize": 5,
  "maximumPoolSize": 15,
  "keepAliveTime": 120000,
  "queueType": "SynchronousQueue",
  "queueCapacity": 0,
  "queueSize": 0,
  "fair": true,
  "queueRemainingCapacity": 0,
  "activeCount": 6,
  "taskCount": 800,
  "completedTaskCount": 780,
  "largestPoolSize": 15,
  "poolSize": 8,
  "waitTaskCount": 2,
  "rejectCount": 1,
  "rejectHandlerName": "AbortPolicy",
  "dynamic": true,
  "runTimeoutCount": 0,
  "queueTimeoutCount": 0,
  "tps": 80.2,
  "maxRt": 3000,
  "minRt": 30,
  "avg": 120.0,
  "tp50": 100.0,
  "tp75": 120.0,
  "tp90": 150.0,
  "tp95": 180.0,
  "tp99": 220.0,
  "tp999": 280.0
}
```

**特点**: 数据库连接池，使用 SynchronousQueue，动态线程池，响应时间相对稳定。

### 4. 文件处理线程池 (fileProcessExecutor)

```java
{
  "poolName": "fileProcessExecutor",
  "poolAliasName": "文件处理线程池",
  "corePoolSize": 8,
  "maximumPoolSize": 16,
  "keepAliveTime": 45000,
  "queueType": "LinkedBlockingQueue",
  "queueCapacity": 50,
  "queueSize": 8,
  "fair": false,
  "queueRemainingCapacity": 42,
  "activeCount": 9,
  "taskCount": 1200,
  "completedTaskCount": 1150,
  "largestPoolSize": 16,
  "poolSize": 12,
  "waitTaskCount": 8,
  "rejectCount": 3,
  "rejectHandlerName": "DiscardOldestPolicy",
  "dynamic": false,
  "runTimeoutCount": 1,
  "queueTimeoutCount": 0,
  "tps": 120.5,
  "maxRt": 6000,
  "minRt": 60,
  "avg": 350.0,
  "tp50": 280.0,
  "tp75": 320.0,
  "tp90": 380.0,
  "tp95": 420.0,
  "tp99": 480.0,
  "tp999": 520.0
}
```

**特点**: 处理文件操作，使用 DiscardOldestPolicy，响应时间较长但稳定。

### 5. 定时任务线程池 (scheduledTaskExecutor)

```java
{
  "poolName": "scheduledTaskExecutor",
  "poolAliasName": "定时任务线程池",
  "corePoolSize": 3,
  "maximumPoolSize": 8,
  "keepAliveTime": 90000,
  "queueType": "DelayQueue",
  "queueCapacity": 100,
  "queueSize": 5,
  "fair": false,
  "queueRemainingCapacity": 95,
  "activeCount": 3,
  "taskCount": 500,
  "completedTaskCount": 495,
  "largestPoolSize": 8,
  "poolSize": 5,
  "waitTaskCount": 3,
  "rejectCount": 0,
  "rejectHandlerName": "AbortPolicy",
  "dynamic": true,
  "runTimeoutCount": 0,
  "queueTimeoutCount": 0,
  "tps": 50.0,
  "maxRt": 2000,
  "minRt": 20,
  "avg": 80.0,
  "tp50": 60.0,
  "tp75": 70.0,
  "tp90": 85.0,
  "tp95": 95.0,
  "tp99": 110.0,
  "tp999": 130.0
}
```

**特点**: 处理定时任务，使用 DelayQueue，动态线程池，响应时间最短。

### 6. 消息处理线程池 (messageProcessExecutor)

```java
{
  "poolName": "messageProcessExecutor",
  "poolAliasName": "消息处理线程池",
  "corePoolSize": 15,
  "maximumPoolSize": 30,
  "keepAliveTime": 40000,
  "queueType": "LinkedBlockingQueue",
  "queueCapacity": 150,
  "queueSize": 25,
  "fair": false,
  "queueRemainingCapacity": 125,
  "activeCount": 18,
  "taskCount": 2800,
  "completedTaskCount": 2750,
  "largestPoolSize": 30,
  "poolSize": 22,
  "waitTaskCount": 20,
  "rejectCount": 6,
  "rejectHandlerName": "CallerRunsPolicy",
  "dynamic": false,
  "runTimeoutCount": 3,
  "queueTimeoutCount": 2,
  "tps": 280.3,
  "maxRt": 7000,
  "minRt": 70,
  "avg": 200.0,
  "tp50": 160.0,
  "tp75": 180.0,
  "tp90": 220.0,
  "tp95": 250.0,
  "tp99": 290.0,
  "tp999": 320.0
}
```

**特点**: 处理消息队列，中等规模线程池，使用 CallerRunsPolicy。

### 7. 缓存更新线程池 (cacheUpdateExecutor)

```java
{
  "poolName": "cacheUpdateExecutor",
  "poolAliasName": "缓存更新线程池",
  "corePoolSize": 6,
  "maximumPoolSize": 12,
  "keepAliveTime": 35000,
  "queueType": "ArrayBlockingQueue",
  "queueCapacity": 80,
  "queueSize": 12,
  "fair": false,
  "queueRemainingCapacity": 68,
  "activeCount": 7,
  "taskCount": 900,
  "completedTaskCount": 880,
  "largestPoolSize": 12,
  "poolSize": 9,
  "waitTaskCount": 10,
  "rejectCount": 2,
  "rejectHandlerName": "DiscardPolicy",
  "dynamic": false,
  "runTimeoutCount": 1,
  "queueTimeoutCount": 1,
  "tps": 90.1,
  "maxRt": 4000,
  "minRt": 40,
  "avg": 150.0,
  "tp50": 120.0,
  "tp75": 135.0,
  "tp90": 160.0,
  "tp95": 180.0,
  "tp99": 210.0,
  "tp999": 240.0
}
```

**特点**: 处理缓存更新，使用 DiscardPolicy，响应时间中等。

### 8. 日志处理线程池 (logProcessExecutor)

```java
{
  "poolName": "logProcessExecutor",
  "poolAliasName": "日志处理线程池",
  "corePoolSize": 4,
  "maximumPoolSize": 10,
  "keepAliveTime": 25000,
  "queueType": "LinkedBlockingQueue",
  "queueCapacity": 60,
  "queueSize": 8,
  "fair": false,
  "queueRemainingCapacity": 52,
  "activeCount": 5,
  "taskCount": 600,
  "completedTaskCount": 590,
  "largestPoolSize": 10,
  "poolSize": 7,
  "waitTaskCount": 6,
  "rejectCount": 1,
  "rejectHandlerName": "AbortPolicy",
  "dynamic": false,
  "runTimeoutCount": 0,
  "queueTimeoutCount": 0,
  "tps": 60.0,
  "maxRt": 2500,
  "minRt": 25,
  "avg": 100.0,
  "tp50": 80.0,
  "tp75": 90.0,
  "tp90": 110.0,
  "tp95": 125.0,
  "tp99": 145.0,
  "tp999": 165.0
}
```

**特点**: 处理日志记录，小规模线程池，响应时间较短。

## 数据结构特点

### 1. 队列类型分布

- **LinkedBlockingQueue**: 4 个线程池（异步任务、文件处理、消息处理、日志处理）
- **ArrayBlockingQueue**: 2 个线程池（HTTP 请求、缓存更新）
- **SynchronousQueue**: 1 个线程池（数据库连接池）
- **DelayQueue**: 1 个线程池（定时任务）

### 2. 拒绝策略分布

- **AbortPolicy**: 4 个线程池（异步任务、数据库连接、定时任务、日志处理）
- **CallerRunsPolicy**: 2 个线程池（HTTP 请求、消息处理）
- **DiscardOldestPolicy**: 1 个线程池（文件处理）
- **DiscardPolicy**: 1 个线程池（缓存更新）

### 3. 动态线程池

- **动态线程池**: 2 个（数据库连接池、定时任务线程池）
- **普通线程池**: 6 个

### 4. 性能指标特点

- **TPS 范围**: 50.0 - 320.8
- **响应时间范围**: 20ms - 8000ms
- **平均响应时间**: 80ms - 350ms
- **百分位指标**: 完整的 TP50-TP999 数据

## 功能增强

### 1. 数据过滤功能

```java
private List<ThreadPoolStats> filterThreadPools(List<ThreadPoolStats> threadPools, MonThreadPoolBO monThreadPoolBO) {
    // 支持按线程池名称模糊搜索
    // 支持按队列类型精确匹配
    // 支持按动态线程池类型筛选
}
```

### 2. 统计汇总功能

```java
public ThreadPoolStats getStatistics() {
    // 计算所有线程池的汇总数据
    // 包括总线程池数、总活跃线程数、总任务数等
}
```

### 3. 辅助方法

```java
private ThreadPoolStats createThreadPoolStats(...) {
    // 统一的线程池数据创建方法
    // 包含所有ThreadPoolStats字段的设置
}
```

## 使用场景

### 1. 开发测试

- 提供完整的模拟数据用于前端开发
- 支持各种查询条件的测试
- 模拟真实的线程池监控场景

### 2. 功能演示

- 展示不同线程池类型的特点
- 演示各种性能指标的含义
- 验证监控功能的完整性

### 3. 性能测试

- 测试大量数据的展示性能
- 验证分页功能的正确性
- 测试搜索过滤的性能

## 数据特点总结

1. **完整性**: 每个线程池实例都包含完整的 ThreadPoolStats 字段
2. **多样性**: 8 个不同类型的线程池，覆盖常见使用场景
3. **真实性**: 数据值符合实际生产环境的合理范围
4. **可测试性**: 支持各种查询条件和统计功能
5. **可扩展性**: 易于添加新的线程池类型和字段

这次重构为线程池监控功能提供了丰富、真实、完整的模拟数据，能够很好地支持前端开发和功能测试。
