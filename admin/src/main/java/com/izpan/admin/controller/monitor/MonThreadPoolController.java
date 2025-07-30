package com.izpan.admin.controller.monitor;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.izpan.common.api.Result;
import com.izpan.infrastructure.page.PageQuery;
import com.izpan.infrastructure.server.AdminServer;
import com.izpan.modules.monitor.domain.bo.MonThreadPoolBO;
import com.izpan.modules.monitor.facade.IMonThreadPoolFacade;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.dromara.dynamictp.common.entity.ThreadPoolStats;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

/**
 * 线程池监控
 *
 * @Author eachann
 * @ProjectName panis-boot
 * @ClassName com.izpan.admin.controller.monitor.MonThreadPoolController
 * @CreateTime 2025/07/29 - 10:00
 */
@Slf4j
@RestController
@Tag(name = "线程池监控")
@RequiredArgsConstructor
@RequestMapping("/thread_pool/client")
public class MonThreadPoolController {

  @NonNull
  private IMonThreadPoolFacade monThreadPoolFacade;

  @NonNull
  private AdminServer adminServer;

  @GetMapping("/{clientId}/page")
  @SaCheckPermission("mon:thread_pool:page")
  @Operation(operationId = "1", summary = "按客户端分页获取线程池列表")
  public Result<IPage<ThreadPoolStats>> getThreadPoolListByClient(
      @Parameter(description = "客户端ID") @PathVariable String clientId,
      @Parameter(description = "分页参数") PageQuery pageQuery,
      @Parameter(description = "查询条件") MonThreadPoolBO monThreadPoolBO) {
    log.info("按客户端分页获取线程池列表，clientId={}", clientId);

    // 验证客户端是否存在
    if (!adminServer.getConnectedClients().contains(clientId)) {
      return Result.failure("客户端不存在或已断开连接");
    }

    try {
      // 直接向指定客户端请求线程池数据
      Object result = adminServer.requestToSpecificClient(clientId,
          org.dromara.dynamictp.common.em.AdminRequestTypeEnum.EXECUTOR_MONITOR, null);

      List<ThreadPoolStats> clientThreadPools = new ArrayList<>();

      if (result instanceof org.dromara.dynamictp.common.entity.AdminRequestBody) {
        org.dromara.dynamictp.common.entity.AdminRequestBody adminResponse = (org.dromara.dynamictp.common.entity.AdminRequestBody) result;
        Object responseBody = adminResponse.deserializeBody();

        if (responseBody instanceof List) {
          @SuppressWarnings("unchecked")
          List<ThreadPoolStats> pools = (List<ThreadPoolStats>) responseBody;
          clientThreadPools = pools;
        }
      } else if (result instanceof List) {
        @SuppressWarnings("unchecked")
        List<ThreadPoolStats> pools = (List<ThreadPoolStats>) result;
        clientThreadPools = pools;
      }

      // 分页处理
      int start = (pageQuery.getPage() - 1) * pageQuery.getPageSize();
      int end = Math.min(start + pageQuery.getPageSize(), clientThreadPools.size());
      List<ThreadPoolStats> pageData = clientThreadPools.subList(start, end);

      // 构建分页结果
      IPage<ThreadPoolStats> page = new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(
          pageQuery.getPage(), pageQuery.getPageSize());
      page.setRecords(pageData);
      page.setTotal(clientThreadPools.size());

      return Result.data(page);
    } catch (Exception e) {
      log.error("获取客户端线程池数据失败，clientId={}", clientId, e);
      return Result.failure("获取客户端线程池数据失败: " + e.getMessage());
    }
  }

