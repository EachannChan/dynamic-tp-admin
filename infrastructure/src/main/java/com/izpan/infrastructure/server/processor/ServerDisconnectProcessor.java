package com.izpan.infrastructure.server.processor;

import com.alipay.remoting.Connection;
import com.alipay.remoting.ConnectionEventProcessor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ServerDisconnectProcessor implements ConnectionEventProcessor {

  private final AdminServerUserProcessor adminServerUserProcessor;

  public ServerDisconnectProcessor(AdminServerUserProcessor adminServerUserProcessor) {
    this.adminServerUserProcessor = adminServerUserProcessor;
  }

  @Override
  public void onEvent(String remoteAddress, Connection connection) {
    log.info("DynamicTp admin server disconnected, remoteAddress: {}", remoteAddress);
    // 从连接列表中移除断开的客户端
    adminServerUserProcessor.removeClientConnection(remoteAddress);
  }
}