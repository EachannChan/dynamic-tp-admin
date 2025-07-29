package com.izpan.admin.controller.monitor;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.izpan.common.api.Result;
import com.izpan.infrastructure.page.PageQuery;
import com.izpan.modules.monitor.domain.bo.MonThreadPoolBO;
import com.izpan.modules.monitor.facade.IMonThreadPoolFacade;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.dromara.dynamictp.common.entity.ThreadPoolStats;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 线程池监控
 *
 * @Author eachann
 * @ProjectName panis-boot
 * @ClassName com.izpan.admin.controller.monitor.MonThreadPoolController
 * @CreateTime 2024/12/19 - 10:00
 */
@RestController
@Tag(name = "线程池监控")
@RequiredArgsConstructor
@RequestMapping("/mon_thread_pool")
public class MonThreadPoolController {

  @NonNull
  private IMonThreadPoolFacade monThreadPoolFacade;

  @GetMapping("/page")
  @SaCheckPermission("mon:thread_pool:page")
  @Operation(operationId = "1", summary = "分页获取线程池列表")
  public Result<IPage<ThreadPoolStats>> listMonThreadPoolPage(
      @Parameter(description = "分页参数") PageQuery pageQuery,
      @Parameter(description = "查询条件") MonThreadPoolBO monThreadPoolBO) {
    return Result.data(monThreadPoolFacade.listMonThreadPoolPage(pageQuery, monThreadPoolBO));
  }

  @GetMapping("/statistics")
  @SaCheckPermission("mon:thread_pool:statistics")
  @Operation(operationId = "2", summary = "获取统计数据")
  public Result<ThreadPoolStats> getStatistics() {
    return Result.data(monThreadPoolFacade.getStatistics());
  }

  @GetMapping("/metrics")
  @SaCheckPermission("mon:thread_pool:metrics")
  @Operation(operationId = "3", summary = "获取实时指标")
  public Result<List<ThreadPoolStats>> getMetrics() {
    return Result.data(monThreadPoolFacade.getMetrics());
  }

  @GetMapping("/detail/{poolName}")
  @SaCheckPermission("mon:thread_pool:detail")
  @Operation(operationId = "4", summary = "获取线程池详情")
  public Result<ThreadPoolStats> getDetail(
      @Parameter(description = "线程池名称") @PathVariable String poolName) {
    return Result.data(monThreadPoolFacade.getDetail(poolName));
  }
}