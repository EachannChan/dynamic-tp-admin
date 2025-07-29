package com.izpan.infrastructure.server.processor;

import com.alipay.remoting.BizContext;
import com.alipay.remoting.rpc.protocol.SyncUserProcessor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.dromara.dynamictp.common.entity.AdminRequestBody;

import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
public class AdminServerUserProcessor extends SyncUserProcessor<AdminRequestBody> {

    private final ExecutorService executor;

    @Getter
    private String remoteAddress = "NOT-CONNECT";

    public AdminServerUserProcessor() {
        this.executor = Executors.newSingleThreadExecutor();
    }

    /**
     * Safely update the remote address
     * 
     * @param bizContext business context, may be null
     * @return updated remote address
     */
    private String updateRemoteAddress(BizContext bizContext) {
        if (bizContext == null) {
            log.warn("BizContext is null, keeping current remote address: {}", this.remoteAddress);
            return this.remoteAddress;
        }

        try {
            String newAddress = bizContext.getRemoteAddress();
            if (newAddress != null && !newAddress.trim().isEmpty()) {
                String oldAddress = this.remoteAddress;
                this.remoteAddress = newAddress.trim();
                if (!oldAddress.equals(this.remoteAddress)) {
                    log.info("Remote address updated from '{}' to '{}'", oldAddress, this.remoteAddress);
                }
            } else {
                log.warn("Remote address from BizContext is null or empty, keeping current: {}", this.remoteAddress);
            }
        } catch (Exception e) {
            log.error("Failed to get remote address from BizContext", e);
        }

        return this.remoteAddress;
    }

    @Override
    public Object handleRequest(BizContext bizContext, AdminRequestBody adminRequestBody) throws Exception {
        log.info("DynamicTp admin request received:{}", adminRequestBody.getRequestType().getValue());

        // Safely update remote address
        updateRemoteAddress(bizContext);

        // Safely check timeout status
        if (bizContext != null && bizContext.isRequestTimeout()) {
            log.warn("DynamicTp admin request timeout:{}s", bizContext.getClientTimeout());
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

}
