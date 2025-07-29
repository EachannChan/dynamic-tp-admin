package com.izpan.modules.monitor.service.impl;

import com.alipay.remoting.exception.RemotingException;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.izpan.infrastructure.page.PageQuery;
import com.izpan.infrastructure.server.AdminServer;
import com.izpan.modules.monitor.domain.bo.MonThreadPoolBO;
import com.izpan.modules.monitor.service.IMonThreadPoolService;
import lombok.extern.slf4j.Slf4j;
import org.dromara.dynamictp.common.em.AdminRequestTypeEnum;
import org.dromara.dynamictp.common.entity.AdminRequestBody;
import org.dromara.dynamictp.common.entity.ThreadPoolStats;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 线程池监控 Service 服务实现层
 *
 * @Author eachann
 * @ProjectName panis-boot
 * @ClassName com.izpan.modules.monitor.service.impl.MonThreadPoolServiceImpl
 * @CreateTime 2025/07/29 - 10:00
 */
@Slf4j
@Service
public class MonThreadPoolServiceImpl implements IMonThreadPoolService {

  @Resource
  private AdminServer adminServer;

  @Override
  public IPage<ThreadPoolStats> listMonThreadPoolPage(PageQuery pageQuery, MonThreadPoolBO monThreadPoolBO) {
    List<ThreadPoolStats> threadPools = getThreadPoolsData();

    // 分页处理
    int start = (pageQuery.getPage() - 1) * pageQuery.getPageSize();
    int end = Math.min(start + pageQuery.getPageSize(), threadPools.size());
    List<ThreadPoolStats> pageData = threadPools.subList(start, end);

    Page<ThreadPoolStats> page = new Page<>(pageQuery.getPage(), pageQuery.getPageSize());
    page.setRecords(pageData);
    page.setTotal(threadPools.size());
    return page;
  }

  @Override
  public ThreadPoolStats getStatistics() {
    List<ThreadPoolStats> threadPools = getThreadPoolsData();

    // 创建汇总统计数据
    ThreadPoolStats statistics = new ThreadPoolStats();
    statistics.setPoolName("系统汇总");
    statistics.setPoolAliasName("System Summary");

    // 计算汇总数据
    int totalPools = threadPools.size();
    int totalActiveCount = threadPools.stream().mapToInt(ThreadPoolStats::getActiveCount).sum();
    long totalTaskCount = threadPools.stream().mapToLong(ThreadPoolStats::getTaskCount).sum();
    long totalCompletedTaskCount = threadPools.stream().mapToLong(ThreadPoolStats::getCompletedTaskCount).sum();
    long totalRejectCount = threadPools.stream().mapToLong(ThreadPoolStats::getRejectCount).sum();

    statistics.setPoolSize(totalPools);
    statistics.setActiveCount(totalActiveCount);
    statistics.setTaskCount(totalTaskCount);
    statistics.setCompletedTaskCount(totalCompletedTaskCount);
    statistics.setRejectCount(totalRejectCount);

    return statistics;
  }

  @Override
  public List<ThreadPoolStats> getMetrics() {
    return getThreadPoolsData();
  }

  @Override
  public ThreadPoolStats getDetail(String poolName) {
    return getThreadPoolsData().stream()
        .filter(pool -> pool.getPoolName().equals(poolName))
        .findFirst()
        .orElse(null);
  }

  /**
   * 获取线程池数据 - 从dynamic-tp获取真实数据
   */
  private List<ThreadPoolStats> getThreadPoolsData() {
    try {
      Object result = adminServer.requestToClient(AdminRequestTypeEnum.EXECUTOR_MONITOR, null);
      List<ThreadPoolStats> threadPoolStatsList = (List<ThreadPoolStats>) ((AdminRequestBody) result).deserializeBody();
      if (threadPoolStatsList != null && !threadPoolStatsList.isEmpty()) {
        log.info("Successfully retrieved {} thread pool data from dynamic-tp", threadPoolStatsList.size());
        return threadPoolStatsList;
      }
    } catch (RemotingException | InterruptedException e) {
      log.error("Failed to get thread pool data from dynamic-tp due to network error:", e);
    } catch (Exception e) {
      log.error("Exception occurred while getting thread pool data:", e);
    }

    // 如果获取数据失败，返回空列表
    log.warn("Failed to get thread pool data, returning empty list");
    return new ArrayList<>();
  }
}