package com.izpan.infrastructure.server.processor;

import com.alipay.remoting.Connection;
import com.alipay.remoting.ConnectionEventProcessor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ServerConnectProcessor  implements ConnectionEventProcessor {
    @Override
    public void onEvent(String remoteAddress, Connection connection) {
        log.info("DynamicTp admin server connected, remoteAddress: {}", remoteAddress);

    }
}
