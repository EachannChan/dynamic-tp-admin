# 前后端 API 对齐总结

**作者**: eachann  
**创建时间**: 2025/07/29  
**项目**: panis-boot

## 概述

根据前端 `panis-admin` 项目的 API 调用需求，对后端 API 进行了全面调整，确保前后端 API 完全对齐。

## 前端 API 需求分析

### 1. 客户端相关 API

前端调用了以下客户端 API：

#### 1.1 获取客户端列表

```typescript
// 前端调用
fetchGetClientList() {
  return request<Api.Monitor.Client[]>({
    url: '/clients',
    method: 'GET'
  });
}
```

**期望返回的数据结构**:

```typescript
type Client = {
  clientId: string
  clientName: string
  clientIp: string
  clientPort: number
  status: 'online' | 'offline'
  lastHeartbeat: string
  registerTime: string
  threadPoolCount: number
  activeThreadCount: number
  totalTaskCount: number
  completedTaskCount: number
  applicationName?: string
  environment?: string
  version?: string
}
```

### 2. 线程池相关 API

前端调用了以下线程池 API：

#### 2.1 全局线程池 API

```typescript
// 分页获取线程池列表
fetchGetThreadPoolList(params?: Api.Monitor.ThreadPoolSearchParams) {
  return request<Api.Monitor.ThreadPoolList>({
    url: '/mon_thread_pool/page',
    method: 'GET',
    params
  });
}

// 获取统计数据
fetchGetThreadPoolStatistics() {
  return request<Api.Monitor.ThreadPoolStatistics>({
    url: '/mon_thread_pool/statistics',
    method: 'GET'
  });
}

// 获取实时指标
fetchGetThreadPoolMetrics() {
  return request<Api.Monitor.ThreadPoolMetrics[]>({
    url: '/mon_thread_pool/metrics',
    method: 'GET'
  });
}

// 获取线程池详情
fetchGetThreadPoolDetail(poolName: string) {
  return request<Api.Monitor.ThreadPool>({
    url: `/mon_thread_pool/detail/${poolName}`,
    method: 'GET'
  });
}
```

#### 2.2 按客户端的线程池 API

```typescript
// 按客户端分页获取线程池列表
fetchGetThreadPoolListByClient(clientId: string, params?: Api.Monitor.ThreadPoolSearchParams) {
  return request<Api.Monitor.ThreadPoolList>({
    url: `/thread_pool/client/${clientId}/page`,
    method: 'GET',
    params
  });
}

// 按客户端获取统计数据
fetchGetThreadPoolStatisticsByClient(clientId: string) {
  return request<Api.Monitor.ThreadPoolStatistics>({
    url: `/thread_pool/client/${clientId}/statistics`,
    method: 'GET'
  });
}

// 按客户端获取实时指标
fetchGetThreadPoolMetricsByClient(clientId: string) {
  return request<Api.Monitor.ThreadPoolMetrics[]>({
    url: `/thread_pool/client/${clientId}/metrics`,
    method: 'GET'
  });
}
```

## 后端 API 调整

### 1. 客户端 API 调整

#### 1.1 新增 `/clients` 接口

**文件**: `admin/src/main/java/com/izpan/admin/controller/monitor/MonClientController.java`

**调整内容**:

- 将 `@RequestMapping` 从 `/mon_client` 改为 `/`
- 新增 `/clients` 接口，返回详细的客户端信息
- 保留原有的 `/mon_client/*` 接口用于兼容

**新增接口**:

```java
@GetMapping("/clients")
@SaCheckPermission("mon:client:list")
@Operation(operationId = "1", summary = "获取客户端列表")
public Result<List<Map<String, Object>>> getClients() {
  // 返回符合前端期望的客户端数据结构
}
```

**返回数据结构**:

```json
{
  "code": 200,
  "message": "操作成功",
  "data": [
    {
      "clientId": "192.168.1.100:8080",
      "clientName": "客户端-192.168.1.100",
      "clientIp": "192.168.1.100",
      "clientPort": 8080,
      "status": "online",
      "lastHeartbeat": "2025-07-29T10:00:00",
      "registerTime": "2025-07-29T09:00:00",
      "threadPoolCount": 3,
      "activeThreadCount": 15,
      "totalTaskCount": 1000,
      "completedTaskCount": 950,
      "applicationName": "panis-boot",
      "environment": "dev",
      "version": "1.0.0"
    }
  ]
}
```

### 2. 线程池 API 调整

#### 2.1 保持原有 API 不变

原有的线程池 API 已经符合前端需求：

