/*
 * All Rights Reserved: Copyright [2025] [Zhuang Pan (paynezhuang@gmail.com)]
 * Open Source Agreement: Apache License, Version 2.0
 * For educational purposes only, commercial use shall comply with the author's copyright information.
 * The author does not guarantee or assume any responsibility for the risks of using software.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.izpan.modules.system.listener;

import com.izpan.infrastructure.event.DataScopeCacheInvalidateEvent;
import com.izpan.modules.system.service.ISysUserRoleService;
import com.izpan.starter.database.mybatis.plus.handler.IDataScopeHandler;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionalEventListener;

import java.util.List;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 数据权限缓存清理事件监听器
 * <p>
 * 监听数据权限缓存清理事件，根据不同的清理类型执行相应的缓存清理操作：
 * 1. 按用户ID清理：清理指定用户的所有权限缓存
 * 2. 按权限码清理：清理指定权限的所有用户缓存
 * 3. 按角色ID清理：查询拥有指定角色的用户，清理这些用户的缓存
 * 4. 全量清理：清理所有缓存
 * </p>
 * <p>
 * 使用异步处理以避免阻塞业务操作，提高系统响应性能
 * </p>
 *
 * @Author payne.zhuang <paynezhuang@gmail.com>
 * @ProjectName panis-boot
 * @ClassName com.izpan.modules.system.listener.DataScopeCacheInvalidateListener
 * @CreateTime 2025-06-02 - 23:40:00
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class DataScopeCacheInvalidateListener {

    /**
     * 数据权限处理器，用于执行缓存清理操作
     */
    private final IDataScopeHandler dataScopeHandler;

    /**
     * 用户角色服务，用于查询角色关联的用户
     */
    private final ISysUserRoleService userRoleService;

    /**
     * 处理数据权限缓存清理事件
     * <p>
     * 异步处理缓存清理事件，根据事件类型执行不同的清理策略
     * 使用@TransactionalEventListener确保在事务提交后执行，保证数据一致性
     * </p>
     *
     * @param event 缓存清理事件
     * @author payne.zhuang
     * @CreateTime 2025-06-02 - 23:41:00
     */
    @Async
    @TransactionalEventListener
    public void handleCacheInvalidateEvent(DataScopeCacheInvalidateEvent event) {
        // 使用事件中的事务ID，实现完整链路追踪
        String transactionId = event.getTransactionId();
        long startTime = System.currentTimeMillis();
        
        try {
            log.info("[DataScope][{}] 🚀 缓存清理事件开始处理 | 类型={} | 原因={}", transactionId, event.getInvalidateType(), event.getReason());

            switch (event.getInvalidateType()) {
                case BY_USER_ID -> handleUserIdInvalidate(transactionId, event.getUserIds(), event.getReason());
                case BY_PERMISSION_CODE ->
                        handlePermissionCodeInvalidate(transactionId, event.getPermissionCodes(), event.getReason());
                case BY_ROLE_ID -> handleRoleIdInvalidate(transactionId, event.getRoleIds(), event.getReason());
                case ALL -> handleAllInvalidate(transactionId, event.getReason());
                default ->
                        log.warn("[DataScope][{}] ⚠️ 未知的缓存清理类型: {}", transactionId, event.getInvalidateType());
            }

            long duration = System.currentTimeMillis() - startTime;
            log.info("[DataScope][{}] ✅ 缓存清理事件处理完成 | 类型={} | 耗时={}ms", transactionId, event.getInvalidateType(), duration);

        } catch (Exception e) {
            long duration = System.currentTimeMillis() - startTime;
            log.error("[DataScope][{}] ❌ 缓存清理事件处理失败 | 类型={} | 耗时={}ms | 错误={}", transactionId, event.getInvalidateType(), duration, e.getMessage(), e);
        }
    }

    /**
     * 处理按用户ID清理缓存
     *
     * @param transactionId 事务ID
     * @param userIds       用户ID集合
     * @param reason        清理原因
     * @author payne.zhuang
     * @CreateTime 2025-06-02 - 23:42:00
     */
    private void handleUserIdInvalidate(String transactionId, Set<Long> userIds, String reason) {
        if (userIds == null || userIds.isEmpty()) {
            log.warn("[DataScope][{}] ⚠️ 用户ID集合为空，跳过缓存清理", transactionId);
            return;
        }

        log.info("[DataScope][{}] 👥 开始按用户ID清理缓存 | 用户数量={} | 用户列表={}", transactionId, userIds.size(), userIds);

        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failureCount = new AtomicInteger(0);
        long startTime = System.currentTimeMillis();

        for (Long userId : userIds) {
            try {
                dataScopeHandler.invalidateUserCache(userId);
                successCount.incrementAndGet();
                log.debug("[DataScope][{}] ✓ 用户缓存清理成功 | 用户ID={}", transactionId, userId);
            } catch (Exception e) {
                failureCount.incrementAndGet();
                log.error("[DataScope][{}] ✗ 用户缓存清理失败 | 用户ID={} | 错误={}",
                        transactionId, userId, e.getMessage(), e);
            }
        }

        long duration = System.currentTimeMillis() - startTime;
        log.info("[DataScope][{}] 📊 按用户ID清理缓存完成 | 总数={} | 成功={} | 失败={} | 耗时={}ms",
                transactionId, userIds.size(), successCount.get(), failureCount.get(), duration);
    }

    /**
     * 处理按权限码清理缓存
     *
     * @param transactionId   事务ID
     * @param permissionCodes 权限码集合
     * @param reason          清理原因
     * @author payne.zhuang
     * @CreateTime 2025-06-02 - 23:43:00
     */
    private void handlePermissionCodeInvalidate(String transactionId, Set<String> permissionCodes, String reason) {
        if (permissionCodes == null || permissionCodes.isEmpty()) {
            log.warn("[DataScope][{}] ⚠️ 权限码集合为空，跳过缓存清理", transactionId);
            return;
        }

        log.info("[DataScope][{}] 🔐 开始按权限码清理缓存 | 权限数量={} | 权限列表={}",
                transactionId, permissionCodes.size(), permissionCodes);

        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failureCount = new AtomicInteger(0);
        long startTime = System.currentTimeMillis();

        for (String permissionCode : permissionCodes) {
            try {
                dataScopeHandler.invalidatePermissionCache(permissionCode);
                successCount.incrementAndGet();
                log.debug("[DataScope][{}] ✓ 权限缓存清理成功 | 权限码={}", transactionId, permissionCode);
            } catch (Exception e) {
                failureCount.incrementAndGet();
                log.error("[DataScope][{}] ✗ 权限缓存清理失败 | 权限码={} | 错误={}",
                        transactionId, permissionCode, e.getMessage(), e);
            }
        }

        long duration = System.currentTimeMillis() - startTime;
        log.info("[DataScope][{}] 📊 按权限码清理缓存完成 | 总数={} | 成功={} | 失败={} | 耗时={}ms",
                transactionId, permissionCodes.size(), successCount.get(), failureCount.get(), duration);
    }

    /**
     * 处理按角色ID清理缓存
     * <p>
     * 查询拥有指定角色的所有用户，然后清理这些用户的缓存
     * 这种方式确保角色权限变更后，所有相关用户的缓存都被正确清理
     * </p>
     *
     * @param transactionId 事务ID
     * @param roleIds       角色ID集合
     * @param reason        清理原因
     * @author payne.zhuang
     * @CreateTime 2025-06-02 - 23:44:00
     */
    private void handleRoleIdInvalidate(String transactionId, Set<Long> roleIds, String reason) {
        if (roleIds == null || roleIds.isEmpty()) {
            log.warn("[DataScope][{}] ⚠️ 角色ID集合为空，跳过缓存清理", transactionId);
            return;
        }

        log.info("[DataScope][{}] 👤 开始按角色ID清理缓存 | 角色数量={} | 角色列表={}", transactionId, roleIds.size(), roleIds);

        try {
            long queryStartTime = System.currentTimeMillis();

            // 查询拥有这些角色的所有用户ID
            List<Long> affectedUserIds = userRoleService.listUserIdsByRoleIds(roleIds);

            long queryDuration = System.currentTimeMillis() - queryStartTime;
            log.debug("[DataScope][{}] 🔍 角色关联用户查询完成 | 查询耗时={}ms", transactionId, queryDuration);

            if (affectedUserIds.isEmpty()) {
                log.info("[DataScope][{}] ℹ️ 角色无关联用户，无需清理缓存 | 角色列表={}", transactionId, roleIds);
                return;
            }

            log.info("[DataScope][{}] 📋 查询到角色关联用户 | 用户数量={} | 用户列表={}", transactionId, affectedUserIds.size(), affectedUserIds);

            // 清理这些用户的缓存
            int[] result = invalidateUsersCache(transactionId, affectedUserIds, roleIds);
            int successCount = result[0];
            int failureCount = result[1];
            long cacheClearDuration = result[2];

            long totalDuration = queryDuration + cacheClearDuration;
            log.info("[DataScope][{}] 📊 按角色ID清理缓存完成 | 角色数量={} | 用户数量={} | 成功={} | 失败={} | 总耗时={}ms",
                    transactionId, roleIds.size(), affectedUserIds.size(), successCount, failureCount, totalDuration);

        } catch (Exception e) {
            log.error("[DataScope][{}] ❌ 按角色ID清理缓存失败 | 角色列表={} | 错误={}", transactionId, roleIds, e.getMessage(), e);
        }
    }

    /**
     * 批量清理用户缓存
     * <p>
     * 遍历用户ID列表，逐个清理用户缓存，并记录清理结果
     * </p>
     *
     * @param transactionId 事务ID
     * @param userIds       用户ID列表
     * @param roleIds       关联的角色ID集合（用于日志记录）
     * @return 清理结果数组 [成功数量, 失败数量, 耗时(ms)]
     * @author payne.zhuang
     * @CreateTime 2025-06-03 15:52:02
     */
    private int[] invalidateUsersCache(String transactionId, List<Long> userIds, Set<Long> roleIds) {
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failureCount = new AtomicInteger(0);
        long startTime = System.currentTimeMillis();

        for (Long userId : userIds) {
            try {
                dataScopeHandler.invalidateUserCache(userId);
                successCount.incrementAndGet();
                log.debug("[DataScope][{}] ✓ 角色关联用户缓存清理成功 | 用户ID={} | 关联角色={}", transactionId, userId, roleIds);
            } catch (Exception e) {
                failureCount.incrementAndGet();
                log.error("[DataScope][{}] ✗ 角色关联用户缓存清理失败 | 用户ID={} | 关联角色={} | 错误={}", transactionId, userId, roleIds, e.getMessage(), e);
            }
        }

        long duration = System.currentTimeMillis() - startTime;
        return new int[]{successCount.get(), failureCount.get(), (int) duration};
    }

    /**
     * 处理全量缓存清理
     *
     * @param transactionId 事务ID
     * @param reason        清理原因
     * @author payne.zhuang
     * @CreateTime 2025-06-02 - 23:45:00
     */
    private void handleAllInvalidate(String transactionId, String reason) {
        log.info("[DataScope][{}] 🧹 开始全量缓存清理", transactionId);

        long startTime = System.currentTimeMillis();
        try {
            dataScopeHandler.invalidateAllCache();
            long duration = System.currentTimeMillis() - startTime;
            log.info("[DataScope][{}] ✅ 全量缓存清理完成 | 耗时={}ms", transactionId, duration);
        } catch (Exception e) {
            long duration = System.currentTimeMillis() - startTime;
            log.error("[DataScope][{}] ❌ 全量缓存清理失败 | 耗时={}ms | 错误={}", transactionId, duration, e.getMessage(), e);
        }
    }
} 