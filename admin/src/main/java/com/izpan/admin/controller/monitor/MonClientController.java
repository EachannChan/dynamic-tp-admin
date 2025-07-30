package com.izpan.admin.controller.monitor;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.izpan.common.api.Result;
import com.izpan.infrastructure.server.AdminServer;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 客户端连接监控
 *
 * @Author eachann
 * @ProjectName panis-boot
 * @ClassName com.izpan.admin.controller.monitor.MonClientController
 * @CreateTime 2025/07/29 - 10:00
 */
@Slf4j
@RestController
@Tag(name = "客户端连接监控")
@RequiredArgsConstructor
@RequestMapping("/")
public class MonClientController {

  @NonNull
  private AdminServer adminServer;

  @GetMapping("/clients")
  @SaCheckPermission("mon:client:list")
  @Operation(operationId = "1", summary = "获取客户端列表")
  public Result<List<Map<String, Object>>> getClients() {
    log.info("获取客户端列表");
    Set<String> connectedClients = adminServer.getConnectedClients();
    List<Map<String, Object>> clients = new ArrayList<>();

    for (String clientAddress : connectedClients) {
      Map<String, Object> client = new HashMap<>();

      // 解析客户端地址
      String[] parts = clientAddress.split(":");
      String clientIp = parts.length > 0 ? parts[0] : "unknown";
      int clientPort = parts.length > 1 ? Integer.parseInt(parts[1]) : 0;

      // 构建客户端信息
      client.put("clientId", clientAddress);
      client.put("clientName", "客户端-" + clientIp);
      client.put("clientIp", clientIp);
      client.put("clientPort", clientPort);
      client.put("status", "online");
      client.put("lastHeartbeat", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
      client.put("registerTime", LocalDateTime.now().minusHours(1).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
      client.put("applicationName", "panis-boot");
      client.put("environment", "dev");
      client.put("version", "1.0.0");

      clients.add(client);
    }

    return Result.data(clients);
  }

  @GetMapping("/mon_client/count")
  @SaCheckPermission("mon:client:count")
  @Operation(operationId = "2", summary = "获取连接的客户端数量")
  public Result<Integer> getConnectedClientCount() {
    log.info("获取连接的客户端数量");
    int clientCount = adminServer.getConnectedClientCount();
    return Result.data(clientCount);
  }

  @GetMapping("/mon_client/list")
  @SaCheckPermission("mon:client:list")
  @Operation(operationId = "3", summary = "获取连接的客户端列表")
  public Result<Set<String>> getConnectedClients() {
    log.info("获取连接的客户端列表");
    Set<String> connectedClients = adminServer.getConnectedClients();
    return Result.data(connectedClients);
  }

  @GetMapping("/mon_client/info")
  @SaCheckPermission("mon:client:info")
  @Operation(operationId = "4", summary = "获取客户端连接详细信息")
  public Result<Map<String, Object>> getClientInfo() {
    log.info("获取客户端连接详细信息");
    Map<String, Object> result = new HashMap<>();

    Set<String> connectedClients = adminServer.getConnectedClients();
    int clientCount = adminServer.getConnectedClientCount();

    result.put("clientCount", clientCount);
    result.put("connectedClients", connectedClients);
    result.put("timestamp", System.currentTimeMillis());

    return Result.data(result);
  }
}