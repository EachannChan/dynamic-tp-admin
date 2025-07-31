# 多客户端线程池监控功能说明

## 概述

本次更新将线程池监控功能重构为支持多客户端，专门适配 Dynamic-TP SDK 的 AdminClient 客户端。现在可以从多个连接的 Dynamic-TP AdminClient 同时获取线程池数据，并提供统一的监控视图。

## 主要改进

### 1. 多客户端数据聚合

**之前的问题**：

- 只能从单个 Dynamic-TP AdminClient 获取线程池数据
- 无法同时监控多个应用实例的线程池
- 数据来源单一，监控范围有限
- 未充分利用 Dynamic-TP SDK 的 AdminRequestBody 结构

**现在的解决方案**：

- 支持从多个 Dynamic-TP AdminClient 同时获取线程池数据
- 自动聚合所有 AdminClient 的线程池信息
- 为每个线程池添加客户端标识，便于区分
- 正确处理 Dynamic-TP 的 AdminRequestBody 序列化和反序列化

### 2. 智能数据获取策略

**数据获取优先级**：

1. **多客户端广播**：向所有连接的 Dynamic-TP AdminClient 广播请求
2. **单客户端回退**：如果广播失败，尝试从单个 AdminClient 获取
3. **模拟数据备用**：如果所有 AdminClient 都不可用，使用模拟数据

### 3. 客户端标识管理

**线程池命名规则**：

- 原始名称：`asyncTaskExecutor`
- 多客户端标识：`asyncTaskExecutor@192.168.1.100:8080`
- 别名增强：`异步任务执行器 (192.168.1.100:8080)`

## API 接口更新

### 1. 客户端信息接口（已迁移到独立模块）

客户端信息接口已迁移到独立的客户端监控模块，请使用以下接口：

```http
# 获取客户端数量
GET /mon_client/count

# 获取客户端列表
GET /mon_client/list

# 获取客户端详细信息
GET /mon_client/info
```

**响应示例**：

```json
# GET /mon_client/count
{
  "code": 200,
  "message": "操作成功",
  "data": 3
}

# GET /mon_client/list
{
  "code": 200,
  "message": "操作成功",
  "data": [
    "192.168.1.100:8080",
    "192.168.1.101:8080",
    "192.168.1.102:8080"
  ]
}

# GET /mon_client/info
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "clientCount": 3,
    "connectedClients": [
      "192.168.1.100:8080",
      "192.168.1.101:8080",
      "192.168.1.102:8080"
    ],
    "timestamp": 1702972800000
  }
}
```

### 2. 增强的分页查询接口

**请求示例**：

```http
GET /mon_thread_pool/page?page=1&pageSize=10&poolName=asyncTaskExecutor
```

**响应示例**：

```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "records": [
      {
        "poolName": "asyncTaskExecutor@192.168.1.100:8080",
        "poolAliasName": "异步任务执行器 (192.168.1.100:8080)",
        "corePoolSize": 10,
        "maximumPoolSize": 20,
        "activeCount": 8,
        "queueSize": 15,
        "queueType": "LinkedBlockingQueue",
        "dynamic": false
      },
      {
        "poolName": "asyncTaskExecutor@192.168.1.101:8080",
        "poolAliasName": "异步任务执行器 (192.168.1.101:8080)",
        "corePoolSize": 10,
        "maximumPoolSize": 20,
        "activeCount": 12,
        "queueSize": 25,
        "queueType": "LinkedBlockingQueue",
        "dynamic": false
      }
    ],
    "total": 2,
    "size": 10,
    "current": 1,
    "pages": 1
  }
}
```

### 3. 增强的统计接口

**响应示例**：

```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "poolName": "系统汇总",
    "poolAliasName": "System Summary",
    "poolSize": 15,
    "activeCount": 45,
    "taskCount": 4800,
    "completedTaskCount": 4650,
    "rejectCount": 18
  }
}
```

## 功能特性

### 1. 智能数据聚合

```java
// 向所有 Dynamic-TP AdminClient 广播请求
List<Object> results = adminServer.broadcastToAllClients(
    AdminRequestTypeEnum.EXECUTOR_MONITOR, null);

// 处理每个 AdminClient 的响应
for (int i = 0; i < results.size(); i++) {
    Object result = results.get(i);
    String clientAddress = connectedClients.toArray(new String[0])[i];

    if (result instanceof AdminRequestBody) {
        // 处理 Dynamic-TP AdminClient 返回的 AdminRequestBody
        AdminRequestBody adminResponse = (AdminRequestBody) result;
        Object responseBody = adminResponse.deserializeBody();

        if (responseBody instanceof List) {
            List<ThreadPoolStats> clientThreadPools = (List<ThreadPoolStats>) responseBody;

            // 为每个线程池添加客户端标识
            clientThreadPools.forEach(pool -> {
                String originalName = pool.getPoolName();
                pool.setPoolName(originalName + "@" + clientAddress);
                pool.setPoolAliasName(pool.getPoolAliasName() + " (" + clientAddress + ")");
            });

            allThreadPools.addAll(clientThreadPools);
        }
    }
}
```

### 2. 高级过滤功能

支持按以下条件过滤线程池：

- **线程池名称**：支持模糊搜索，包含客户端标识
- **队列类型**：精确匹配队列类型
- **动态线程池**：筛选是否为动态线程池
- **活跃线程数**：范围过滤
- **队列使用率**：范围过滤
- **线程池使用率**：范围过滤

### 3. 错误处理和容错

