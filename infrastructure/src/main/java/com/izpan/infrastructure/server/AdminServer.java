package com.izpan.infrastructure.server;

import cn.hutool.core.lang.generator.SnowflakeGenerator;
import com.alipay.remoting.ConnectionEventType;
import com.alipay.remoting.RemotingCommand;
import com.alipay.remoting.config.Configs;
import com.alipay.remoting.rpc.RpcServer;
import com.alipay.remoting.serialization.HessianSerializer;
import com.alipay.remoting.serialization.SerializerManager;
import com.izpan.infrastructure.server.processor.AdminServerUserProcessor;
import com.izpan.infrastructure.server.processor.ServerConnectProcessor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class AdminServer {

    private final int port = 8989;

    private final RpcServer server;

    @Getter
    private static final HessianSerializer SERIALIZER = new HessianSerializer();

    @Getter
    private static final SnowflakeGenerator SNOWFLAKE_GENERATOR = new SnowflakeGenerator();

    public AdminServer() {
        this.server = new RpcServer(port, true);
        server.addConnectionEventProcessor(ConnectionEventType.CONNECT, new ServerConnectProcessor());
        server.registerUserProcessor(new AdminServerUserProcessor());
        this.server.startup();
        SerializerManager.addSerializer(1, SERIALIZER);
        System.setProperty(Configs.SERIALIZER, String.valueOf(SERIALIZER));
        log.info("DynamicTp admin server started, port: {}", port);
    }

//    public Object requestToClient(AdminRequestTypeEnum requestType, Object body) throws RemotingException, InterruptedException {
//        AdminRequestBody requestBody = new AdminRequestBody(requestType, body);
//        return server.invokeSync(server.getConnectionManager().getAndCreateIfAbsent(new Url()), requestBody, 30000);
//    }

}
