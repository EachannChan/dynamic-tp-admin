<template>
  <div class="h-full">
    <n-card :bordered="false" title="线程池监控" class="rounded-16px shadow-sm">
      <!-- 统计卡片 -->
      <div class="mb-4">
        <n-grid :cols="4" :x-gap="16" :y-gap="16">
          <n-grid-item v-for="stat in computedStatistics" :key="stat.title">
            <n-card class="stat-card">
              <div class="flex items-center justify-between">
                <div>
                  <div class="text-sm text-gray-500">{{ stat.title }}</div>
                  <div class="text-2xl font-bold mt-1">{{ stat.value }}</div>
                </div>
                <div class="text-3xl text-blue-500">
                  <icon-ic-round-monitor v-if="stat.icon === 'monitor'" />
                  <icon-ic-round-trending-up v-else-if="stat.icon === 'trending'" />
                  <icon-ic-round-speed v-else-if="stat.icon === 'speed'" />
                  <icon-ic-round-error v-else-if="stat.icon === 'error'" />
                </div>
              </div>
            </n-card>
          </n-grid-item>
        </n-grid>
      </div>

      <!-- 搜索表单 -->
      <n-form
        ref="formRef"
        :model="searchForm"
        :rules="rules"
        label-placement="left"
        label-width="auto"
        require-mark-placement="right-hanging"
        size="medium"
        inline
        class="mb-4"
      >
        <n-form-item label="线程池名称" path="poolName">
          <n-input v-model:value="searchForm.poolName" placeholder="请输入线程池名称" clearable />
        </n-form-item>
        <n-form-item label="队列类型" path="queueType">
          <n-select v-model:value="searchForm.queueType" placeholder="请选择队列类型" :options="queueTypeOptions" clearable />
        </n-form-item>
        <n-form-item label="动态线程池" path="dynamic">
          <n-select v-model:value="searchForm.dynamic" placeholder="请选择线程池类型" :options="dynamicOptions" clearable />
        </n-form-item>
        <n-form-item>
          <n-space>
            <n-button type="primary" @click="handleSearch">
              <template #icon>
                <icon-ic-round-search />
              </template>
              搜索
            </n-button>
            <n-button @click="handleReset">
              <template #icon>
                <icon-ic-round-refresh />
              </template>
              重置
            </n-button>
          </n-space>
        </n-form-item>
      </n-form>

      <!-- 数据表格 -->
      <n-data-table
        :columns="columns"
        :data="tableData"
        :loading="loading"
        :pagination="pagination"
        :bordered="false"
        striped
        remote
        @update:page="handlePageChange"
        @update:page-size="handlePageSizeChange"
      />

      <!-- 实时指标图表 -->
      <div class="mt-6">
        <n-card title="实时性能指标" class="rounded-16px shadow-sm">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <h4 class="text-lg font-semibold mb-2">线程池使用情况</h4>
              <div class="space-y-2">
                <div v-for="metric in metrics" :key="metric.poolName" class="p-3 bg-gray-50 rounded">
                  <div class="flex justify-between items-center">
                    <span class="font-medium">{{ metric.poolName }}</span>
                    <span class="text-sm text-gray-500">{{ metric.activeCount }}/{{ metric.maximumPoolSize }}</span>
                  </div>
                  <n-progress
                    :percentage="(metric.activeCount / metric.maximumPoolSize) * 100"
                    :color="getProgressColor((metric.activeCount / metric.maximumPoolSize) * 100)"
                    class="mt-2"
                  />
                </div>
              </div>
            </div>
            <div>
              <h4 class="text-lg font-semibold mb-2">队列使用情况</h4>
              <div class="space-y-2">
                <div v-for="metric in metrics" :key="`queue-${metric.poolName}`" class="p-3 bg-gray-50 rounded">
                  <div class="flex justify-between items-center">
                    <span class="font-medium">{{ metric.poolName }}</span>
                    <span class="text-sm text-gray-500">{{ metric.queueSize }}/{{ metric.queueCapacity }}</span>
                  </div>
                  <n-progress
                    :percentage="(metric.queueSize / metric.queueCapacity) * 100"
                    :color="getProgressColor((metric.queueSize / metric.queueCapacity) * 100)"
                    class="mt-2"
                  />
                </div>
              </div>
            </div>
          </div>
        </n-card>
      </div>
    </n-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed, h } from 'vue';
import { useMessage, NSpace, NButton } from 'naive-ui';
import { fetchGetThreadPoolList, fetchGetThreadPoolStatistics, fetchGetThreadPoolMetrics } from '@/service/api/monitor/thread-pool';
import { formatThreadPoolName } from '@/utils/thread-pool';

const message = useMessage();

// 响应式数据
const loading = ref(false);
const tableData = ref<Api.Monitor.ThreadPool[]>([]);
const metrics = ref<Api.Monitor.ThreadPool[]>([]);
const statistics = ref<Api.Monitor.ThreadPool | null>(null);

