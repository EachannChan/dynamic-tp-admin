package com.izpan.modules.monitor.facade.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.izpan.infrastructure.page.PageQuery;
import com.izpan.modules.monitor.domain.bo.MonThreadPoolBO;
import com.izpan.modules.monitor.facade.IMonThreadPoolFacade;
import com.izpan.modules.monitor.service.IMonThreadPoolService;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.dromara.dynamictp.common.entity.ThreadPoolStats;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 线程池监控 门面接口实现层
 *
 * @Author eachann
 * @ProjectName panis-boot
 * @ClassName com.izpan.modules.monitor.facade.impl.MonThreadPoolFacadeImpl
 * @CreateTime 2024/12/19 - 10:00
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MonThreadPoolFacadeImpl implements IMonThreadPoolFacade {

  @NonNull
  private IMonThreadPoolService monThreadPoolService;

  @Override
  public IPage<ThreadPoolStats> listMonThreadPoolPage(PageQuery pageQuery, MonThreadPoolBO monThreadPoolBO) {
    log.info("线程池监控 - 分页查询，参数：pageQuery={}, monThreadPoolBO={}", pageQuery, monThreadPoolBO);
    return monThreadPoolService.listMonThreadPoolPage(pageQuery, monThreadPoolBO);
  }

  @Override
  public ThreadPoolStats getStatistics() {
    log.info("获取线程池统计数据");
    return monThreadPoolService.getStatistics();
  }

  @Override
  public List<ThreadPoolStats> getMetrics() {
    log.info("获取线程池实时指标");
    return monThreadPoolService.getMetrics();
  }

  @Override
  public ThreadPoolStats getDetail(String poolName) {
    log.info("获取线程池详情，poolName={}", poolName);
    return monThreadPoolService.getDetail(poolName);
  }
}