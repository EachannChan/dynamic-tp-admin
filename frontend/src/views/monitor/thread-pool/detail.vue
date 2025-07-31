<template>
  <div class="h-full">
    <n-card :bordered="false" title="线程池详情" class="rounded-16px shadow-sm">
      <template #header-extra>
        <n-button @click="$router.back()">
          <template #icon>
            <icon-ic-round-arrow-back />
          </template>
          返回
        </n-button>
      </template>

      <div v-if="loading" class="flex justify-center items-center h-64">
        <n-spin size="large" />
      </div>

      <div v-else-if="threadPoolDetail" class="space-y-6">
        <!-- 基本信息 -->
        <n-card title="基本信息" class="rounded-16px shadow-sm">
          <n-descriptions :column="3" bordered>
            <n-descriptions-item label="线程池名称">
              {{ formatThreadPoolName(threadPoolDetail.poolName) }}
            </n-descriptions-item>
            <n-descriptions-item label="线程池别名">
              {{ threadPoolDetail.poolAliasName || '-' }}
            </n-descriptions-item>
            <n-descriptions-item label="是否动态线程池">
              <n-tag :type="threadPoolDetail.dynamic ? 'success' : 'default'">
                {{ threadPoolDetail.dynamic ? '是' : '否' }}
              </n-tag>
            </n-descriptions-item>
            <n-descriptions-item label="核心线程数">
              {{ threadPoolDetail.corePoolSize }}
            </n-descriptions-item>
            <n-descriptions-item label="最大线程数">
              {{ threadPoolDetail.maximumPoolSize }}
            </n-descriptions-item>
            <n-descriptions-item label="空闲时间"> {{ threadPoolDetail.keepAliveTime }}ms </n-descriptions-item>
            <n-descriptions-item label="队列类型">
              {{ threadPoolDetail.queueType }}
            </n-descriptions-item>
            <n-descriptions-item label="队列容量">
              {{ threadPoolDetail.queueCapacity }}
            </n-descriptions-item>
            <n-descriptions-item label="拒绝策略">
              {{ threadPoolDetail.rejectHandlerName }}
            </n-descriptions-item>
          </n-descriptions>
        </n-card>

        <!-- 当前状态 -->
        <n-card title="当前状态" class="rounded-16px shadow-sm">
          <n-grid :cols="4" :x-gap="16" :y-gap="16">
            <n-grid-item>
              <n-statistic label="当前线程数" :value="threadPoolDetail.poolSize" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="活跃线程数" :value="threadPoolDetail.activeCount" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="最大线程数" :value="threadPoolDetail.largestPoolSize" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="等待任务数" :value="threadPoolDetail.waitTaskCount" />
            </n-grid-item>
          </n-grid>
        </n-card>

        <!-- 队列状态 -->
        <n-card title="队列状态" class="rounded-16px shadow-sm">
          <n-grid :cols="3" :x-gap="16" :y-gap="16">
            <n-grid-item>
              <n-statistic label="队列大小" :value="threadPoolDetail.queueSize" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="队列容量" :value="threadPoolDetail.queueCapacity" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="剩余容量" :value="threadPoolDetail.queueRemainingCapacity" />
            </n-grid-item>
          </n-grid>
          <div class="mt-4">
            <div class="flex justify-between items-center mb-2">
              <span>队列使用率</span>
              <span>{{ getQueueUsageRate() }}%</span>
            </div>
            <n-progress :percentage="getQueueUsageRate()" :color="getProgressColor(getQueueUsageRate())" />
          </div>
        </n-card>

        <!-- 任务统计 -->
        <n-card title="任务统计" class="rounded-16px shadow-sm">
          <n-grid :cols="4" :x-gap="16" :y-gap="16">
            <n-grid-item>
              <n-statistic label="任务总数" :value="threadPoolDetail.taskCount" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="已完成任务" :value="threadPoolDetail.completedTaskCount" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="拒绝任务数" :value="threadPoolDetail.rejectCount" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="任务完成率" :value="getTaskCompletionRate()" suffix="%" />
            </n-grid-item>
          </n-grid>
        </n-card>

        <!-- 性能指标 -->
        <n-card title="性能指标" class="rounded-16px shadow-sm">
          <n-grid :cols="3" :x-gap="16" :y-gap="16">
            <n-grid-item>
              <n-statistic label="TPS" :value="threadPoolDetail.tps" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="平均耗时" :value="threadPoolDetail.avg" suffix="ms" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="最大耗时" :value="threadPoolDetail.maxRt" suffix="ms" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="最小耗时" :value="threadPoolDetail.minRt" suffix="ms" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="执行超时任务" :value="threadPoolDetail.runTimeoutCount" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="队列超时任务" :value="threadPoolDetail.queueTimeoutCount" />
            </n-grid-item>
          </n-grid>
        </n-card>

        <!-- 百分位指标 -->
        <n-card title="百分位指标" class="rounded-16px shadow-sm">
          <n-grid :cols="5" :x-gap="16" :y-gap="16">
            <n-grid-item>
              <n-statistic label="TP50" :value="threadPoolDetail.tp50" suffix="ms" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="TP75" :value="threadPoolDetail.tp75" suffix="ms" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="TP90" :value="threadPoolDetail.tp90" suffix="ms" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="TP95" :value="threadPoolDetail.tp95" suffix="ms" />
            </n-grid-item>
            <n-grid-item>
              <n-statistic label="TP99" :value="threadPoolDetail.tp99" suffix="ms" />
            </n-grid-item>
          </n-grid>
        </n-card>

        <!-- 线程池使用率图表 -->
        <n-card title="线程池使用率" class="rounded-16px shadow-sm">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <h4 class="text-lg font-semibold mb-2">线程使用率</h4>
              <div class="p-4 bg-gray-50 rounded">
                <div class="flex justify-between items-center mb-2">
                  <span>活跃线程/最大线程</span>
                  <span>{{ threadPoolDetail.activeCount }}/{{ threadPoolDetail.maximumPoolSize }}</span>
                </div>
                <n-progress :percentage="getThreadUsageRate()" :color="getProgressColor(getThreadUsageRate())" class="mb-2" />
                <div class="text-sm text-gray-500">使用率: {{ getThreadUsageRate().toFixed(1) }}%</div>
              </div>
            </div>
            <div>
              <h4 class="text-lg font-semibold mb-2">队列使用率</h4>
              <div class="p-4 bg-gray-50 rounded">
                <div class="flex justify-between items-center mb-2">
                  <span>队列大小/队列容量</span>
                  <span>{{ threadPoolDetail.queueSize }}/{{ threadPoolDetail.queueCapacity }}</span>
                </div>
                <n-progress :percentage="getQueueUsageRate()" :color="getProgressColor(getQueueUsageRate())" class="mb-2" />
                <div class="text-sm text-gray-500">使用率: {{ getQueueUsageRate().toFixed(1) }}%</div>
              </div>
            </div>
          </div>
        </n-card>
      </div>

      <div v-else class="flex justify-center items-center h-64">
        <n-empty description="未找到线程池信息" />
      </div>
    </n-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useMessage } from 'naive-ui';