  @GetMapping("/{clientId}/statistics")
  @SaCheckPermission("mon:thread_pool:statistics")
  @Operation(operationId = "2", summary = "按客户端获取线程池统计数据")
  public Result<ThreadPoolStats> getThreadPoolStatisticsByClient(
      @Parameter(description = "客户端ID") @PathVariable String clientId) {
    log.info("按客户端获取线程池统计数据，clientId={}", clientId);

    // 验证客户端是否存在
    if (!adminServer.getConnectedClients().contains(clientId)) {
      return Result.failure("客户端不存在或已断开连接");
    }

    try {
      // 直接向指定客户端请求线程池数据
      Object result = adminServer.requestToSpecificClient(clientId,
          org.dromara.dynamictp.common.em.AdminRequestTypeEnum.EXECUTOR_MONITOR, null);

      List<ThreadPoolStats> clientThreadPools = new ArrayList<>();

      if (result instanceof org.dromara.dynamictp.common.entity.AdminRequestBody) {
        org.dromara.dynamictp.common.entity.AdminRequestBody adminResponse = (org.dromara.dynamictp.common.entity.AdminRequestBody) result;
        Object responseBody = adminResponse.deserializeBody();

        if (responseBody instanceof List) {
          @SuppressWarnings("unchecked")
          List<ThreadPoolStats> pools = (List<ThreadPoolStats>) responseBody;
          clientThreadPools = pools;
        }
      } else if (result instanceof List) {
        @SuppressWarnings("unchecked")
        List<ThreadPoolStats> pools = (List<ThreadPoolStats>) result;
        clientThreadPools = pools;
      }

      // 创建汇总统计数据
      ThreadPoolStats statistics = new ThreadPoolStats();
      statistics.setPoolName("客户端汇总-" + clientId);
      statistics.setPoolAliasName("Client Summary - " + clientId);

      // 计算汇总数据
      int totalPools = clientThreadPools.size();
      int totalActiveCount = clientThreadPools.stream().mapToInt(ThreadPoolStats::getActiveCount).sum();
      long totalTaskCount = clientThreadPools.stream().mapToLong(ThreadPoolStats::getTaskCount).sum();
      long totalCompletedTaskCount = clientThreadPools.stream().mapToLong(ThreadPoolStats::getCompletedTaskCount).sum();
      long totalRejectCount = clientThreadPools.stream().mapToLong(ThreadPoolStats::getRejectCount).sum();

      statistics.setPoolSize(totalPools);
      statistics.setActiveCount(totalActiveCount);
      statistics.setTaskCount(totalTaskCount);
      statistics.setCompletedTaskCount(totalCompletedTaskCount);
      statistics.setRejectCount(totalRejectCount);

      return Result.data(statistics);
    } catch (Exception e) {
      log.error("获取客户端线程池数据失败，clientId={}", clientId, e);
      return Result.failure("获取客户端线程池数据失败: " + e.getMessage());
    }
  }

  @GetMapping("/{clientId}/metrics")
  @SaCheckPermission("mon:thread_pool:metrics")
  @Operation(operationId = "3", summary = "按客户端获取线程池实时指标")
  public Result<List<ThreadPoolStats>> getThreadPoolMetricsByClient(
      @Parameter(description = "客户端ID") @PathVariable String clientId) {
    log.info("按客户端获取线程池实时指标，clientId={}", clientId);

    // 验证客户端是否存在
    if (!adminServer.getConnectedClients().contains(clientId)) {
      return Result.failure("客户端不存在或已断开连接");
    }

    try {
      // 直接向指定客户端请求线程池数据
      Object result = adminServer.requestToSpecificClient(clientId,
          org.dromara.dynamictp.common.em.AdminRequestTypeEnum.EXECUTOR_MONITOR, null);

      if (result instanceof org.dromara.dynamictp.common.entity.AdminRequestBody) {
        org.dromara.dynamictp.common.entity.AdminRequestBody adminResponse = (org.dromara.dynamictp.common.entity.AdminRequestBody) result;
        Object responseBody = adminResponse.deserializeBody();

        if (responseBody instanceof List) {
          @SuppressWarnings("unchecked")
          List<ThreadPoolStats> clientThreadPools = (List<ThreadPoolStats>) responseBody;
          return Result.data(clientThreadPools);
        }
      } else if (result instanceof List) {
        @SuppressWarnings("unchecked")
        List<ThreadPoolStats> clientThreadPools = (List<ThreadPoolStats>) result;
        return Result.data(clientThreadPools);
      }

      return Result.data(new ArrayList<>());
    } catch (Exception e) {
      log.error("获取客户端线程池数据失败，clientId={}", clientId, e);
      return Result.failure("获取客户端线程池数据失败: " + e.getMessage());
    }
  }
}