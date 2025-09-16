<script setup lang="ts">
import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useServiceApi } from '@/service/api/service';
import ServiceSearch from './modules/service-search.vue';
import ServiceCard from './modules/service-card.vue';
import ServiceDetailModal from './modules/service-detail-modal.vue';
import { type Service } from './modules/shared';

const router = useRouter();
const serviceApi = useServiceApi();

// 响应式数据
const services = ref<Service[]>([]);
const loading = ref(false);
const searchKeyword = ref('');

// 服务详情弹窗相关
const showDetailModal = ref(false);
const selectedServiceName = ref('');

// 计算属性
const filteredServices = computed(() => {
  if (!searchKeyword.value) return services.value;
  return services.value.filter((service) => service.serviceName.toLowerCase().includes(searchKeyword.value.toLowerCase()));
});

// 获取服务列表
async function getServiceList() {
  loading.value = true;
  try {
    const response = await serviceApi.getServiceList();
    services.value = response.data || [];
  } catch (error) {
    console.error('获取服务列表失败:', error);
    // 可以添加消息提示
  } finally {
    loading.value = false;
  }
}

// 刷新服务列表
async function refreshServiceList() {
  await getServiceList();
}

// 处理搜索
function handleSearch(keyword: string) {
  searchKeyword.value = keyword;
}

// 查看服务详情 - 改为打开弹窗
function viewServiceDetail(serviceName: string) {
  selectedServiceName.value = serviceName;
  showDetailModal.value = true;
}

// 关闭详情弹窗
function closeDetailModal() {
  showDetailModal.value = false;
  selectedServiceName.value = '';
}

onMounted(() => {
  getServiceList();
});
</script>

<template>
  <div class="p-6">
    <!-- 搜索和操作栏 -->
    <ServiceSearch :loading="loading"
                   @search="handleSearch"
                   @refresh="refreshServiceList" />

    <!-- 服务列表 -->
    <NCard :bordered="false">
      <div v-if="loading"
           class="flex items-center justify-center py-12">
        <NSpin size="large" />
      </div>

      <div v-else-if="filteredServices.length === 0"
           class="flex items-center justify-center py-12">
        <NEmpty :description="$t('page.servicePage.noServiceData')">
          <template #extra>
            <NButton @click="refreshServiceList">{{ $t('page.servicePage.refresh') }}</NButton>
          </template>
        </NEmpty>
      </div>

      <div v-else
           class="grid grid-cols-1 gap-6 lg:grid-cols-2 xl:grid-cols-3">
        <ServiceCard v-for="service in filteredServices"
                     :key="service.serviceName"
                     :service="service"
                     @view-detail="viewServiceDetail" />
      </div>
    </NCard>

    <!-- 服务详情弹窗 -->
    <ServiceDetailModal v-model:show="showDetailModal"
                         :service-name="selectedServiceName"
                         @close="closeDetailModal" />
  </div>
</template>
