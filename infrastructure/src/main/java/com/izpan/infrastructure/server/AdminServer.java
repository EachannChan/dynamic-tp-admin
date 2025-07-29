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
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.dromara.dynamictp.common.em.AdminRequestTypeEnum;
import org.dromara.dynamictp.common.entity.AdminRequestBody;

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
        server.addConnectionEventProcessor(ConnectionEventType.CONNECT, new ServerConnectProcessor());
        server.registerUserProcessor(adminServerUserProcessor);
        this.server.startup();
        SerializerManager.addSerializer(1, SERIALIZER);
        System.setProperty(Configs.SERIALIZER, String.valueOf(SERIALIZER));
        log.info("DynamicTp admin server started, port: {}", port);
    }

    public Object requestToClient(AdminRequestTypeEnum requestType, Object body)
            throws RemotingException, InterruptedException {
        AdminRequestBody requestBody = new AdminRequestBody(SNOWFLAKE_GENERATOR.next(), requestType, body);
        String remoteAddr = adminServerUserProcessor.getRemoteAddress();
        return server.invokeSync(remoteAddr, requestBody, 30000);
    }

}
