# API 迁移指南

**作者**: eachann  
**创建时间**: 2025/07/29  
**项目**: panis-boot

## 概述

为了提供更好的模块化设计和更专注的功能，我们将客户端连接监控功能从线程池监控模块中独立出来，创建了专门的客户端监控模块。

## API 变化

### 旧 API（已废弃）

```http
GET /mon_thread_pool/clients
```

**权限要求**: `mon:thread_pool:clients`

**响应格式**:

```json
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

### 新 API（推荐使用）

#### 1. 获取客户端数量

```http
GET /mon_client/count
```

**权限要求**: `mon:client:count`

**响应格式**:

```json
{
  "code": 200,
  "message": "操作成功",
  "data": 3
}
```

#### 2. 获取客户端列表

```http
GET /mon_client/list
```

**权限要求**: `mon:client:list`

**响应格式**:

```json
{
  "code": 200,
  "message": "操作成功",
  "data": ["192.168.1.100:8080", "192.168.1.101:8080", "192.168.1.102:8080"]
}
```

#### 3. 获取客户端详细信息

```http
GET /mon_client/info
```

**权限要求**: `mon:client:info`

**响应格式**:

```json
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

## 迁移步骤

### 1. 前端代码更新

#### 旧代码

```javascript
// 获取客户端信息
const response = await fetch('/mon_thread_pool/clients')
const data = await response.json()
const clientCount = data.data.clientCount
const clients = data.data.connectedClients
```

#### 新代码

```javascript
// 获取客户端数量
const countResponse = await fetch('/mon_client/count')
const countData = await countResponse.json()
const clientCount = countData.data

// 获取客户端列表
const listResponse = await fetch('/mon_client/list')
const listData = await listResponse.json()
const clients = listData.data

// 获取详细信息（如果需要）
const infoResponse = await fetch('/mon_client/info')
const infoData = await infoResponse.json()
const detailedInfo = infoData.data
```

### 2. 权限配置更新

#### 移除旧权限

```sql
-- 删除旧的权限配置
DELETE FROM sys_menu WHERE perms = 'mon:thread_pool:clients';
```

#### 添加新权限

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

### 3. 测试验证

#### 测试新 API

```bash
# 测试客户端数量接口
curl -X GET "http://localhost:9999/mon_client/count" \
  -H "Authorization: Bearer your-token"

# 测试客户端列表接口
curl -X GET "http://localhost:9999/mon_client/list" \
  -H "Authorization: Bearer your-token"

# 测试客户端详细信息接口
curl -X GET "http://localhost:9999/mon_client/info" \
  -H "Authorization: Bearer your-token"
```

## 优势

### 1. 功能分离

- 线程池监控专注于线程池相关功能
- 客户端监控专注于连接管理功能

### 2. 性能优化

- 可以根据需要选择合适粒度的接口
- 减少不必要的数据传输

### 3. 权限控制

- 每个接口都有独立的权限控制
- 更细粒度的权限管理

### 4. 可扩展性

- 客户端监控模块可以独立扩展
- 便于后续功能增强

## 兼容性说明

### 1. 向后兼容

- 旧 API 已完全移除，不再支持
- 需要立即迁移到新 API

### 2. 错误处理

- 如果调用旧 API，将返回 404 错误
- 建议在迁移期间添加错误处理逻辑

### 3. 监控和日志

- 新 API 提供更详细的日志记录
- 便于问题排查和性能监控

## 时间安排

### 第一阶段（立即执行）

- [x] 创建新的客户端监控模块
- [x] 移除旧的 API 接口
- [x] 更新相关文档

### 第二阶段（建议在下次发布时执行）

- [ ] 前端代码迁移
- [ ] 权限配置更新
- [ ] 全面测试验证

### 第三阶段（长期维护）

- [ ] 监控新 API 的使用情况
- [ ] 收集用户反馈
- [ ] 持续优化和改进

## 联系支持

如果在迁移过程中遇到任何问题，请：

1. 查看详细的 API 文档：`MON_CLIENT_API.md`
2. 参考功能总结：`CLIENT_MONITOR_SUMMARY.md`
3. 联系开发团队获取技术支持

## 总结

通过这次 API 重构，我们实现了更好的模块化设计，提供了更专注和灵活的客户端监控功能。虽然需要一定的迁移工作，但长期来看将带来更好的可维护性和扩展性。