- `GET /mon_thread_pool/page` ✅
- `GET /mon_thread_pool/statistics` ✅
- `GET /mon_thread_pool/metrics` ✅
- `GET /mon_thread_pool/detail/{poolName}` ✅

#### 2.2 新增按客户端的线程池 API

**文件**: `admin/src/main/java/com/izpan/admin/controller/monitor/MonThreadPoolByClientController.java`

**新增接口**:

```java
@GetMapping("/{clientId}/page")
public Result<IPage<ThreadPoolStats>> getThreadPoolListByClient(...)

@GetMapping("/{clientId}/statistics")
public Result<ThreadPoolStats> getThreadPoolStatisticsByClient(...)

@GetMapping("/{clientId}/metrics")
public Result<List<ThreadPoolStats>> getThreadPoolMetricsByClient(...)
```

**功能特性**:

- 验证客户端是否存在
- 过滤指定客户端的线程池数据
- 提供按客户端的汇总统计
- 支持分页查询

## 数据流处理

### 1. 客户端数据流

```
AdminServer.getConnectedClients()
    ↓
解析客户端地址 (IP:Port)
    ↓
构建客户端详细信息
    ↓
返回符合前端期望的数据结构
```

### 2. 线程池数据流

#### 2.1 全局线程池

```
MonThreadPoolFacade.getMetrics()
    ↓
获取所有线程池数据
    ↓
返回给前端
```

#### 2.2 按客户端线程池

```
MonThreadPoolFacade.getMetrics()
    ↓
过滤指定客户端的数据
    ↓
按客户端汇总统计
    ↓
返回给前端
```

## 权限配置

### 1. 客户端权限

```sql
-- 客户端列表查询权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('客户端列表', 2000, 1, 'clients', 'monitor/client/clients', 1, 0, 'C', '0', '0', 'mon:client:list', 'list', 'admin', NOW(), '', NULL, '客户端列表查询');
```

### 2. 线程池权限

```sql
-- 线程池分页查询权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('线程池列表', 2000, 2, 'page', 'monitor/thread-pool/page', 1, 0, 'C', '0', '0', 'mon:thread_pool:page', 'table', 'admin', NOW(), '', NULL, '线程池列表查询');

-- 线程池统计权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('线程池统计', 2000, 3, 'statistics', 'monitor/thread-pool/statistics', 1, 0, 'C', '0', '0', 'mon:thread_pool:statistics', 'chart', 'admin', NOW(), '', NULL, '线程池统计查询');

-- 线程池指标权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('线程池指标', 2000, 4, 'metrics', 'monitor/thread-pool/metrics', 1, 0, 'C', '0', '0', 'mon:thread_pool:metrics', 'dashboard', 'admin', NOW(), '', NULL, '线程池指标查询');
```

## 测试验证

### 1. 客户端 API 测试

```bash
# 测试客户端列表接口
curl -X GET "http://localhost:9999/clients" \
  -H "Authorization: Bearer your-token"

# 测试客户端数量接口
curl -X GET "http://localhost:9999/mon_client/count" \
  -H "Authorization: Bearer your-token"
```

### 2. 线程池 API 测试

```bash
# 测试全局线程池接口
curl -X GET "http://localhost:9999/mon_thread_pool/page" \
  -H "Authorization: Bearer your-token"

# 测试按客户端线程池接口
curl -X GET "http://localhost:9999/thread_pool/client/192.168.1.100:8080/page" \
  -H "Authorization: Bearer your-token"
```

## 兼容性说明

### 1. 向后兼容

- 保留了原有的 `/mon_client/*` 接口
- 保留了原有的 `/mon_thread_pool/*` 接口
- 新增的接口不影响现有功能

### 2. 前端兼容

- 前端可以直接使用新的 `/clients` 接口
- 前端可以使用按客户端的线程池 API
- 数据结构完全符合前端期望

## 优势

### 1. 功能完整性

- 支持全局线程池监控
- 支持按客户端线程池监控
- 提供详细的客户端信息

### 2. 数据一致性

- 前后端数据结构完全对齐
- 提供统一的错误处理
- 支持权限控制

### 3. 扩展性

- 模块化设计便于扩展
- 支持多客户端场景
- 便于后续功能增强

## 总结

通过这次前后端 API 对齐调整，我们实现了：

1. **完整的客户端监控功能**: 提供详细的客户端信息
2. **灵活的线程池监控**: 支持全局和按客户端的监控
3. **统一的数据结构**: 前后端数据格式完全一致
4. **良好的兼容性**: 保持向后兼容的同时提供新功能

现在前后端 API 完全对齐，前端可以正常调用所有需要的接口。