import { fetchGetThreadPoolDetail } from '@/service/api/monitor/thread-pool';
import { formatThreadPoolName } from '@/utils/thread-pool';

const route = useRoute();
const router = useRouter();
const message = useMessage();

// 响应式数据
const loading = ref(false);
const threadPoolDetail = ref<Api.Monitor.ThreadPool | null>(null);

// 计算属性
const poolName = computed(() => route.params.poolName as string);

// 方法
const loadDetail = async () => {
  if (!poolName.value) {
    message.error('线程池名称不能为空');
    return;
  }

  loading.value = true;
  try {
    const response = await fetchGetThreadPoolDetail(poolName.value);
    threadPoolDetail.value = response.data;
  } catch (error) {
    message.error('加载线程池详情失败');
    console.error('加载线程池详情失败:', error);
  } finally {
    loading.value = false;
  }
};

const getQueueUsageRate = () => {
  if (!threadPoolDetail.value || threadPoolDetail.value.queueCapacity === 0) return 0;
  return (threadPoolDetail.value.queueSize / threadPoolDetail.value.queueCapacity) * 100;
};

const getThreadUsageRate = () => {
  if (!threadPoolDetail.value || threadPoolDetail.value.maximumPoolSize === 0) return 0;
  return (threadPoolDetail.value.activeCount / threadPoolDetail.value.maximumPoolSize) * 100;
};

const getTaskCompletionRate = () => {
  if (!threadPoolDetail.value || threadPoolDetail.value.taskCount === 0) return 0;
  return ((threadPoolDetail.value.completedTaskCount / threadPoolDetail.value.taskCount) * 100).toFixed(1);
};

const getProgressColor = (percentage: number) => {
  if (percentage < 50) return '#52c41a';
  if (percentage < 80) return '#faad14';
  return '#ff4d4f';
};

// 生命周期
onMounted(() => {
  loadDetail();
});
</script>

<style scoped>
.n-statistic {
  text-align: center;
}
</style>
