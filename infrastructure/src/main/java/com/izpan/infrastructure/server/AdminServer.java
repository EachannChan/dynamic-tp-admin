package com.izpan.infrastructure.server;

import cn.hutool.core.lang.generator.SnowflakeGenerator;
import com.alipay.remoting.ConnectionEventType;
import com.alipay.remoting.config.Configs;
import com.alipay.remoting.exception.RemotingException;
import com.alipay.remoting.rpc.RpcServer;
import com.alipay.remoting.serialization.HessianSerializer;
import com.alipay.remoting.serialization.SerializerManager;
import com.izpan.infrastructure.server.processor.AdminServerUserProcessor;
import com.izpan.infrastructure.server.processor.ServerConnectProcessor;
import com.izpan.infrastructure.server.processor.ServerDisconnectProcessor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.dromara.dynamictp.common.em.AdminRequestTypeEnum;
import org.dromara.dynamictp.common.entity.AdminRequestBody;

import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

@Slf4j
public class AdminServer {

    private final int port = 8989;

    private final RpcServer server;

    private final AdminServerUserProcessor adminServerUserProcessor = new AdminServerUserProcessor();

    @Getter
    private static final HessianSerializer SERIALIZER = new HessianSerializer();

    @Getter
    private static final SnowflakeGenerator SNOWFLAKE_GENERATOR = new SnowflakeGenerator();

    public AdminServer() {
        this.server = new RpcServer(port, true);
        server.addConnectionEventProcessor(ConnectionEventType.CONNECT,
                new ServerConnectProcessor(adminServerUserProcessor));
        server.addConnectionEventProcessor(ConnectionEventType.CLOSE,
                new ServerDisconnectProcessor(adminServerUserProcessor));
        server.registerUserProcessor(adminServerUserProcessor);
        this.server.startup();
        SerializerManager.addSerializer(1, SERIALIZER);
        System.setProperty(Configs.SERIALIZER, String.valueOf(SERIALIZER));
        log.info("DynamicTp admin server started, port: {}", port);
    }

    /**
     * 向第一个可用的客户端发送请求（向后兼容）
     * 
     * @param requestType 请求类型
     * @param body        请求体
     * @return 响应结果
     * @throws RemotingException    RPC异常
     * @throws InterruptedException 中断异常
     */
    public Object requestToClient(AdminRequestTypeEnum requestType, Object body)
            throws RemotingException, InterruptedException {
        AdminRequestBody requestBody = new AdminRequestBody(SNOWFLAKE_GENERATOR.next(), requestType, body);
        String remoteAddr = adminServerUserProcessor.getFirstAvailableClient();

        if ("NOT-CONNECT".equals(remoteAddr)) {
            log.warn("No clients connected, cannot send request");
            return null;
        }

        log.debug("Sending request to client: {}", remoteAddr);
        return server.invokeSync(remoteAddr, requestBody, 30000);
    }

    /**
     * 向指定客户端发送请求
     * 
     * @param clientAddress 客户端地址
     * @param requestType   请求类型
     * @param body          请求体
     * @return 响应结果
     * @throws RemotingException    RPC异常
     * @throws InterruptedException 中断异常
     */
    public Object requestToSpecificClient(String clientAddress, AdminRequestTypeEnum requestType, Object body)
            throws RemotingException, InterruptedException {
        AdminRequestBody requestBody = new AdminRequestBody(SNOWFLAKE_GENERATOR.next(), requestType, body);
        log.debug("Sending request to specific client: {}", clientAddress);
        return server.invokeSync(clientAddress, requestBody, 30000);
    }

    /**
     * 向所有连接的客户端广播请求
     * 
     * @param requestType 请求类型
     * @param body        请求体
     * @return 所有客户端的响应结果列表
     */
    public List<Object> broadcastToAllClients(AdminRequestTypeEnum requestType, Object body) {
        Set<String> connectedClients = adminServerUserProcessor.getConnectedClients();
        List<Object> results = new ArrayList<>();

        if (connectedClients.isEmpty()) {
            log.warn("No clients connected, cannot broadcast request");
            return results;
        }

        log.info("Broadcasting request to {} clients: {}", connectedClients.size(), connectedClients);

        // 使用CompletableFuture并发发送请求
        List<CompletableFuture<Object>> futures = new ArrayList<>();

        for (String clientAddress : connectedClients) {
            CompletableFuture<Object> future = CompletableFuture.supplyAsync(() -> {
                try {
                    return requestToSpecificClient(clientAddress, requestType, body);
                } catch (Exception e) {
                    log.error("Failed to send request to client: {}", clientAddress, e);
                    return null;
                }
            });
            futures.add(future);
        }

        // 等待所有请求完成，设置超时时间
        CompletableFuture<Void> allFutures = CompletableFuture.allOf(
                futures.toArray(new CompletableFuture[0]));

        try {
            allFutures.get(30, TimeUnit.SECONDS); // 30秒超时
        } catch (Exception e) {
            log.error("Timeout or error waiting for client responses", e);
        }

        // 收集结果
        for (CompletableFuture<Object> future : futures) {
            try {
                Object result = future.get(1, TimeUnit.SECONDS);
                results.add(result);
            } catch (Exception e) {
                log.warn("Failed to get result from client", e);
                results.add(null);
            }
        }

        return results;
    }

    /**
     * 获取所有已连接的客户端
     * 
     * @return 客户端地址集合
     */
    public Set<String> getConnectedClients() {
        return adminServerUserProcessor.getConnectedClients();
    }

    /**
     * 获取连接的客户端数量
     * 
     * @return 客户端数量
     */
    public int getConnectedClientCount() {
        return adminServerUserProcessor.getConnectedClients().size();
    }

    /**
     * 获取处理器实例
     * 
     * @return 处理器实例
     */
    public AdminServerUserProcessor getAdminServerUserProcessor() {
        return adminServerUserProcessor;
    }

    /**
     * 关闭服务器
     */
    public void shutdown() {
        if (server != null) {
            server.shutdown();
        }
        if (adminServerUserProcessor != null) {
            adminServerUserProcessor.shutdown();
        }
        log.info("AdminServer shutdown completed");
    }
}