// 搜索表单
const searchForm = reactive({
  poolName: '',
  queueType: null as string | null,
  dynamic: null as string | null
});

// 分页配置
const pagination = reactive({
  page: 1,
  pageSize: 10,
  total: 0,
  showSizePicker: true,
  pageSizes: [10, 20, 50, 100]
});

// 选项配置
const queueTypeOptions = [
  { label: 'LinkedBlockingQueue', value: 'LinkedBlockingQueue' },
  { label: 'ArrayBlockingQueue', value: 'ArrayBlockingQueue' },
  { label: 'SynchronousQueue', value: 'SynchronousQueue' },
  { label: 'PriorityBlockingQueue', value: 'PriorityBlockingQueue' }
];

const dynamicOptions = [
  { label: '动态线程池', value: 'true', type: 'option' },
  { label: '普通线程池', value: 'false', type: 'option' }
];

// 表格列配置
const columns = [
  {
    title: '线程池名称',
    key: 'poolName',
    width: 150,
    render: (row: Api.Monitor.ThreadPool) => formatThreadPoolName(row.poolName)
  },
  { title: '别名', key: 'poolAliasName', width: 120 },
  { title: '核心线程数', key: 'corePoolSize', width: 100 },
  { title: '最大线程数', key: 'maximumPoolSize', width: 100 },
  { title: '当前线程数', key: 'poolSize', width: 100 },
  { title: '活跃线程数', key: 'activeCount', width: 100 },
  { title: '队列大小', key: 'queueSize', width: 100 },
  { title: '队列容量', key: 'queueCapacity', width: 100 },
  { title: '队列类型', key: 'queueType', width: 120 },
  { title: '任务总数', key: 'taskCount', width: 100 },
  { title: '已完成任务', key: 'completedTaskCount', width: 100 },
  { title: '拒绝任务数', key: 'rejectCount', width: 100 },
  { title: 'TPS', key: 'tps', width: 80 },
  { title: '平均耗时(ms)', key: 'avg', width: 120 },
  { title: '是否动态', key: 'dynamic', width: 80, render: (row: Api.Monitor.ThreadPool) => (row.dynamic ? '是' : '否') },
  {
    title: '操作',
    key: 'actions',
    width: 120,
    render: (row: Api.Monitor.ThreadPool) => {
      return h(
        NSpace,
        { size: 'small' },
        {
          default: () => [
            h(
              NButton,
              {
                size: 'small',
                type: 'primary',
                onClick: () => handleViewDetail(row.poolName)
              },
              { default: () => '详情' }
            )
          ]
        }
      );
    }
  }
];

// 表单验证规则
const rules = {};

// 计算统计信息
const computedStatistics = computed(() => {
  if (!statistics.value) return [];

  return [
    {
      title: '线程池总数',
      value: statistics.value.poolName || '0',
      icon: 'monitor'
    },
    {
      title: '活跃线程数',
      value: statistics.value.activeCount || '0',
      icon: 'trending'
    },
    {
      title: '任务完成率',
      value: statistics.value.taskCount > 0 ? `${((statistics.value.completedTaskCount / statistics.value.taskCount) * 100).toFixed(1)}%` : '0%',
      icon: 'speed'
    },
    {
      title: '拒绝任务数',
      value: statistics.value.rejectCount || '0',
      icon: 'error'
    }
  ];
});

// 方法
const loadData = async () => {
  loading.value = true;
  try {
    const [listRes, statsRes, metricsRes] = await Promise.all([
      fetchGetThreadPoolList({
        page: pagination.page,
        pageSize: pagination.pageSize,
        ...searchForm
      }),
      fetchGetThreadPoolStatistics(),
      fetchGetThreadPoolMetrics()
    ]);

    tableData.value = listRes.data?.records || [];
    pagination.total = listRes.data?.total || 0;
    statistics.value = statsRes.data;
    metrics.value = metricsRes.data || [];
  } catch (error) {
    message.error('加载数据失败');
    console.error('加载数据失败:', error);
  } finally {
    loading.value = false;
  }
};

const handleSearch = () => {
  pagination.page = 1;
  loadData();
};

const handleReset = () => {
  Object.assign(searchForm, {
    poolName: '',
    queueType: null,
    dynamic: null
  });
  pagination.page = 1;
  loadData();
};

const handlePageChange = (page: number) => {
  pagination.page = page;
  loadData();
};

const handlePageSizeChange = (pageSize: number) => {
  pagination.pageSize = pageSize;
  pagination.page = 1;
  loadData();
};

const handleViewDetail = (poolName: string) => {
  // 跳转到详情页面或打开详情弹窗
  message.info(`查看线程池详情: ${poolName}`);
};

const getProgressColor = (percentage: number) => {
  if (percentage < 50) return '#52c41a';
  if (percentage < 80) return '#faad14';
  return '#ff4d4f';
};

// 生命周期
onMounted(() => {
  loadData();
});
</script>

<style scoped>
.stat-card {
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
</style>