```java
// 检查 Dynamic-TP AdminClient 连接状态
int clientCount = adminServer.getConnectedClientCount();
if (clientCount == 0) {
    log.warn("No Dynamic-TP AdminClient connected, using mock data");
    return getMockThreadPools();
}

// 多级容错机制
try {
    // 1. 尝试多客户端广播
    List<Object> results = adminServer.broadcastToAllClients(...);
    // 处理结果...
} catch (Exception e) {
    log.error("Failed to get thread pool data from Dynamic-TP AdminClients", e);

    // 2. 尝试单客户端获取
    try {
        Object result = adminServer.requestToClient(...);
        // 处理结果...
    } catch (Exception e2) {
        // 3. 使用模拟数据
        return getMockThreadPools();
    }
}
```

## 使用场景

### 1. 微服务架构监控

在微服务架构中，每个服务实例都有自己的 Dynamic-TP AdminClient 和线程池：

```
服务A实例1: asyncTaskExecutor@192.168.1.100:8080
服务A实例2: asyncTaskExecutor@192.168.1.101:8080
服务B实例1: httpRequestExecutor@192.168.1.102:8080
服务B实例2: httpRequestExecutor@192.168.1.103:8080
```

### 2. 集群环境监控

在集群环境中监控所有节点的线程池状态：

```bash
# 获取所有连接的客户端
curl -X GET "http://localhost:9999/mon_client/count"
curl -X GET "http://localhost:9999/mon_client/list"
curl -X GET "http://localhost:9999/mon_client/info"

# 获取所有线程池数据
curl -X GET "http://localhost:9999/mon_thread_pool/metrics"

# 按客户端过滤
curl -X GET "http://localhost:9999/mon_thread_pool/page?poolName=192.168.1.100"
```

### 3. 性能对比分析

可以对比不同客户端上相同线程池的性能：

```json
{
  "asyncTaskExecutor@192.168.1.100:8080": {
    "activeCount": 8,
    "queueSize": 15,
    "tps": 150.5
  },
  "asyncTaskExecutor@192.168.1.101:8080": {
    "activeCount": 12,
    "queueSize": 25,
    "tps": 180.2
  }
}
```

## 配置说明

### 1. 客户端连接配置

确保客户端正确连接到监控服务器：

```yaml
# 客户端配置
dynamic:
  tp:
    enabled: true
    server:
      address: 192.168.1.100:8989 # 监控服务器地址
```

### 2. 监控服务器配置

```yaml
# 监控服务器配置
server:
  port: 8989 # RPC服务器端口
```

### 3. 线程池配置

```yaml
# 线程池配置
dynamic:
  tp:
    enabled: true
    executors:
      - thread-pool-name: asyncTaskExecutor
        thread-pool-alias-name: 异步任务执行器
        core-pool-size: 10
        maximum-pool-size: 20
        queue-type: LinkedBlockingQueue
        queue-capacity: 100
        reject-policy: AbortPolicy
```

## 监控和日志

### 1. 连接状态日志

```
INFO  - Client connected: 192.168.1.100:8080, total connected clients: 1
INFO  - Client connected: 192.168.1.101:8080, total connected clients: 2
INFO  - Successfully retrieved 15 thread pools from 2 clients
```

### 2. 数据获取日志

```
DEBUG - Retrieved 8 thread pools from client: 192.168.1.100:8080
DEBUG - Retrieved 7 thread pools from client: 192.168.1.101:8080
INFO  - Successfully retrieved 15 thread pools from 2 clients
```

### 3. 错误处理日志

```
WARN  - No clients connected, using mock data
ERROR - Failed to get thread pool data from clients
WARN  - Failed to get thread pool data from all sources, using mock data
```

## 最佳实践

### 1. 客户端管理

```java
// 定期检查客户端连接状态
@Scheduled(fixedRate = 30000) // 每30秒检查一次
public void checkClientConnections() {
    int clientCount = adminServer.getConnectedClientCount();
    if (clientCount == 0) {
        log.warn("No clients connected to thread pool monitor");
    } else {
        log.info("{} clients connected to thread pool monitor", clientCount);
    }
}
```

### 2. 数据聚合策略

```java
// 自定义数据聚合逻辑
private List<ThreadPoolStats> aggregateThreadPools(List<List<ThreadPoolStats>> allPools) {
    Map<String, ThreadPoolStats> aggregated = new HashMap<>();

    for (List<ThreadPoolStats> clientPools : allPools) {
        for (ThreadPoolStats pool : clientPools) {
            String baseName = pool.getPoolName().split("@")[0];
            // 聚合逻辑...
        }
    }

    return new ArrayList<>(aggregated.values());
}
```

### 3. 性能优化

```java
// 使用缓存减少重复请求
@Cacheable(value = "threadPoolData", key = "'all'", unless = "#result.isEmpty()")
public List<ThreadPoolStats> getThreadPoolsData() {
    // 数据获取逻辑...
}
```

## 注意事项

1. **网络延迟**：多客户端请求可能增加响应时间
2. **数据一致性**：不同客户端的数据可能存在时间差
3. **资源消耗**：大量客户端连接会增加服务器资源消耗
4. **错误隔离**：单个客户端失败不应影响其他客户端的数据获取
5. **数据去重**：相同名称的线程池需要添加客户端标识区分

## 故障排除

### 1. 客户端连接问题

**问题**：客户端无法连接到监控服务器
**解决方案**：

- 检查网络连接
- 验证端口配置
- 检查防火墙设置

### 2. 数据获取失败

**问题**：无法从客户端获取线程池数据
**解决方案**：

- 检查客户端线程池配置
- 验证权限设置
- 查看客户端日志

### 3. 数据不一致

**问题**：不同客户端返回的数据格式不一致
**解决方案**：

- 统一客户端版本
- 检查序列化配置
- 验证数据格式
