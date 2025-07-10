package com.izpan.infrastructure.server;

import com.alipay.remoting.ConnectionEventType;
import com.alipay.remoting.rpc.RpcServer;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class AdminServer {

    private final int port = 8989;

    private final RpcServer server;

    public AdminServer() {
        this.server = new RpcServer(port,true);
        server.addConnectionEventProcessor(ConnectionEventType.CONNECT, new ServerConnectProcessor());
        server.registerUserProcessor(new AdminServerUserProcessor());
        this.server.startup();
        log.info("DynamicTp admin server started, port: {}", port);
    }

}
