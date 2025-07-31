# 客户端连接监控 API 文档

**作者**: eachann  
**创建时间**: 2025/07/29  
**项目**: panis-boot

## 概述

客户端连接监控模块提供了专门用于监控和管理客户端连接状态的 API 接口。该模块从线程池监控中独立出来，提供更专注的客户端连接管理功能。

## API 接口列表

### 1. 获取连接的客户端数量

**接口地址**: `GET /mon_client/count`  
**权限要求**: `mon:client:count`  
**功能描述**: 获取当前连接的客户端数量

**请求参数**: 无

**响应示例**:

```json
{
  "code": 200,
  "message": "操作成功",
  "data": 3
}
```

### 2. 获取连接的客户端列表

**接口地址**: `GET /mon_client/list`  
**权限要求**: `mon:client:list`  
**功能描述**: 获取当前连接的客户端列表

**请求参数**: 无

**响应示例**:

```json
{
  "code": 200,
  "message": "操作成功",
  "data": [
    "client-192.168.1.100:8080",
    "client-192.168.1.101:8080",
    "client-192.168.1.102:8080"
  ]
}
```

### 3. 获取客户端连接详细信息

**接口地址**: `GET /mon_client/info`  
**权限要求**: `mon:client:info`  
**功能描述**: 获取客户端连接的详细信息，包括数量、列表和时间戳

**请求参数**: 无

**响应示例**:

```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "clientCount": 3,
    "connectedClients": [
      "client-192.168.1.100:8080",
      "client-192.168.1.101:8080",
      "client-192.168.1.102:8080"
    ],
    "timestamp": 1732800000000
  }
}
```

## 权限配置

需要在系统中配置以下权限：

```sql
-- 客户端数量查询权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('客户端数量', 2000, 1, 'count', 'monitor/client/count', 1, 0, 'C', '0', '0', 'mon:client:count', 'chart', 'admin', NOW(), '', NULL, '客户端数量查询');

-- 客户端列表查询权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('客户端列表', 2000, 2, 'list', 'monitor/client/list', 1, 0, 'C', '0', '0', 'mon:client:list', 'list', 'admin', NOW(), '', NULL, '客户端列表查询');

-- 客户端详细信息查询权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('客户端详情', 2000, 3, 'info', 'monitor/client/info', 1, 0, 'C', '0', '0', 'mon:client:info', 'detail', 'admin', NOW(), '', NULL, '客户端详细信息查询');
```

## 技术实现

### 1. Controller 层

- **文件**: `admin/src/main/java/com/izpan/admin/controller/monitor/MonClientController.java`
- **功能**: 提供 RESTful API 接口
- **特性**:
  - 使用 Swagger 注解进行 API 文档生成
  - 集成 Sa-Token 权限控制
  - 统一的返回格式

### 2. 依赖注入

- **AdminServer**: 用于获取客户端连接信息
- **日志记录**: 使用 Slf4j 进行日志记录

### 3. 数据来源

所有客户端连接信息都通过 `AdminServer` 获取：

- `adminServer.getConnectedClientCount()` - 获取连接数量
- `adminServer.getConnectedClients()` - 获取连接列表

## 使用场景

1. **实时监控**: 监控当前连接的客户端数量
2. **连接管理**: 查看具体的客户端连接列表
3. **系统诊断**: 通过详细信息进行系统状态诊断
4. **负载均衡**: 了解当前系统的负载分布情况

## 注意事项

1. 所有接口都需要相应的权限才能访问
2. 返回的数据是实时获取的，可能存在一定的延迟
3. 客户端连接信息会随着客户端的连接和断开而动态变化
4. 建议在需要实时监控的场景下，定期调用这些接口
