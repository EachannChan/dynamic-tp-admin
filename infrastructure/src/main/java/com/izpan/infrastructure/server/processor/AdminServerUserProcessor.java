package com.izpan.infrastructure.server.processor;

import com.alipay.remoting.BizContext;
import com.alipay.remoting.rpc.protocol.SyncUserProcessor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.dromara.dynamictp.common.entity.AdminRequestBody;

import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.Set;
import java.util.HashSet;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
public class AdminServerUserProcessor extends SyncUserProcessor<AdminRequestBody> {

    private final ExecutorService executor;

    // 使用线程安全的Set来管理多个客户端连接
    private final Set<String> connectedClients = ConcurrentHashMap.newKeySet();

    // 线程池名称计数器
    private final AtomicInteger threadCounter = new AtomicInteger(1);

    public AdminServerUserProcessor() {
        // 使用多线程执行器，支持并发处理多个客户端请求
        this.executor = new ThreadPoolExecutor(
                2, // 核心线程数
                10, // 最大线程数
                60L, // 空闲线程存活时间
                TimeUnit.SECONDS,
                new LinkedBlockingQueue<>(100), // 工作队列
                r -> {
                    Thread t = new Thread(r, "AdminServerProcessor-" + threadCounter.getAndIncrement());
                    t.setDaemon(true);
                    return t;
                },
                new ThreadPoolExecutor.CallerRunsPolicy() // 拒绝策略：调用者运行
        );
    }

    /**
     * 安全地添加客户端连接
     * 
     * @param bizContext 业务上下文
     * @return 客户端地址
     */
    private String addClientConnection(BizContext bizContext) {
        if (bizContext == null) {
            log.warn("BizContext is null, cannot add client connection");
            return null;
        }

        try {
            String clientAddress = bizContext.getRemoteAddress();
            if (clientAddress != null && !clientAddress.trim().isEmpty()) {
                clientAddress = clientAddress.trim();
                connectedClients.add(clientAddress);
                log.info("Client connected: {}, total connected clients: {}", clientAddress, connectedClients.size());
                return clientAddress;
            } else {
                log.warn("Remote address from BizContext is null or empty");
            }
        } catch (Exception e) {
            log.error("Failed to get remote address from BizContext", e);
        }

        return null;
    }

    /**
     * 移除客户端连接
     * 
     * @param clientAddress 客户端地址
     */
    public void removeClientConnection(String clientAddress) {
        if (clientAddress != null && connectedClients.remove(clientAddress)) {
            log.info("Client disconnected: {}, remaining clients: {}", clientAddress, connectedClients.size());
        }
    }

    /**
     * 获取所有已连接的客户端
     * 
     * @return 客户端地址集合
     */
    public Set<String> getConnectedClients() {
        return new HashSet<>(connectedClients);
    }

    /**
     * 获取第一个可用的客户端地址（用于向后兼容）
     * 
     * @return 第一个客户端地址，如果没有则返回默认值
     */
    public String getFirstAvailableClient() {
        return connectedClients.stream().findFirst().orElse("NOT-CONNECT");
    }

    @Override
    public Object handleRequest(BizContext bizContext, AdminRequestBody adminRequestBody) throws Exception {
        log.info("DynamicTp admin request received:{} from client: {}",
                adminRequestBody.getRequestType().getValue(),
                bizContext != null ? bizContext.getRemoteAddress() : "unknown");

        // 添加客户端连接
        String clientAddress = addClientConnection(bizContext);

        // 检查超时状态
        if (bizContext != null && bizContext.isRequestTimeout()) {
            log.warn("DynamicTp admin request timeout:{}s from client: {}",
                    bizContext.getClientTimeout(), clientAddress);
        }

        return doHandleRequest(adminRequestBody);
    }

    private Object doHandleRequest(AdminRequestBody adminRequestBody) {
        switch (adminRequestBody.getRequestType()) {
            case EXECUTOR_MONITOR:
                return handleExecutorMonitorRequest(adminRequestBody);
            case EXECUTOR_REFRESH:
                return handleExecutorRefreshRequest(adminRequestBody);
            case ALARM_MANAGE:
                return handleAlarmManageRequest(adminRequestBody);
            case LOG_MANAGE:
                return handleLogManageRequest(adminRequestBody);
            default:
                throw new IllegalArgumentException("DynamicTp admin request type "
                        + adminRequestBody.getRequestType().getValue() + " is not supported");
        }
    }

    @Override
    public String interest() {
        return AdminRequestBody.class.getName();
    }

    @Override
    public Executor getExecutor() {
        return executor;
    }

    private Object handleExecutorMonitorRequest(AdminRequestBody adminRequestBody) {
        return null;
    }

    private Object handleExecutorRefreshRequest(AdminRequestBody adminRequestBody) {
        return null;
    }

    private Object handleAlarmManageRequest(AdminRequestBody adminRequestBody) {
        return null;
    }

    private Object handleLogManageRequest(AdminRequestBody adminRequestBody) {
        return null;
    }

    /**
     * 关闭处理器，释放资源
     */
    @Override
    public void shutdown() {
        if (executor != null && !executor.isShutdown()) {
            executor.shutdown();
            try {
                if (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
                    executor.shutdownNow();
                }
            } catch (InterruptedException e) {
                executor.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
        connectedClients.clear();
        log.info("AdminServerUserProcessor shutdown completed");
    }
}
